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

