import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../widgets/eyebrow_label.dart';
import '../widgets/responsive.dart';
import '../widgets/reveal.dart';
import '../widgets/section_container.dart';

class ApproachSection extends StatelessWidget {
  const ApproachSection({super.key});

  static const _steps = <_Step>[
    _Step('01', 'Discover',
        'A focused working session to map what you have, what you need, and where the real leverage is.'),
    _Step('02', 'Design',
        'Clickable prototypes and a shipping plan — priced, scoped, and scheduled before a single line of production code.'),
    _Step('03', 'Build',
        "Weekly demos, a live staging link, and a clear changelog. You always know what's done and what's next."),
    _Step('04', 'Operate',
        'Monitoring, iteration, and automations that keep paying off — long after launch day.'),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final t = Theme.of(context).textTheme;

    return SectionContainer(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0x000A1222),
          AppColors.bgSoft,
          Color(0x000A1222),
        ],
        stops: [0, 0.5, 1],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Reveal(
            child: EyebrowLabel('How we work', align: TextAlign.center),
          ),
          const SizedBox(height: 20),
          Reveal(
            delay: const Duration(milliseconds: 80),
            child: Text(
              'A calm, senior process.',
              textAlign: TextAlign.center,
              style: isMobile ? t.displaySmall : t.displayMedium,
            ),
          ),
          const SizedBox(height: 18),
          Reveal(
            delay: const Duration(milliseconds: 160),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Text(
                'No agency theatre. You work directly with the people building your product.',
                textAlign: TextAlign.center,
                style: t.bodyLarge,
              ),
            ),
          ),
          const SizedBox(height: 64),
          LayoutBuilder(
            builder: (context, constraints) {
              final cols = constraints.maxWidth > 900
                  ? 4
                  : constraints.maxWidth > 560
                      ? 2
                      : 1;
              const gap = 20.0;
              final w = (constraints.maxWidth - gap * (cols - 1)) / cols;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (var i = 0; i < _steps.length; i++)
                    SizedBox(
                      width: w,
                      child: Reveal(
                        delay: Duration(milliseconds: 100 * i),
                        child: _StepCard(step: _steps[i]),
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

class _Step {
  final String number;
  final String title;
  final String description;
  const _Step(this.number, this.title, this.description);
}

class _StepCard extends StatelessWidget {
  final _Step step;
  const _StepCard({required this.step});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ShaderMask(
            shaderCallback: (rect) =>
                AppColors.primaryGradient.createShader(rect),
            child: Text(
              step.number,
              style: GoogleFonts.playfairDisplay(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(step.title, style: t.titleLarge),
          const SizedBox(height: 6),
          Text(step.description, style: t.bodyMedium),
        ],
      ),
    );
  }
}
