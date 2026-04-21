import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static TextTheme _buildTextTheme() {
    final inter = GoogleFonts.interTextTheme();
    final playfair = GoogleFonts.playfairDisplayTextTheme();

    TextStyle headline(TextStyle? base, double size) =>
        (base ?? const TextStyle()).copyWith(
          fontSize: size,
          fontWeight: FontWeight.w700,
          height: 1.12,
          letterSpacing: -size * 0.015,
          color: AppColors.text,
        );

    TextStyle body(
      TextStyle? base,
      double size, {
      Color? color,
      double height = 1.65,
      FontWeight weight = FontWeight.w400,
    }) =>
        (base ?? const TextStyle()).copyWith(
          fontSize: size,
          fontWeight: weight,
          height: height,
          color: color ?? AppColors.textDim,
        );

    return TextTheme(
      displayLarge: headline(playfair.displayLarge, 64),
      displayMedium: headline(playfair.displayMedium, 48),
      displaySmall: headline(playfair.displaySmall, 36),
      headlineLarge: headline(playfair.headlineLarge, 32),
      headlineMedium: body(
        inter.headlineMedium,
        22,
        color: AppColors.text,
        weight: FontWeight.w600,
        height: 1.4,
      ),
      titleLarge: body(
        inter.titleLarge,
        20,
        color: AppColors.text,
        weight: FontWeight.w600,
        height: 1.4,
      ),
      titleMedium: body(
        inter.titleMedium,
        16,
        color: AppColors.text,
        weight: FontWeight.w600,
        height: 1.4,
      ),
      bodyLarge: body(inter.bodyLarge, 17),
      bodyMedium: body(inter.bodyMedium, 15),
      bodySmall: body(inter.bodySmall, 13, color: AppColors.muted),
      labelLarge: body(
        inter.labelLarge,
        15,
        color: AppColors.text,
        weight: FontWeight.w600,
        height: 1.3,
      ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.bg,
        primary: AppColors.accent,
        secondary: AppColors.accent2,
        onPrimary: AppColors.bg,
        onSurface: AppColors.text,
      ),
      textTheme: _buildTextTheme(),
      dividerColor: AppColors.line,
      splashFactory: NoSplash.splashFactory,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }
}
