import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../widgets/eyebrow_label.dart';
import '../widgets/responsive.dart';
import '../widgets/reveal.dart';
import '../widgets/section_container.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  static const _stats = <_Stat>[
    _Stat('100%', 'Senior engineers & designers'),
    _Stat('2–8 wks', 'Typical project window'),
    _Stat('24h', 'Response to enquiries'),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final t = Theme.of(context).textTheme;

    return SectionContainer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final twoCol = constraints.maxWidth > 860;

          final left = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Reveal(child: EyebrowLabel('About')),
              const SizedBox(height: 16),
              Reveal(
                delay: const Duration(milliseconds: 60),
                child: Text(
                  'Small team. Serious craft.',
                  style: isMobile ? t.displaySmall : t.displayMedium,
                ),
              ),
              const SizedBox(height: 20),
              Reveal(
                delay: const Duration(milliseconds: 120),
                child: Text(
                  'Poseidon Apps is an independent studio building software for founders and operators who want results, not overhead. We take on a handful of engagements at a time so every client gets senior attention end-to-end.',
                  style: t.bodyLarge,
                ),
              ),
              const SizedBox(height: 14),
              Reveal(
                delay: const Duration(milliseconds: 180),
                child: Text(
                  "We're equally comfortable shipping a polished marketing site, a cross-platform mobile app, or the automations that make a lean team run like a much larger one.",
                  style: t.bodyLarge,
                ),
              ),
            ],
          );

          final right = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < _stats.length; i++) ...[
                Reveal(
                  delay: Duration(milliseconds: 200 + i * 100),
                  child: _StatTile(stat: _stats[i]),
                ),
                if (i < _stats.length - 1) const SizedBox(height: 14),
              ],
            ],
          );

          if (twoCol) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 6, child: left),
                const SizedBox(width: 64),
                Expanded(flex: 4, child: right),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [left, const SizedBox(height: 40), right],
          );
        },
      ),
    );
  }
}

class _Stat {
  final String value;
  final String label;
  const _Stat(this.value, this.label);
}

class _StatTile extends StatelessWidget {
  final _Stat stat;
  const _StatTile({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            stat.value,
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.label,
            style: const TextStyle(
              fontSize: 13.5,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
