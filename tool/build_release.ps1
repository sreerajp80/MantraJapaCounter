<#
.SYNOPSIS
  Builds the Android app, gives the output files clear names and writes a SHA-256 file for each.

.DESCRIPTION
  Runs `flutter build apk` or `flutter build appbundle`, then renames each output to
    <Name>-[<abi>-]v<version>_<build>-<flavor>-<mode>.<apk|aab>
  deletes Flutter's weak `.sha1` files, and writes `<file>.sha256` in `sha256sum` format.

  The work must happen here, after `flutter build`: the Flutter tool writes the `.sha1` file after
  Gradle ends, so a Gradle task cannot replace it.

  Works in Windows PowerShell 5.1 and PowerShell 7. Writes only inside `build/`. Never reads
  `android/key.properties` or the keystore (Gradle does the signing).

.EXAMPLE
  .\tool\build_release.ps1 -Name Japam -Target aab
.EXAMPLE
  .\tool\build_release.ps1 -Name Japam -Target apk
.EXAMPLE
  .\tool\build_release.ps1 -Name Japam -Target apk -Flavor dev -Mode debug
#>
[CmdletBinding()]
param(
    [string]$Name,

    [ValidateSet('apk', 'aab')]
    [string]$Target,

    [ValidateSet('dev', 'prod')]
    [string]$Flavor = 'prod',

    [ValidateSet('release', 'profile', 'debug')]
    [string]$Mode = 'release',

    [switch]$NoSplit,

    [switch]$NoObfuscate,

    [string]$SymbolsDir
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# The production flavor. A production release must always be obfuscated.
$ProductionFlavor = 'prod'

# Flutter's split-per-abi ABIs and the short names used in the final file names.
$AbiShortNames = [ordered]@{
    'armeabi-v7a' = 'armeabi'
    'arm64-v8a'   = 'arm64'
    'x86_64'      = 'x86_64'
}

function Stop-WithError([string]$Message) {
    Write-Host "ERROR: $Message" -ForegroundColor Red
    exit 1
}

# Lower-case SHA-256 of a file. Uses .NET directly, not Get-FileHash: Get-FileHash fails to load
# in Windows PowerShell 5.1 when it is started from PowerShell 7 (mixed PSModulePath).
function Get-Sha256Hex([string]$Path) {
    $sha = [Security.Cryptography.SHA256]::Create()
    $stream = [IO.File]::OpenRead($Path)
    try {
        $bytes = $sha.ComputeHash($stream)
    } finally {
        $stream.Dispose()
        $sha.Dispose()
    }
    return (-join ($bytes | ForEach-Object { $_.ToString('x2') }))
}

function Format-Size([long]$Bytes) {
    return ('{0:N1} MB' -f ($Bytes / 1MB))
}

# ---------------------------------------------------------------------------
# 1. Repo root and version
# ---------------------------------------------------------------------------
$RepoRoot = Split-Path -Parent $PSScriptRoot
$BuildDir = [IO.Path]::GetFullPath((Join-Path $RepoRoot 'build'))
$PubspecPath = Join-Path $RepoRoot 'pubspec.yaml'

if (-not (Test-Path -LiteralPath $PubspecPath)) {
    Stop-WithError "pubspec.yaml not found at '$PubspecPath'."
}

$VersionLine = Get-Content -LiteralPath $PubspecPath |
    Where-Object { $_ -match '^version:' } |
    Select-Object -First 1
if (-not $VersionLine) {
    Stop-WithError "No 'version:' line in pubspec.yaml."
}
if ($VersionLine -notmatch '^version:\s*([0-9]+\.[0-9]+\.[0-9]+)\+([0-9]+)\s*$') {
    Stop-WithError ("pubspec.yaml version must look like 'version: x.y.z+n' (with the +n build " +
        "number). Found: '$($VersionLine.Trim())'.")
}
$Version = $Matches[1]
$BuildNumber = $Matches[2]

# ---------------------------------------------------------------------------
# 2. Check the options (before Flutter runs)
# ---------------------------------------------------------------------------
if ([string]::IsNullOrEmpty($Name)) {
    Stop-WithError '-Name is required (the base file name, for example the app name).'
}
if ($Name -notmatch '^[A-Za-z0-9._-]+$') {
    Stop-WithError "-Name '$Name' may use only letters, digits, '.', '_' and '-'."
}
if ([string]::IsNullOrEmpty($Target)) {
    Stop-WithError "-Target is required: 'apk' or 'aab'."
}

$SymbolsDirGiven = $PSBoundParameters.ContainsKey('SymbolsDir')

if ($NoObfuscate -and $Flavor -eq $ProductionFlavor -and $Mode -eq 'release') {
    Stop-WithError ("-NoObfuscate is not allowed for a '$ProductionFlavor' release build. " +
        'Production releases must be obfuscated.')
}

$Obfuscate = -not $NoObfuscate
if ($Mode -eq 'debug' -and $Obfuscate) {
    if ($SymbolsDirGiven) {
        Stop-WithError '-SymbolsDir cannot be used: debug builds are never obfuscated.'
    }
    Write-Host 'Note: debug mode - --obfuscate and --split-debug-info are left out.' -ForegroundColor Yellow
    $Obfuscate = $false
}
if (-not $Obfuscate -and $SymbolsDirGiven) {
    Stop-WithError '-SymbolsDir cannot be used when the build is not obfuscated.'
}

$Split = ($Target -eq 'apk') -and (-not $NoSplit)
if ($NoSplit -and $Target -eq 'aab') {
    Write-Host 'Note: -NoSplit is ignored for aab.' -ForegroundColor Yellow
}

$SymbolsFullPath = $null
if ($Obfuscate) {
    if (-not $SymbolsDirGiven) {
        if ($Target -eq 'aab') {
            $SymbolsDir = "build/symbols/android-$Flavor-$Version/"
        } else {
            $SymbolsDir = "build/symbols/android-$Flavor-$Version-apk/"
        }
    }
    # Combine (not Join-Path) so an absolute -SymbolsDir is kept as given.
    $SymbolsFullPath = [IO.Path]::GetFullPath([IO.Path]::Combine($RepoRoot, $SymbolsDir)).TrimEnd('\', '/')
    if (-not $SymbolsFullPath.StartsWith($BuildDir + [IO.Path]::DirectorySeparatorChar,
            [StringComparison]::OrdinalIgnoreCase)) {
        Stop-WithError "-SymbolsDir must be inside '$BuildDir'. Got: '$SymbolsFullPath'."
    }
}

# ---------------------------------------------------------------------------
# Expected Flutter output paths (checked against Flutter 3.50.1:
# CopyFlutterApksTask.kt apkFileName and gradle.dart listApkPaths / findBundleFile)
# ---------------------------------------------------------------------------
$ModeTitle = $Mode.Substring(0, 1).ToUpperInvariant() + $Mode.Substring(1)
$FlavorLower = $Flavor.ToLowerInvariant()
$Outputs = @()   # each: @{ Source = <Flutter path>; Abi = <short ABI or $null> }

if ($Target -eq 'apk') {
    $ApkDir = Join-Path $RepoRoot 'build\app\outputs\flutter-apk'
    if ($Split) {
        foreach ($abi in $AbiShortNames.Keys) {
            $Outputs += @{
                Source = Join-Path $ApkDir "app-$abi-$FlavorLower-$Mode.apk"
                Abi    = $AbiShortNames[$abi]
            }
        }
    } else {
        $Outputs += @{ Source = Join-Path $ApkDir "app-$FlavorLower-$Mode.apk"; Abi = $null }
    }
} else {
    $BundleDir = Join-Path $RepoRoot "build\app\outputs\bundle\$Flavor$ModeTitle"
    $Outputs += @{ Source = Join-Path $BundleDir "app-$FlavorLower-$Mode.aab"; Abi = $null }
}

# ---------------------------------------------------------------------------
# Build
# ---------------------------------------------------------------------------
$FlutterArgs = @('build')
if ($Target -eq 'apk') { $FlutterArgs += 'apk' } else { $FlutterArgs += 'appbundle' }
$FlutterArgs += @('--flavor', $Flavor, "--$Mode")
if ($Obfuscate) {
    $FlutterArgs += @('--obfuscate', "--split-debug-info=$SymbolsFullPath")
}
if ($Split) { $FlutterArgs += '--split-per-abi' }

Push-Location -LiteralPath $RepoRoot
try {
    # 3. Delete old Flutter-named output first, so a stale file is never renamed as this build.
    $OldFiles = @()
    if ($Target -eq 'apk') {
        # Both split and universal names for this flavor and mode.
        foreach ($abi in $AbiShortNames.Keys) {
            $OldFiles += Join-Path $ApkDir "app-$abi-$FlavorLower-$Mode.apk"
        }
        $OldFiles += Join-Path $ApkDir "app-$FlavorLower-$Mode.apk"
        $OldFiles += $OldFiles | ForEach-Object { "$_.sha1" }
    } else {
        $OldFiles += $Outputs[0].Source
    }
    foreach ($old in $OldFiles) {
        if (Test-Path -LiteralPath $old) {
            Remove-Item -LiteralPath $old -Force
            Write-Host "Deleted old output: $old"
        }
    }

    # 4. Run Flutter. Stop on failure: rename and hash nothing.
    Write-Host ''
    Write-Host ("> flutter " + ($FlutterArgs -join ' ')) -ForegroundColor Cyan
    & flutter @FlutterArgs
    $FlutterExit = $LASTEXITCODE
    if ($FlutterExit -ne 0) {
        Stop-WithError "flutter build failed (exit code $FlutterExit). Nothing was renamed or hashed."
    }

    foreach ($o in $Outputs) {
        if (-not (Test-Path -LiteralPath $o.Source)) {
            Stop-WithError "Expected Flutter output not found: '$($o.Source)'. Nothing was renamed or hashed."
        }
    }

    # 5-7. Rename, delete .sha1, write .sha256.
    $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    $Results = @()
    foreach ($o in $Outputs) {
        $ext = [IO.Path]::GetExtension($o.Source)   # .apk or .aab
        $abiPart = ''
        if ($o.Abi) { $abiPart = "$($o.Abi)-" }
        $newName = "$Name-${abiPart}v${Version}_$BuildNumber-$Flavor-$Mode$ext"
        $dir = Split-Path -Parent $o.Source
        $newPath = Join-Path $dir $newName

        if (Test-Path -LiteralPath $newPath) {
            Write-Host "Replacing existing file: $newPath" -ForegroundColor Yellow
            Remove-Item -LiteralPath $newPath -Force
        }
        Move-Item -LiteralPath $o.Source -Destination $newPath

        $sha1Path = "$($o.Source).sha1"
        if (Test-Path -LiteralPath $sha1Path) {
            Remove-Item -LiteralPath $sha1Path -Force
        }

        $hash = Get-Sha256Hex $newPath
        # sha256sum format: "<hash>  <file name>\n", UTF-8 without BOM.
        [IO.File]::WriteAllText("$newPath.sha256", "$hash  $newName`n", $Utf8NoBom)

        $Results += [pscustomobject]@{
            Path   = $newPath
            Size   = (Get-Item -LiteralPath $newPath).Length
            Sha256 = $hash
        }
    }

    # 8. Summary.
    Write-Host ''
    Write-Host "Build done: $Target, flavor $Flavor, mode $Mode, v${Version}_$BuildNumber" -ForegroundColor Green
    foreach ($r in $Results) {
        Write-Host ''
        Write-Host "  $($r.Path)"
        Write-Host "    size   : $(Format-Size $r.Size) ($($r.Size) bytes)"
        Write-Host "    SHA-256: $($r.Sha256)"
        Write-Host "    hash   : $($r.Path).sha256"
    }
    Write-Host ''
    if ($Obfuscate) {
        Write-Host "Archive the debug symbols folder: $SymbolsFullPath" -ForegroundColor Green
    } else {
        Write-Host 'Not obfuscated: no debug symbols folder to archive.'
    }
}
finally {
    # 9. Stop the Gradle daemons so they do not hold memory.
    $Gradlew = Join-Path $RepoRoot 'android\gradlew.bat'
    if (Test-Path -LiteralPath $Gradlew) {
        Write-Host ''
        Write-Host '> android\gradlew.bat --stop' -ForegroundColor Cyan
        Push-Location -LiteralPath (Join-Path $RepoRoot 'android')
        try {
            & $Gradlew --stop | Out-Host
        } finally {
            Pop-Location
        }
    }
    Pop-Location
}
exit 0
