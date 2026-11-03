import 'package:flutter/material.dart';
import '../../../../core/widgets/animated_number.dart';
import '../../../dashboard/domain/entities/health_metric.dart';
import '../../domain/entities/health_history.dart';
import 'health_chart.dart';

class HistoryCard extends StatelessWidget {
  final HealthHistory history;

  const HistoryCard({super.key, required this.history});

  Color get _color {
    switch (history.type) {
      case MetricType.heartRate:
        return const Color(0xFFFF5C5C);
      case MetricType.spo2:
        return Colors.blue;
      case MetricType.hrv:
        return Colors.amber;
      case MetricType.steps:
        return Colors.green;
      default:
        return Colors.purple;
    }
  }

  String get _unit {
    switch (history.type) {
      case MetricType.heartRate:
        return 'bpm';
      case MetricType.spo2:
        return '%';
      case MetricType.hrv:
        return 'ms';
      case MetricType.steps:
        return 'steps';
      default:
        return '';
    }
  }

  String get _label {
    switch (history.type) {
      case MetricType.heartRate:
        return 'Heart Rate';
      case MetricType.spo2:
        return 'Blood Oxygen (SpO2)';
      case MetricType.hrv:
        return 'Heart Rate Variability';
      case MetricType.steps:
        return 'Daily Steps';
      default:
        return '';
    }
  }

  IconData get _icon {
    switch (history.type) {
      case MetricType.heartRate:
        return Icons.favorite;
      case MetricType.spo2:
        return Icons.water_drop;
      case MetricType.hrv:
        return Icons.show_chart;
      case MetricType.steps:
        return Icons.directions_walk;
      default:
        return Icons.monitor_heart;
    }
  }

  // % change from first to last reading
  double get _trendPercent {
    final r = history.readings;
    if (r.length < 2 || r.first.value == 0) return 0;
    return (r.last.value - r.first.value) / r.first.value * 100;
  }

  int get _decimals => history.type == MetricType.steps ? 0 : 1;

  @override
  Widget build(BuildContext context) {
    final color = _color;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(_icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '7-day trend',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                _TrendBadge(percent: _trendPercent, color: color),
              ],
            ),
          ),

          // Stats row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _StatChip(
                  label: 'Avg',
                  value: history.average,
                  decimals: _decimals,
                  unit: _unit,
                  color: color,
                ),
                const SizedBox(width: 8),
                _StatChip(
                  label: 'Min',
                  value: history.min,
                  decimals: _decimals,
                  unit: _unit,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                _StatChip(
                  label: 'Max',
                  value: history.max,
                  decimals: _decimals,
                  unit: _unit,
                  color: Colors.grey,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Chart
          SizedBox(
            height: 170,
            child: Padding(
              padding: const EdgeInsets.only(right: 16, left: 8, bottom: 8),
              child: HealthChart(history: history, color: color),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _TrendBadge extends StatelessWidget {
  final double percent;
  final Color color;

  const _TrendBadge({required this.percent, required this.color});

  @override
  Widget build(BuildContext context) {
    final isFlat = percent.abs() < 0.5;
    final isUp = percent > 0;
    final icon = isFlat
        ? Icons.trending_flat
        : (isUp ? Icons.trending_up : Icons.trending_down);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            '${percent >= 0 ? '+' : ''}${percent.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final double value;
  final int decimals;
  final String unit;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.decimals,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final valueColor =
    color == Colors.grey ? Colors.grey.shade600 : color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
          AnimatedNumber(
            value: value,
            decimals: decimals,
            suffix: ' $unit',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}