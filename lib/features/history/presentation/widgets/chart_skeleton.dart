import 'package:flutter/material.dart';

/// Pulsing placeholder cards shown while history loads.
class ChartSkeleton extends StatefulWidget {
  const ChartSkeleton({super.key});

  @override
  State<ChartSkeleton> createState() => _ChartSkeletonState();
}

class _ChartSkeletonState extends State<ChartSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.35, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _bar(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.25),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _card() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      height: 230,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _bar(36, 36),
              const SizedBox(width: 12),
              _bar(120, 14),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _bar(70, 22),
              const SizedBox(width: 8),
              _bar(70, 22),
              const SizedBox(width: 8),
              _bar(70, 22),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(child: _bar(double.infinity, 0)),
          _bar(double.infinity, 90),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [_card(), _card(), _card()],
      ),
    );
  }
}