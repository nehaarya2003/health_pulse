
import '../../../ble/domain/entities/health_metric.dart';

abstract class DashboardRepository {
  Stream<HealthMetric> getHealthMetrics();
  void stopMetrics();
}