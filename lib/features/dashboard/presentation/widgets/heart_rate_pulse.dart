import 'package:flutter/material.dart';

class HeartRatePulse extends StatefulWidget {
  final double heartRate;
  final Color color;

  const HeartRatePulse({
    super.key,
    required this.heartRate,
    required this.color,
  });

  @override
  State<HeartRatePulse> createState() => _HeartRatePulseState();
}

class _HeartRatePulseState extends State<HeartRatePulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _updateBpm();
  }

  void _updateBpm() {
    final bpm = widget.heartRate > 0 ? widget.heartRate : 72;
    final duration = Duration(
      milliseconds: (60000 / bpm).round(),
    );

    _controller = AnimationController(
      duration: duration,
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(HeartRatePulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((widget.heartRate - oldWidget.heartRate).abs() > 5) {
      _controller.dispose();
      _updateBpm();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: Icon(
        Icons.favorite,
        color: widget.color,
        size: 32,
      ),
    );
  }
}