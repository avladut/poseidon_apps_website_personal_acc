import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/eyebrow_label.dart';
import '../widgets/hover_lift.dart';
import '../widgets/responsive.dart';
import '../widgets/reveal.dart';
import '../widgets/section_container.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  static const _services = <_Service>[
    _Service(
      icon: Icons.language_rounded,
      title: 'Websites',
      description:
          'Fast, accessible, beautifully crafted sites — from marketing pages to full e-commerce and customer portals. Built to rank, convert, and scale.',
      tags: ['Marketing sites', 'E-commerce', 'Customer portals', 'Headless CMS'],
    ),
    _Service(
      icon: Icons.phone_iphone_rounded,
      title: 'Mobile Apps',
      description:
          'Native-feel iOS and Android apps with a single modern codebase. Clean UX, offline-first where it matters, and painless app-store releases.',
      tags: ['iOS & Android', 'Flutter', 'Push & payments', 'Store launches'],
    ),
    _Service(
      icon: Icons.hub_rounded,
      title: 'Workflow Automation',
      description:
          'We connect your tools and replace the spreadsheets. From lead capture to invoicing, onboarding to reporting — fewer clicks, fewer mistakes.',
      tags: ['Integrations', 'AI workflows', 'Internal tools', 'Reporting'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final t = Theme.of(context).textTheme;

    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Reveal(
            child: EyebrowLabel('What we do', align: TextAlign.center),
          ),
          const SizedBox(height: 20),
          Reveal(
            delay: const Duration(milliseconds: 80),
            child: Text(
              'Three disciplines. One studio.',
              textAlign: TextAlign.center,
              style: isMobile ? t.displaySmall : t.displayMedium,
            ),
          ),
          const SizedBox(height: 18),
          Reveal(
            delay: const Duration(milliseconds: 160),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Text(
                "Most clients engage us for one service and stay for all three — because a website, an app, and the automations behind them work best when they're built together.",
                textAlign: TextAlign.center,
                style: t.bodyLarge,
              ),
            ),
          ),
          const SizedBox(height: 64),
          LayoutBuilder(
            builder: (context, constraints) {
              final cols = constraints.maxWidth > 860
                  ? 3
                  : constraints.maxWidth > 560
                      ? 2
                      : 1;
              const gap = 24.0;
              final w = (constraints.maxWidth - gap * (cols - 1)) / cols;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (var i = 0; i < _services.length; i++)
                    SizedBox(
                      width: w,
                      child: Reveal(
                        delay: Duration(milliseconds: 120 * i),
                        child: _ServiceCard(service: _services[i]),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Service {
  final IconData icon;
  final String title;
  final String description;
  final List<String> tags;

  const _Service({
    required this.icon,
    required this.title,
    required this.description,
    required this.tags,
  });
}

class _ServiceCard extends StatelessWidget {
  final _Service service;
  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return HoverLift(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.accent.withOpacity(0.14),
                    AppColors.accent2.withOpacity(0.14),
                  ],
                ),
                border: Border.all(color: AppColors.line),
              ),
              child: Icon(service.icon, color: AppColors.accent, size: 26),
            ),
            const SizedBox(height: 22),
            Text(service.title, style: t.headlineMedium),
            const SizedBox(height: 10),
            Text(service.description, style: t.bodyMedium),
            const SizedBox(height: 22),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final tag in service.tags)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textDim,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
