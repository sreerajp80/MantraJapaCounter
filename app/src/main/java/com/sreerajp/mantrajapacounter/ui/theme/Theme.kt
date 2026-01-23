package com.sreerajp.mantrajapacounter.ui.theme

import android.app.Activity
import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalView
import androidx.core.view.WindowCompat

/**
 * Dark color scheme for MantraJapaCounter
 * Uses cyan/teal primary colors with blue/teal backgrounds for better readability in dark mode
 */
private val DarkColorScheme = darkColorScheme(
    primary = Color(0xFF06B6D4),      // Cyan for primary UI elements
    secondary = Color(0xFF0891B2),    // Dark cyan for secondary elements
    tertiary = Color(0xFF7C3AED),     // Purple for tertiary accent
    background = Color(0xFF1E3A8A),   // Deep blue background
    surface = Color(0xFF0F766E),      // Teal surface for cards
    onPrimary = Color.White,          // White text on primary
    onSecondary = Color.White,        // White text on secondary
    onTertiary = Color.White,         // White text on tertiary
    onBackground = Color.White,       // White text on background
    onSurface = Color.White,          // White text on surface
)

/**
 * Light color scheme for MantraJapaCounter
 * Uses cyan/teal primary colors with light backgrounds for better readability in light mode
 */
private val LightColorScheme = lightColorScheme(
    primary = Color(0xFF06B6D4),      // Cyan for primary UI elements
    secondary = Color(0xFF0891B2),    // Dark cyan for secondary elements
    tertiary = Color(0xFF7C3AED),     // Purple for tertiary accent
    background = Color(0xFFF8FAFC),   // Light blue-grey background
    surface = Color.White,             // White surface for cards
    onPrimary = Color.White,          // White text on primary
    onSecondary = Color.White,        // White text on secondary
    onTertiary = Color.White,         // White text on tertiary
    onBackground = Color(0xFF1E293B), // Dark text on light background
    onSurface = Color(0xFF1E293B),    // Dark text on light surface
)

/**
 * Main theme composable for the MantraJapaCounter app
 * Applies Material 3 design system with dynamic colors for Android 12+
 * Handles system theme switching and status bar styling
 *
 * @param darkTheme Whether to use dark theme (defaults to system preference)
 * @param dynamicColor Whether to use system colors on Android 12+ (defaults to true)
 * @param content The composable content to apply the theme to
 */
@Composable
fun MantraJapaCounterTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    // Dynamic color is available on Android 12+
    dynamicColor: Boolean = true,
    content: @Composable () -> Unit
) {
    // ===== COLOR SCHEME SELECTION =====
    // Choose color scheme based on theme preference and device capabilities
    val colorScheme = when {
        dynamicColor && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
            val context = LocalContext.current
            if (darkTheme) dynamicDarkColorScheme(context) else dynamicLightColorScheme(context)
        }

        darkTheme -> DarkColorScheme
        else -> LightColorScheme
    }

    // ===== STATUS BAR STYLING =====
    // Apply color scheme to system UI elements (status bar, navigation bar)
    val view = LocalView.current
    if (!view.isInEditMode) {
        SideEffect {
            val window = (view.context as Activity).window
            val insetsController = WindowCompat.getInsetsController(window, view)

            // Set status bar color (suppressing deprecation warning as we need backwards compatibility)
            @Suppress("DEPRECATION")
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                window.statusBarColor = colorScheme.primary.toArgb()
            }

            // Set status bar appearance (light/dark icons based on theme)
            insetsController.isAppearanceLightStatusBars = !darkTheme
        }
    }

    // ===== APPLY MATERIAL THEME =====
    // Apply Material 3 color scheme and typography
    MaterialTheme(
        colorScheme = colorScheme,
        typography = AppTypography,
        content = content
    )
}
