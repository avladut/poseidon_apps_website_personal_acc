import 'package:flutter/material.dart';

class Responsive {
  Responsive._();

  static const double mobileBreak = 720;
  static const double tabletBreak = 960;
  static const double maxContent = 1180;

  static bool isMobile(BuildContext c) =>
      MediaQuery.sizeOf(c).width < mobileBreak;

  static bool isTablet(BuildContext c) {
    final w = MediaQuery.sizeOf(c).width;
    return w >= mobileBreak && w < tabletBreak;
  }

  static bool isDesktop(BuildContext c) =>
      MediaQuery.sizeOf(c).width >= tabletBreak;

  static double horizontalPadding(BuildContext c) {
    final w = MediaQuery.sizeOf(c).width;
    if (w < 500) return 20;
    if (w < mobileBreak) return 28;
    if (w < tabletBreak) return 40;
    return 48;
  }
}
