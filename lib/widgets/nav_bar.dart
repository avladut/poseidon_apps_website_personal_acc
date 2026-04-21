import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'brand_logo.dart';
import 'primary_button.dart';
import 'responsive.dart';

class NavBar extends StatelessWidget {
  final VoidCallback onServices;
  final VoidCallback onApproach;
  final VoidCallback onAbout;
  final VoidCallback onContact;

  const NavBar({
    super.key,
    required this.onServices,
    required this.onApproach,
    required this.onAbout,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final hPad = Responsive.horizontalPadding(context);
    final screenW = MediaQuery.sizeOf(context).width;
    final showBrandText = !isMobile || screenW > 420;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            height: 76,
            padding: EdgeInsets.symmetric(horizontal: hPad),
            decoration: BoxDecoration(
              color: AppColors.bg.withOpacity(0.72),
              border: Border(bottom: BorderSide(color: AppColors.line)),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: Responsive.maxContent),
                child: Row(
                  children: [
                    BrandLogo(showText: showBrandText),
                    const Spacer(),
                    if (!isMobile) ...[
                      _NavLink(label: 'Services', onTap: onServices),
                      const SizedBox(width: 24),
                      _NavLink(label: 'Approach', onTap: onApproach),
                      const SizedBox(width: 24),
                      _NavLink(label: 'About', onTap: onAbout),
                      const SizedBox(width: 20),
                    ],
                    AppButton(
                      label: 'Contact',
                      variant: ButtonVariant.ghost,
                      onPressed: onContact,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _NavLink({required this.label, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: _hovered ? AppColors.text : AppColors.textDim,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}
