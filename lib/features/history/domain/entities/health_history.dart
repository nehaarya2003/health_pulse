import 'package:equatable/equatable.dart';
import '../../dashboard/domain/entities/health_metric.dart';

class HealthHistory extends Equatable {
  final MetricType type;
  final List<HealthReading> readings;

  const HealthHistory({
    required this.type,
    required this.readings,
  });

  double get average {
    if (readings.isEmpty) return 0;
    return readings.map((r) => r.value).reduce((a, b) => a + b) /
        readings.length;
  }

  double get max {
    if (readings.isEmpty) return 0;
    return readings.map((r) => r.value).reduce((a, b) => a > b ? a : b);
  }

  double get min {
    if (readings.isEmpty) return 0;
    return readings.map((r) => r.value).reduce((a, b) => a < b ? a : b);
  }

  @override
  List<Object?> get props => [type, readings];
}

class HealthReading extends Equatable {
final DateTime timestamp;
final double value;

const HealthReading({
required this.timestamp,
required this.value,
});

@override
List<Object?> get props => [timestamp, value];
}
