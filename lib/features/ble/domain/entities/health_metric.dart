import 'package:equatable/equatable.dart';

enum MetricType { heartRate, spo2, hrv, steps, temperature, battery }

class HealthMetric extends Equatable {
  final MetricType type;
  final double value;
  final DateTime timestamp;
  final String unit;
  final MetricStatus status;

  const HealthMetric({
    required this.type,
    required this.value,
    required this.timestamp,
    required this.unit,
    required this.status,
  });

  String get displayValue {
    switch (type) {
      case MetricType.heartRate:
        return '${value.toInt()}';
      case MetricType.spo2:
        return '${value.toInt()}%';
      case MetricType.hrv:
        return '${value.toInt()}ms';
      case MetricType.steps:
        return '${value.toInt()}';
      case MetricType.temperature:
        return '${value.toStringAsFixed(1)}°C';
      case MetricType.battery:
        return '${value.toInt()}%';
    }
  }

  String get label {
    switch (type) {
      case MetricType.heartRate:
        return 'Heart Rate';
      case MetricType.spo2:
        return 'SpO2';
      case MetricType.hrv:
        return 'HRV';
      case MetricType.steps:
        return 'Steps';
      case MetricType.temperature:
        return 'Temperature';
      case MetricType.battery:
        return 'Battery';
    }
  }

  @override
  List<Object?> get props => [type, value, timestamp];
}

enum MetricStatus { normal, warning, critical }