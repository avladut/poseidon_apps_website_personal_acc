import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Surfaces
  static const Color bg = Color(0xFF05080F);
  static const Color bgSoft = Color(0xFF0A1222);
  static const Color bgMuted = Color(0xFF0D1730);
  static const Color surface = Color(0xFF111A33);

  // Text
  static const Color text = Color(0xFFE7ECF5);
  static const Color textDim = Color(0xFFAAB3C8);
  static const Color muted = Color(0xFF8590A8);

  // Accents
  static const Color accent = Color(0xFF7EE8FA);
  static const Color accent2 = Color(0xFF9F7AEA);
  static const Color accentWarm = Color(0xFFEEC0C6);

  // Lines (non-const because of withOpacity)
  static final Color line = Colors.white.withOpacity(0.08);
  static final Color lineStrong = Colors.white.withOpacity(0.16);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accent2],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x0AFFFFFF), Color(0x02FFFFFF)],
  );
}
