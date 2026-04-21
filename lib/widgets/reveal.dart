import 'package:flutter/material.dart';

/// Fades + slides the child in from below once, shortly after mount.
/// Use `delay` to stagger a group of reveals.
class Reveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final double offset;
  final Duration duration;

  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = 24,
    this.duration = const Duration(milliseconds: 700),
  });

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fade,
      builder: (context, child) {
        return Opacity(
          opacity: _fade.value,
          child: Transform.translate(
            offset: Offset(0, (1 - _fade.value) * widget.offset),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
