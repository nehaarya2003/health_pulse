import 'package:equatable/equatable.dart';
import '../../domain/entities/health_metric.dart';

class DashboardState extends Equatable {
  final double heartRate;
  final double spo2;
  final double hrv;
  final double steps;
  final double temperature;
  final double battery;
  final bool isMonitoring;
  final Map<MetricType, MetricStatus> statuses;

  const DashboardState({
    this.heartRate = 0,
    this.spo2 = 0,
    this.hrv = 0,
    this.steps = 0,
    this.temperature = 0,
    this.battery = 0,
    this.isMonitoring = false,
    this.statuses = const {},
  });

  DashboardState copyWith({
    double? heartRate,
    double? spo2,
    double? hrv,
    double? steps,
    double? temperature,
    double? battery,
    bool? isMonitoring,
    Map<MetricType, MetricStatus>? statuses,
  }) {
    return DashboardState(
      heartRate: heartRate ?? this.heartRate,
      spo2: spo2 ?? this.spo2,
      hrv: hrv ?? this.hrv,
      steps: steps ?? this.steps,
      temperature: temperature ?? this.temperature,
      battery: battery ?? this.battery,
      isMonitoring: isMonitoring ?? this.isMonitoring,
      statuses: statuses ?? this.statuses,
    );
  }

  @override
  List<Object?> get props => [
    heartRate,
    spo2,
    hrv,
    steps,
    temperature,
    battery,
    isMonitoring,
  ];
}