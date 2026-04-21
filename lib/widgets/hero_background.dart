import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A looping painted background for the hero — three drifting glow blobs
/// plus faint horizon waves. Non-interactive.
class HeroBackground extends StatefulWidget {
  const HeroBackground({super.key});

  @override
  State<HeroBackground> createState() => _HeroBackgroundState();
}

class _HeroBackgroundState extends State<HeroBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 24),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => CustomPaint(
          painter: _HeroPainter(_controller.value),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _HeroPainter extends CustomPainter {
  final double t;
  _HeroPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final theta = t * 2 * math.pi;

    _blob(
      canvas,
      Offset(
        size.width * 0.12 + math.sin(theta) * 40,
        size.height * 0.22 + math.cos(theta) * 24,
      ),
      size.width * 0.42,
      AppColors.accent.withOpacity(0.28),
    );

    _blob(
      canvas,
      Offset(
        size.width * 0.88 + math.cos(theta * 1.3) * 40,
        size.height * 0.18 + math.sin(theta * 1.3) * 24,
      ),
      size.width * 0.36,
      AppColors.accent2.withOpacity(0.26),
    );

    _blob(
      canvas,
      Offset(
        size.width * 0.58 + math.sin(theta * 0.7) * 30,
        size.height * 0.95,
      ),
      size.width * 0.45,
      AppColors.accent.withOpacity(0.16),
    );

    // Horizon waves
    final linePaint = Paint()
      ..color = AppColors.accent.withOpacity(0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    for (var i = 0; i < 3; i++) {
      final path = Path();
      final yBase = size.height * (0.72 + i * 0.08);
      final amp = 12.0 + i * 6;
      final phase = theta + i * 1.2;
      path.moveTo(0, yBase);
      for (var x = 0.0; x <= size.width; x += 6) {
        path.lineTo(
          x,
          yBase + math.sin(x / size.width * 3.4 * math.pi + phase) * amp,
        );
      }
      canvas.drawPath(path, linePaint);
    }
  }

  void _blob(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color, color.withOpacity(0)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _HeroPainter oldDelegate) =>
      oldDelegate.t != t;
}
