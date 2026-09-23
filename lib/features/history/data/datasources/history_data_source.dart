import 'dart:math';
import '../../domain/entities/health_history.dart';
import '../../../dashboard/domain/entities/health_metric.dart';

class HistoryDataSource {
  final Random _random = Random();

  // Generate 7 days of mock historical data
  List<HealthHistory> generateHistory() {
    return [
      _generateMetricHistory(
        MetricType.heartRate,
        baseValue: 72,
        variance: 8,
      ),
      _generateMetricHistory(
        MetricType.spo2,
        baseValue: 98,
        variance: 1.5,
      ),
      _generateMetricHistory(
        MetricType.hrv,
        baseValue: 45,
        variance: 10,
      ),
      _generateMetricHistory(
        MetricType.steps,
        baseValue: 6500,
        variance: 2000,
      ),
    ];
  }

  HealthHistory _generateMetricHistory(
      MetricType type, {
        required double baseValue,
        required double variance,
      }) {
    final readings = <HealthReading>[];
    final now = DateTime.now();

    // Generate one reading per day for 7 days
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final value = baseValue +
          (variance * (_random.nextDouble() * 2 - 1));

      readings.add(HealthReading(
        timestamp: date,
        value: double.parse(value.toStringAsFixed(1)),
      ));
    }

    return HealthHistory(type: type, readings: readings);
  }
}