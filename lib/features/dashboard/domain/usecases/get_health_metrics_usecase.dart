import '../../../ble/domain/entities/health_metric.dart';
import '../repositories/dashboard_repository.dart';

class GetHealthMetricsUseCase {
  final DashboardRepository repository;

  GetHealthMetricsUseCase(this.repository);

  Stream<HealthMetric> call() => repository.getHealthMetrics();
}