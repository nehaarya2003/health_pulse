import '../../../ble/domain/entities/health_metric.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/health_simulator.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final HealthSimulator simulator;

  DashboardRepositoryImpl(this.simulator);

  @override
  Stream<HealthMetric> getHealthMetrics() => simulator.stream;

  @override
  void stopMetrics() => simulator.dispose();
}