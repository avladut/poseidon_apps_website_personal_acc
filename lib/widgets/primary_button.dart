import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum ButtonVariant { primary, secondary, ghost }

class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool large;
  final IconData? trailingIcon;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.large = false,
    this.trailingIcon,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isPrimary = widget.variant == ButtonVariant.primary;
    final isSecondary = widget.variant == ButtonVariant.secondary;
    final isGhost = widget.variant == ButtonVariant.ghost;

    final padding = widget.large
        ? const EdgeInsets.symmetric(horizontal: 28, vertical: 16)
        : const EdgeInsets.symmetric(horizontal: 22, vertical: 12);
    final fontSize = widget.large ? 16.0 : 14.5;

    final Color bg;
    final Gradient? gradient;
    final Color borderColor;
    final Color textColor;
    final List<BoxShadow>? shadow;

    if (isPrimary) {
      bg = Colors.transparent;
      gradient = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFA8F2FF), Color(0xFF7EE8FA), Color(0xFFB39CF5)],
        stops: [0, 0.55, 1],
      );
      borderColor = Colors.transparent;
      textColor = AppColors.bg;
      shadow = [
        BoxShadow(
          color: AppColors.accent.withValues(alpha: _hovered ? 0.55 : 0.35),
          blurRadius: _hovered ? 36 : 24,
          spreadRadius: _hovered ? 1 : 0,
          offset: Offset(0, _hovered ? 12 : 8),
        ),
        BoxShadow(
          color: AppColors.accent2.withValues(alpha: _hovered ? 0.32 : 0.18),
          blurRadius: _hovered ? 44 : 28,
          offset: const Offset(0, 4),
        ),
      ];
    } else if (isSecondary) {
      bg = Colors.white.withOpacity(_hovered ? 0.08 : 0.04);
      gradient = null;
      borderColor = _hovered ? AppColors.lineStrong : AppColors.line;
      textColor = AppColors.text;
      shadow = null;
    } else {
      bg = Colors.transparent;
      gradient = null;
      borderColor = _hovered ? AppColors.accent : AppColors.lineStrong;
      textColor = _hovered ? AppColors.accent : AppColors.text;
      shadow = null;
    }

    final liftY = _pressed ? 1.0 : (_hovered ? -1.5 : 0.0);

    return MouseRegion(
      cursor: widget.onPressed == null
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: padding,
          transform: Matrix4.translationValues(0, liftY, 0),
          decoration: BoxDecoration(
            color: bg,
            gradient: gradient,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: shadow,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: isPrimary ? FontWeight.w700 : FontWeight.w600,
                  color: textColor,
                  letterSpacing: isPrimary ? 0.2 : 0.1,
                ),
              ),
              if (widget.trailingIcon != null) ...[
                const SizedBox(width: 8),
                Icon(widget.trailingIcon, size: 18, color: textColor),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
