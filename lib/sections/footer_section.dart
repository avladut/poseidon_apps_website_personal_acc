import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../widgets/brand_logo.dart';
import '../widgets/section_container.dart';

class FooterSection extends StatelessWidget {
  final VoidCallback onServices;
  final VoidCallback onApproach;
  final VoidCallback onAbout;

  const FooterSection({
    super.key,
    required this.onServices,
    required this.onApproach,
    required this.onAbout,
  });

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;

    return SectionContainer(
      verticalPadding: 56,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontal = constraints.maxWidth > 760;

          final brand = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              BrandLogo(size: 38),
              SizedBox(height: 12),
              Text(
                'Websites · Mobile apps · Automation',
                style: TextStyle(fontSize: 13, color: AppColors.muted),
              ),
            ],
          );

          final links = Wrap(
            spacing: 24,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _FooterLink('Services', onServices),
              _FooterLink('Approach', onApproach),
              _FooterLink('About', onAbout),
              _FooterLink(
                'Contact',
                () => launchUrl(
                  Uri.parse('mailto:alex@poseidonapps.net'),
                ),
              ),
            ],
          );

          final copy = Text(
            '© $year Poseidon Apps. All rights reserved.',
            style: const TextStyle(fontSize: 12.5, color: AppColors.muted),
            textAlign: horizontal ? TextAlign.end : TextAlign.center,
          );

          if (horizontal) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: brand),
                links,
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: copy,
                  ),
                ),
              ],
            );
          }
          return Column(
            children: [
              brand,
              const SizedBox(height: 24),
              links,
              const SizedBox(height: 24),
              copy,
            ],
          );
        },
      ),
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _FooterLink(this.label, this.onTap);

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
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
            fontSize: 14,
            color: _hovered ? AppColors.text : AppColors.textDim,
            fontWeight: FontWeight.w500,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}
