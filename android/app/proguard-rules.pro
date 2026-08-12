# Flutter engine — always required
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# sqflite native plugin
-keep class com.tekartik.sqflite.** { *; }

# Play Core (deferred components / split install) — not used by this app.
# Flutter's embedding references these classes but they're only needed
# when shipping with deferred components. Suppress R8 missing-class errors.
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }
