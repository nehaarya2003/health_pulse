import 'dart:async';
import 'dart:math';

import '../../../ble/domain/entities/health_metric.dart';

class HealthSimulator {
  final Random _random = Random();
  StreamController<HealthMetric>? _controller;
  Timer? _timer;

  // Base values
  double _heartRate = 72.0;
  double _spo2 = 98.0;
  double _hrv = 45.0;
  double _steps = 0.0;
  double _temperature = 36.6;
  double _battery = 85.0;

  Stream<HealthMetric> get stream {
    _controller?.close();
    _controller = StreamController<HealthMetric>.broadcast();
    _startSimulation();
    return _controller!.stream;
  }

  void _startSimulation() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _emitAllMetrics();
    });
  }

  void _emitAllMetrics() {
    final now = DateTime.now();

    // Heart rate — sine wave + noise
    _heartRate = 72 +
        12 * sin(now.second * 0.1) +
        (_random.nextDouble() * 4 - 2);
    _heartRate = _heartRate.clamp(50.0, 120.0);

    // SpO2 — stays high with small variations
    _spo2 = 98 + (_random.nextDouble() * 2 - 1);
    _spo2 = _spo2.clamp(94.0, 100.0);

    // HRV — slower variation
    _hrv = 45 + 10 * sin(now.second * 0.05) +
        (_random.nextDouble() * 6 - 3);
    _hrv = _hrv.clamp(20.0, 80.0);

    // Steps — increment every few seconds
    if (now.second % 3 == 0) {
      _steps += _random.nextInt(5) + 1;
    }
    _steps = _steps.clamp(0.0, 10000.0);

    // Temperature — very stable
    _temperature = 36.6 + (_random.nextDouble() * 0.4 - 0.2);
    _temperature = _temperature.clamp(35.0, 38.5);

    // Battery — slowly drain
    _battery = (_battery - 0.001).clamp(0.0, 100.0);

    // Emit each metric
    _controller?.add(HealthMetric(
      type: MetricType.heartRate,
      value: _heartRate,
      timestamp: now,
      unit: 'bpm',
      status: _heartRateStatus(_heartRate),
    ));

    _controller?.add(HealthMetric(
      type: MetricType.spo2,
      value: _spo2,
      timestamp: now,
      unit: '%',
      status: _spo2Status(_spo2),
    ));

    _controller?.add(HealthMetric(
      type: MetricType.hrv,
      value: _hrv,
      timestamp: now,
      unit: 'ms',
      status: MetricStatus.normal,
    ));

    _controller?.add(HealthMetric(
      type: MetricType.steps,
      value: _steps,
      timestamp: now,
      unit: 'steps',
      status: MetricStatus.normal,
    ));

    _controller?.add(HealthMetric(
      type: MetricType.temperature,
      value: _temperature,
      timestamp: now,
      unit: '°C',
      status: _temperatureStatus(_temperature),
    ));

    _controller?.add(HealthMetric(
      type: MetricType.battery,
      value: _battery,
      timestamp: now,
      unit: '%',
      status: _batteryStatus(_battery),
    ));
  }

  MetricStatus _heartRateStatus(double hr) {
    if (hr < 60 || hr > 100) return MetricStatus.warning;
    if (hr < 50 || hr > 120) return MetricStatus.critical;
    return MetricStatus.normal;
  }

  MetricStatus _spo2Status(double spo2) {
    if (spo2 < 95) return MetricStatus.warning;
    if (spo2 < 90) return MetricStatus.critical;
    return MetricStatus.normal;
  }

  MetricStatus _temperatureStatus(double temp) {
    if (temp > 37.5) return MetricStatus.warning;
    if (temp > 38.5) return MetricStatus.critical;
    return MetricStatus.normal;
  }

  MetricStatus _batteryStatus(double battery) {
    if (battery < 20) return MetricStatus.warning;
    if (battery < 10) return MetricStatus.critical;
    return MetricStatus.normal;
  }

  void dispose() {
    _timer?.cancel();
    _controller?.close();
  }
}