# Implementation Plan: Align Project Structure, Code, and Docs with Guidelines

**Status:** Completed

## 1. Issue Description

The repository requires verification and alignment against the standards defined in `docs/guidelines/`:
1. **Code formatting**: 59 source/test files in `lib/` and `test/` need formatting with `dart format .`.
2. **Dependencies documentation**: `docs/dependencies.md` is missing `qr_flutter` and `mobile_scanner` which were added for optical sync.
3. **Docs standard header anatomy**: `docs/architecture.md`, `docs/release_process.md`, `docs/security.md`, and `docs/features.md` should include purpose paragraphs and standard "read first" relative links matching `docs/guidelines/DOCS_FOLDER_GUIDELINE.md`.
4. **Version & metadata alignment**: `docs/features.md` lists an outdated version number (`6.9.1+1`) which should be updated to `6.10.2+19` matching `pubspec.yaml` and `assets/config/app_config.json`.
5. **Quality checks**: All static analysis (`flutter analyze`) and automated tests (`flutter test`) must pass with 0 issues.

## 2. Files to Modify

- `docs/dependencies.md` — Add `qr_flutter` and `mobile_scanner` to the approved dependencies table.
- `docs/features.md` — Update version string to `6.10.2+19`, add purpose header and read-first links.
- `docs/architecture.md` — Add standard purpose paragraph and read-first relative links before section 1.
- `docs/release_process.md` — Add standard purpose paragraph and read-first relative links before section 1.
- `docs/security.md` — Add standard read-first relative links before section 1.
- `lib/**/*.dart`, `test/**/*.dart` — Format all Dart code files using `dart format .`.

## 3. Step-by-Step Implementation Steps

1. Update `docs/dependencies.md` to list `qr_flutter` and `mobile_scanner`.
2. Update `docs/features.md`, `docs/architecture.md`, `docs/release_process.md`, and `docs/security.md` to conform to `DOCS_FOLDER_GUIDELINE.md` header structure.
3. Run `dart format .` across all project Dart files.
4. Run `flutter analyze` to ensure 0 static analysis issues.
5. Run `flutter test` to ensure all 55+ automated tests pass.
6. Write a change log in `change_log/` upon completion.

## 4. Verification

- `dart format --output=none --set-exit-if-changed .` exits with code 0 (clean).
- `flutter analyze` exits with code 0 (0 issues).
- `flutter test` exits with code 0 (all tests passing).
