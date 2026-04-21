import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class HoverLift extends StatefulWidget {
  final Widget child;
  final double lift;
  final double radius;

  const HoverLift({
    super.key,
    required this.child,
    this.lift = 6,
    this.radius = 18,
  });

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
        transform:
            Matrix4.translationValues(0, _hovered ? -widget.lift : 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.18),
                    blurRadius: 44,
                    offset: const Offset(0, 20),
                  ),
                ]
              : null,
        ),
        child: widget.child,
      ),
    );
  }
}
