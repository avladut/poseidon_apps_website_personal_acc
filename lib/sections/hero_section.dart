import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/eyebrow_label.dart';
import '../widgets/hero_background.dart';
import '../widgets/primary_button.dart';
import '../widgets/responsive.dart';
import '../widgets/reveal.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback? onServices;
  final VoidCallback? onContact;

  const HeroSection({super.key, this.onServices, this.onContact});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final hPad = Responsive.horizontalPadding(context);
    final t = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          const Positioned.fill(child: HeroBackground()),
          Padding(
            padding: EdgeInsets.fromLTRB(
              hPad,
              isMobile ? 72 : 120,
              hPad,
              isMobile ? 64 : 110,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: Responsive.maxContent),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Reveal(
                      child:
                          EyebrowLabel('Digital studio · automation partner'),
                    ),
                    const SizedBox(height: 20),
                    Reveal(
                      delay: const Duration(milliseconds: 80),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 860),
                        child: ShaderMask(
                          shaderCallback: (rect) => const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFFFFFFF),
                              Color(0xFFBDD4FF),
                            ],
                          ).createShader(rect),
                          child: Text(
                            'Websites, mobile apps, and workflows that run themselves.',
                            style: (isMobile
                                    ? t.displaySmall
                                    : t.displayLarge)
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Reveal(
                      delay: const Duration(milliseconds: 160),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 640),
                        child: Text(
                          'We design and build software that turns manual work into '
                          'measurable growth — elegant websites, reliable mobile '
                          'apps, and automations that quietly handle the rest.',
                          style: t.bodyLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Reveal(
                      delay: const Duration(milliseconds: 240),
                      child: Wrap(
                        spacing: 14,
                        runSpacing: 14,
                        children: [
                          AppButton(
                            label: 'Start an enquiry',
                            large: true,
                            onPressed: onContact,
                            trailingIcon: Icons.arrow_forward_rounded,
                          ),
                          AppButton(
                            label: 'See what we do',
                            large: true,
                            variant: ButtonVariant.secondary,
                            onPressed: onServices,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 56),
                    Reveal(
                      delay: const Duration(milliseconds: 340),
                      child: Wrap(
                        spacing: 32,
                        runSpacing: 16,
                        children: const [
                          _HeroChip('Design-led', ' delivery'),
                          _HeroChip('Ship in weeks,', ' not quarters'),
                          _HeroChip('Automations', ' that pay for themselves'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final String strong;
  final String rest;
  const _HeroChip(this.strong, this.rest);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accent,
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.5),
                blurRadius: 12,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14.5,
              color: AppColors.muted,
              fontWeight: FontWeight.w400,
            ),
            children: [
              TextSpan(
                text: strong,
                style: const TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(text: rest),
            ],
          ),
        ),
      ],
    );
  }
}
