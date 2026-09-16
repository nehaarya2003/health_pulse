import 'package:flutter/material.dart';
import '../../domain/entities/health_metric.dart';

class MetricCard extends StatefulWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final MetricStatus status;

  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.status,
  });

  @override
  State<MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<MetricCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  String _previousValue = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(MetricCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _previousValue) {
      _previousValue = widget.value;
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _statusColor {
    switch (widget.status) {
      case MetricStatus.normal:
        return widget.color;
      case MetricStatus.warning:
        return Colors.orange;
      case MetricStatus.critical:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.status == MetricStatus.normal
                ? Colors.transparent
                : _statusColor.withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _statusColor.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon + status indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    widget.icon,
                    color: _statusColor,
                    size: 20,
                  ),
                ),
                if (widget.status != MetricStatus.normal)
                  Icon(
                    Icons.warning_amber_rounded,
                    color: _statusColor,
                    size: 16,
                  ),
              ],
            ),

            const Spacer(),

            // Value
            TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0,
                end: double.tryParse(
                    widget.value.replaceAll(RegExp(r'[^0-9.]'), '')) ??
                    0,
              ),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Text(
                  widget.value,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: _statusColor,
                    height: 1,
                  ),
                );
              },
            ),

            const SizedBox(height: 2),

            // Unit
            Text(
              widget.unit,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),

            const SizedBox(height: 4),

            // Label
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}