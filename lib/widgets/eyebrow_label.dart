import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class EyebrowLabel extends StatelessWidget {
  final String text;
  final TextAlign align;

  const EyebrowLabel(this.text, {super.key, this.align = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      textAlign: align,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 2.4,
        color: AppColors.accent,
      ),
    );
  }
}
