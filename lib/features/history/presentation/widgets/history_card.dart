import 'package:flutter/material.dart';
import '../../../ble/domain/entities/health_metric.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                    color: _color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(_icon, color: _color, size: 20),
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
                  value:
                  '${history.average.toStringAsFixed(1)} $_unit',
                  color: _color,
                ),
                const SizedBox(width: 8),
                _StatChip(
                  label: 'Min',
                  value: '${history.min.toStringAsFixed(1)} $_unit',
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                _StatChip(
                  label: 'Max',
                  value: '${history.max.toStringAsFixed(1)} $_unit',
                  color: Colors.grey,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Chart
          SizedBox(
            height: 160,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 16,
                left: 8,
                bottom: 8,
              ),
              child: HealthChart(
                history: history,
                color: _color,
              ),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color == Colors.grey
                  ? Colors.grey.shade600
                  : color,
            ),
          ),
        ],
      ),
    );
  }
}