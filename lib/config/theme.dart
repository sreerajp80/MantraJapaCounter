import 'package:flutter/material.dart';

/// Temple theme — light, devotional palette inspired by South Indian temples.
/// Cream background, vermillion accents, sandal yellow highlights, tulsi green
/// for completion. EB Garamond italic for numerals and quiet labels;
/// Inter for everything else; Noto Sans Malayalam for Indic mantra names.
class TempleColors {
  TempleColors._();

  static const Color bg = Color(0xFFFBF6EC);
  static const Color bg2 = Color(0xFFF3EADA);
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardSoft = Color(0xFFF7EED8);
  static const Color ink = Color(0xFF2A1A08);
  static const Color ink2 = Color(0xFF5A4429);
  static const Color ink3 = Color(0xFF9A8568);
  static const Color line = Color(0xFFE8D9B8);
  static const Color vermillion = Color(0xFFC8401E);
  static const Color vermillionDeep = Color(0xFF9A2C10);
  static const Color sandal = Color(0xFFD8A13A);
  static const Color tulsi = Color(0xFF3F6B3A);
  static const Color rose = Color(0xFFB8506A);

  /// Rotation used to give each counter card its own accent. Order matches
  /// the design's example list: vermillion → tulsi → sandal → rose.
  static const List<Color> accentRotation = [vermillion, tulsi, sandal, rose];

  /// Deterministic accent for a counter, keyed off its stable id so the
  /// color never shifts when the list is reordered or new counters are added.
  /// Uses a code-unit sum (not String.hashCode) so the mapping is stable
  /// across Dart SDK versions and platforms.
  static Color accentForId(String id) {
    var sum = 0;
    for (var i = 0; i < id.length; i++) {
      sum = (sum + id.codeUnitAt(i)) & 0x7fffffff;
    }
    return accentRotation[sum % accentRotation.length];
  }
}

class AppTheme {
  AppTheme._();

  static const String _serifFamily = 'EBGaramond';
  static const String _sansFamily = 'Inter';
  static const String _malFamily = 'NotoSansMalayalam';

  /// Fallback chain so localized UI text (e.g. Malayalam) renders with the
  /// bundled Noto Sans Malayalam glyphs when the primary family (Inter /
  /// EB Garamond) has none. Used by every base text style below.
  static const List<String> _uiFallback = [_malFamily];

  /// EB Garamond (italic-friendly) — used for numerals and quiet captions.
  static TextStyle serif({
    double? fontSize,
    FontWeight fontWeight = FontWeight.w500,
    Color color = TempleColors.ink,
    FontStyle fontStyle = FontStyle.italic,
    double? height,
    double? letterSpacing,
  }) => TextStyle(
    fontFamily: _serifFamily,
    fontFamilyFallback: _uiFallback,
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    fontStyle: fontStyle,
    height: height,
    letterSpacing: letterSpacing,
  );

  /// Inter — primary UI sans. Used for body, labels, buttons.
  static TextStyle sans({
    double? fontSize,
    FontWeight fontWeight = FontWeight.w500,
    Color color = TempleColors.ink,
    double? height,
    double? letterSpacing,
  }) => TextStyle(
    fontFamily: _sansFamily,
    fontFamilyFallback: _uiFallback,
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );

  /// Noto Sans Malayalam — for Indic mantra names. Falls back to Inter for
  /// non-Malayalam glyphs via Flutter's font fallback chain.
  static TextStyle mal({
    double? fontSize,
    FontWeight fontWeight = FontWeight.w600,
    Color color = TempleColors.ink,
    double? height,
  }) => TextStyle(
    fontFamily: _malFamily,
    fontFamilyFallback: const [_sansFamily],
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
  );

  /// All-caps eyebrow label used throughout the design.
  static TextStyle eyebrow({
    double fontSize = 10,
    Color color = TempleColors.ink3,
    double letterSpacing = 1.5,
    FontWeight fontWeight = FontWeight.w600,
  }) => TextStyle(
    fontFamily: _sansFamily,
    fontFamilyFallback: _uiFallback,
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    letterSpacing: letterSpacing,
    height: 1.2,
  );

  static ThemeData light() {
    final scheme = ColorScheme(
      brightness: Brightness.light,
      primary: TempleColors.vermillion,
      onPrimary: Colors.white,
      primaryContainer: TempleColors.cardSoft,
      onPrimaryContainer: TempleColors.vermillionDeep,
      secondary: TempleColors.sandal,
      onSecondary: TempleColors.ink,
      tertiary: TempleColors.tulsi,
      onTertiary: Colors.white,
      error: TempleColors.vermillionDeep,
      onError: Colors.white,
      surface: TempleColors.card,
      onSurface: TempleColors.ink,
      surfaceContainerLowest: TempleColors.bg,
      surfaceContainerLow: TempleColors.bg2,
      surfaceContainer: TempleColors.cardSoft,
      surfaceContainerHigh: TempleColors.cardSoft,
      surfaceContainerHighest: TempleColors.card,
      onSurfaceVariant: TempleColors.ink2,
      outline: TempleColors.line,
      outlineVariant: TempleColors.line,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: TempleColors.ink,
      onInverseSurface: TempleColors.bg,
      inversePrimary: TempleColors.sandal,
    );

    final textTheme = ThemeData.light().textTheme.apply(
      fontFamily: _sansFamily,
      fontFamilyFallback: _uiFallback,
      bodyColor: TempleColors.ink,
      displayColor: TempleColors.ink,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: TempleColors.bg,
      canvasColor: TempleColors.bg,
      textTheme: textTheme,
      dividerColor: TempleColors.line,
      dividerTheme: const DividerThemeData(
        color: TempleColors.line,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: TempleColors.ink2, size: 20),
      appBarTheme: AppBarTheme(
        backgroundColor: TempleColors.bg,
        foregroundColor: TempleColors.ink,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: serif(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: TempleColors.ink,
        ),
      ),
      cardTheme: const CardThemeData(
        color: TempleColors.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: TempleColors.line),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) =>
              s.contains(WidgetState.selected) ? Colors.white : TempleColors.bg,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? TempleColors.vermillion
              : TempleColors.line,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? TempleColors.vermillion
              : TempleColors.line,
        ),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: TempleColors.vermillion,
        inactiveTrackColor: TempleColors.line,
        thumbColor: TempleColors.vermillion,
        overlayColor: Color(0x33C8401E),
        trackHeight: 2,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: TempleColors.vermillion,
        linearTrackColor: TempleColors.line,
        circularTrackColor: TempleColors.line,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: TempleColors.vermillion,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: TempleColors.vermillion),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: TempleColors.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: TempleColors.line),
        ),
        titleTextStyle: serif(fontSize: 20, color: TempleColors.ink),
        contentTextStyle: sans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: TempleColors.ink2,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: TempleColors.card,
        surfaceTintColor: Colors.transparent,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: TempleColors.ink,
        contentTextStyle: sans(color: TempleColors.bg, fontSize: 13),
        behavior: SnackBarBehavior.floating,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: TempleColors.card,
        surfaceTintColor: Colors.transparent,
        textStyle: sans(fontSize: 14, color: TempleColors.ink),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: TempleColors.line),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: TempleColors.ink2,
        textColor: TempleColors.ink,
        titleTextStyle: sans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: TempleColors.ink,
        ),
        subtitleTextStyle: serif(
          fontSize: 12,
          color: TempleColors.ink3,
          fontWeight: FontWeight.w400,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: sans(color: TempleColors.ink2, fontSize: 13),
        hintStyle: sans(color: TempleColors.ink3, fontSize: 13),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: TempleColors.vermillion, width: 2),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: TempleColors.line),
        ),
      ),
    );
  }
}
