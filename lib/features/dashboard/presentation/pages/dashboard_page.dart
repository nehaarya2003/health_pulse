import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../ble/presentation/pages/ble_scanner_page.dart';
import '../../data/datasources/health_simulator.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/health_metric.dart';
import '../../domain/usecases/get_health_metrics_usecase.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/metric_card.dart';
import '../widgets/heart_rate_pulse.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardBloc(
        getHealthMetricsUseCase: GetHealthMetricsUseCase(
          DashboardRepositoryImpl(HealthSimulator()),
        ),
      )..add(StartMonitoringEvent()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'HealthPulse',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Battery indicator
          BlocBuilder<DashboardBloc, DashboardState>(
            buildWhen: (prev, curr) =>
            prev.battery != curr.battery,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  children: [
                    Icon(
                      state.battery > 50
                          ? Icons.battery_full
                          : state.battery > 20
                          ? Icons.battery_3_bar
                          : Icons.battery_alert,
                      color: state.battery > 20
                          ? Colors.green
                          : Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${state.battery.toInt()}%',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          ),
          // BLE scanner button
          IconButton(
            icon: const Icon(Icons.bluetooth_searching),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BleScannerPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero heart rate card
                _buildHeartRateHero(context, state),

                const SizedBox(height: 16),

                // Metrics grid
                const Text(
                  'Vitals',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                  children: [
                    MetricCard(
                      label: 'SpO2',
                      value: '${state.spo2.toInt()}',
                      unit: '% Blood Oxygen',
                      icon: Icons.water_drop,
                      color: Colors.blue,
                      status: state.statuses[MetricType.spo2] ??
                          MetricStatus.normal,
                    ),
                    MetricCard(
                      label: 'HRV',
                      value: '${state.hrv.toInt()}',
                      unit: 'ms variability',
                      icon: Icons.show_chart,
                      color: Colors.amber,
                      status: state.statuses[MetricType.hrv] ??
                          MetricStatus.normal,
                    ),
                    MetricCard(
                      label: 'Steps',
                      value: '${state.steps.toInt()}',
                      unit: 'steps today',
                      icon: Icons.directions_walk,
                      color: Colors.green,
                      status: state.statuses[MetricType.steps] ??
                          MetricStatus.normal,
                    ),
                    MetricCard(
                      label: 'Temperature',
                      value: state.temperature.toStringAsFixed(1),
                      unit: '°C body temp',
                      icon: Icons.thermostat,
                      color: Colors.orange,
                      status:
                      state.statuses[MetricType.temperature] ??
                          MetricStatus.normal,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Status card
                _buildStatusCard(context, state),

                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeartRateHero(
      BuildContext context, DashboardState state) {
    final status =
        state.statuses[MetricType.heartRate] ?? MetricStatus.normal;
    final color = status == MetricStatus.normal
        ? const Color(0xFFFF5C5C)
        : status == MetricStatus.warning
        ? Colors.orange
        : Colors.red;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.15),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Heart Rate',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${state.heartRate.toInt()}',
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                        color: color,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'bpm',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status == MetricStatus.normal
                        ? 'Normal range'
                        : status == MetricStatus.warning
                        ? 'Slightly elevated'
                        : 'Check immediately',
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          HeartRatePulse(
            heartRate: state.heartRate,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
      BuildContext context, DashboardState state) {
    final hasWarning = state.statuses.values
        .any((s) => s != MetricStatus.normal);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasWarning
            ? Colors.orange.withOpacity(0.1)
            : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasWarning
              ? Colors.orange.withOpacity(0.3)
              : Colors.green.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            hasWarning
                ? Icons.warning_amber_rounded
                : Icons.check_circle_outline,
            color: hasWarning ? Colors.orange : Colors.green,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hasWarning
                  ? 'One or more metrics need attention'
                  : 'All vitals are in normal range',
              style: TextStyle(
                color:
                hasWarning ? Colors.orange.shade700 : Colors.green.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}