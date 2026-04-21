import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class BrandLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const BrandLogo({super.key, this.size = 42, this.showText = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.accent.withOpacity(0.18),
                AppColors.accent2.withOpacity(0.18),
              ],
            ),
            border: Border.all(color: AppColors.lineStrong),
          ),
          child: Padding(
            padding: EdgeInsets.all(size * 0.18),
            child: CustomPaint(painter: _TridentPainter()),
          ),
        ),
        if (showText) ...[
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Poseidon Apps',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 1),
              const Text(
                'BUILD · AUTOMATE · GROW',
                style: TextStyle(
                  fontSize: 9.5,
                  letterSpacing: 2.2,
                  color: AppColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _TridentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.accent, AppColors.accentWarm],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.11
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final path = Path()
      // Left prong
      ..moveTo(w * 0.12, h * 0.08)
      ..lineTo(w * 0.12, h * 0.36)
      // Right prong
      ..moveTo(w * 0.88, h * 0.08)
      ..lineTo(w * 0.88, h * 0.36)
      // Center prong / shaft
      ..moveTo(w * 0.5, h * 0.02)
      ..lineTo(w * 0.5, h * 0.92)
      // Horizontal bar
      ..moveTo(w * 0.12, h * 0.36)
      ..lineTo(w * 0.88, h * 0.36);

    canvas.drawPath(path, paint);

    final basePath = Path()
      ..moveTo(w * 0.28, h * 0.92)
      ..quadraticBezierTo(w * 0.5, h * 0.78, w * 0.72, h * 0.92);
    canvas.drawPath(basePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
