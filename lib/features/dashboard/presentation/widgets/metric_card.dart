import 'package:flutter/material.dart';
import '../../../../core/widgets/animated_number.dart';
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
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 160),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(MetricCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Small "pop" only when the status changes (normal -> warning etc.)
    if (oldWidget.status != widget.status) {
      _controller.forward().then((_) {
        if (mounted) _controller.reverse();
      });
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
    final numeric = double.tryParse(widget.value) ?? 0;
    final decimals = widget.value.contains('.')
        ? widget.value.split('.').last.length
        : 0;

    return ScaleTransition(
      scale: _scale,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(widget.icon, color: _statusColor, size: 20),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: widget.status == MetricStatus.normal ? 0 : 1,
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: _statusColor,
                    size: 16,
                  ),
                ),
              ],
            ),
            const Spacer(),
            AnimatedNumber(
              value: numeric,
              decimals: decimals,
              duration: const Duration(milliseconds: 500),
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: _statusColor,
                height: 1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              widget.unit,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 4),
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