import 'package:flutter/material.dart';

class BrandLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const BrandLogo({super.key, this.size = 42, this.showText = true});

  @override
  Widget build(BuildContext context) {
    final height = showText ? size * 1.4 : size;
    return Image.asset(
      'assets/logo.png',
      height: height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}
