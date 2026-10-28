import 'package:flutter/material.dart';

/// Counts smoothly from its previous value to the new value.
class AnimatedNumber extends StatelessWidget {
  final double value;
  final int decimals;
  final String suffix;
  final TextStyle? style;
  final Duration duration;

  const AnimatedNumber({
    super.key,
    required this.value,
    this.decimals = 0,
    this.suffix = '',
    this.style,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, animated, _) {
        return Text(
          '${animated.toStringAsFixed(decimals)}$suffix',
          style: style,
        );
      },
    );
  }
}