import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/health_metric.dart';
import '../../domain/usecases/get_health_metrics_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetHealthMetricsUseCase getHealthMetricsUseCase;

  DashboardBloc({required this.getHealthMetricsUseCase})
      : super(const DashboardState()) {
    on<StartMonitoringEvent>(_onStartMonitoring);
    on<StopMonitoringEvent>(_onStopMonitoring);
  }

  Future<void> _onStartMonitoring(
      StartMonitoringEvent event,
      Emitter<DashboardState> emit,
      ) async {
    emit(state.copyWith(isMonitoring: true));

    await emit.forEach(
      getHealthMetricsUseCase(),
      onData: (metric) {
        final newStatuses =
        Map<MetricType, MetricStatus>.from(state.statuses);
        newStatuses[metric.type] = metric.status;

        switch (metric.type) {
          case MetricType.heartRate:
            return state.copyWith(
              heartRate: metric.value,
              statuses: newStatuses,
            );
          case MetricType.spo2:
            return state.copyWith(
              spo2: metric.value,
              statuses: newStatuses,
            );
          case MetricType.hrv:
            return state.copyWith(
              hrv: metric.value,
              statuses: newStatuses,
            );
          case MetricType.steps:
            return state.copyWith(
              steps: metric.value,
              statuses: newStatuses,
            );
          case MetricType.temperature:
            return state.copyWith(
              temperature: metric.value,
              statuses: newStatuses,
            );
          case MetricType.battery:
            return state.copyWith(
              battery: metric.value,
              statuses: newStatuses,
            );
        }
      },
    );
  }

  Future<void> _onStopMonitoring(
      StopMonitoringEvent event,
      Emitter<DashboardState> emit,
      ) async {
    emit(state.copyWith(isMonitoring: false));
  }
}