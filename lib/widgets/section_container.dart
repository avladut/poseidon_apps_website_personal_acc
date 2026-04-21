import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'responsive.dart';

class SectionContainer extends StatelessWidget {
  final Widget child;
  final double verticalPadding;
  final Color? background;
  final Gradient? gradient;
  final bool bordered;

  const SectionContainer({
    super.key,
    required this.child,
    this.verticalPadding = 120,
    this.background,
    this.gradient,
    this.bordered = false,
  });

  @override
  Widget build(BuildContext context) {
    final hPad = Responsive.horizontalPadding(context);
    final vPad =
        Responsive.isMobile(context) ? verticalPadding * 0.65 : verticalPadding;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: background,
        gradient: gradient,
        border: bordered
            ? Border(
                top: BorderSide(color: AppColors.line),
                bottom: BorderSide(color: AppColors.line),
              )
            : null,
      ),
      padding: EdgeInsets.symmetric(vertical: vPad, horizontal: hPad),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Responsive.maxContent),
          child: child,
        ),
      ),
    );
  }
}
