import 'package:equatable/equatable.dart';

/// Current vitals sent to the coach.
class HealthSnapshot extends Equatable {
  final double heartRate;
  final double spo2;
  final double hrv;
  final double steps;
  final double temperature;

  const HealthSnapshot({
    required this.heartRate,
    required this.spo2,
    required this.hrv,
    required this.steps,
    required this.temperature,
  });

  @override
  List<Object?> get props => [heartRate, spo2, hrv, steps, temperature];
}