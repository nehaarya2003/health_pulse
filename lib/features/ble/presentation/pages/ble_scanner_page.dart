import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../domain/entities/ble_device.dart';
import '../../domain/repositories/ble_repository.dart';
import '../../domain/usecases/scan_devices_usecase.dart';
import '../../data/datasources/ble_data_source.dart';
import '../../data/repositories/ble_repository_impl.dart';
import '../bloc/ble_scanner_bloc.dart';
import '../bloc/ble_scanner_event.dart';
import '../bloc/ble_scanner_state.dart';
import '../widgets/ble_device_tile.dart';

class BleScannerPage extends StatelessWidget {
  const BleScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BleScannerBloc(
        scanDevicesUseCase: ScanDevicesUseCase(
          BleRepositoryImpl(BleDataSource()),
        ),
      ),
      child: const _BleScannerView(),
    );
  }
}

class _BleScannerView extends StatefulWidget {
  const _BleScannerView();

  @override
  State<_BleScannerView> createState() => _BleScannerViewState();
}

class _BleScannerViewState extends State<_BleScannerView> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE Scanner'),
        actions: [
          BlocBuilder<BleScannerBloc, BleScannerState>(
            builder: (context, state) {
              final isScanning = state is BleScannerScanning ||
                  state is BleScannerLoading;
              return TextButton.icon(
                onPressed: () {
                  if (isScanning) {
                    context
                        .read<BleScannerBloc>()
                        .add(StopScanEvent());
                  } else {
                    context
                        .read<BleScannerBloc>()
                        .add(StartScanEvent());
                  }
                },
                icon: Icon(
                  isScanning ? Icons.stop : Icons.search,
                  color: isScanning ? Colors.red : Colors.green,
                ),
                label: Text(
                  isScanning ? 'Stop' : 'Scan',
                  style: TextStyle(
                    color: isScanning ? Colors.red : Colors.green,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<BleScannerBloc, BleScannerState>(
        builder: (context, state) {
          if (state is BleScannerInitial) {
            return _buildInitialView(context);
          }
          if (state is BleScannerLoading) {
            return _buildLoadingView();
          }
          if (state is BleScannerError) {
            return _buildErrorView(state.message);
          }
          if (state is BleScannerScanning) {
            return _buildDeviceList(
              state.devices,
              isScanning: true,
            );
          }
          if (state is BleScannerStopped) {
            return _buildDeviceList(
              state.devices,
              isScanning: false,
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildInitialView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bluetooth_searching,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          const Text(
            'Find nearby BLE devices',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap Scan to discover devices',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () =>
                context.read<BleScannerBloc>().add(StartScanEvent()),
            icon: const Icon(Icons.search),
            label: const Text('Start Scanning'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Starting scan...'),
        ],
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () =>
                context.read<BleScannerBloc>().add(StartScanEvent()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceList(
      List<BleDevice> devices, {
        required bool isScanning,
      }) {
    return Column(
      children: [
        // Scanning indicator
        if (isScanning)
          LinearProgressIndicator(
            backgroundColor: Colors.grey.shade200,
          ),

        // Device count
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                '${devices.length} device${devices.length == 1 ? '' : 's'} found',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              if (isScanning)
                const Row(
                  children: [
                    SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Scanning...',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
            ],
          ),
        ),

        // Device list
        Expanded(
          child: devices.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.devices,
                  size: 60,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  isScanning
                      ? 'Looking for devices...'
                      : 'No devices found',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ],
            ),
          )
              : ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: devices.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return BleDeviceTile(device: devices[index]);
            },
          ),
        ),
      ],
    );
  }
}