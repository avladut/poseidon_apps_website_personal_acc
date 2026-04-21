import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/enquiry_form.dart';
import '../widgets/eyebrow_label.dart';
import '../widgets/responsive.dart';
import '../widgets/reveal.dart';
import '../widgets/section_container.dart';

class CtaSection extends StatelessWidget {
  const CtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final t = Theme.of(context).textTheme;

    return SectionContainer(
      verticalPadding: 140,
      bordered: true,
      gradient: const RadialGradient(
        center: Alignment.topCenter,
        radius: 1.2,
        colors: [Color(0x267EE8FA), Color(0x007EE8FA)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Reveal(
            child: EyebrowLabel('Enquiries', align: TextAlign.center),
          ),
          const SizedBox(height: 20),
          Reveal(
            delay: const Duration(milliseconds: 80),
            child: Text(
              "Tell us what you're building.",
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
                'A few minutes of context helps us come back with the right next steps — not a generic intake call.',
                textAlign: TextAlign.center,
                style: t.bodyLarge,
              ),
            ),
          ),
          const SizedBox(height: 48),
          const Reveal(
            delay: Duration(milliseconds: 220),
            child: EnquiryForm(),
          ),
          const SizedBox(height: 24),
          const Reveal(
            delay: Duration(milliseconds: 320),
            child: Text(
              'Prefer email? alex@poseidonapps.net',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
