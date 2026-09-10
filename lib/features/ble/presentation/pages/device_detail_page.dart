import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/ble_device.dart';
import '../../domain/entities/ble_characteristic.dart';
import '../../domain/usecases/connect_device_usecase.dart';
import '../../domain/usecases/disconnect_device_usecase.dart';
import '../../domain/usecases/discover_services_usecase.dart';
import '../../data/datasources/ble_data_source.dart';
import '../../data/repositories/ble_repository_impl.dart';
import '../bloc/ble_connection_bloc.dart';
import '../bloc/ble_connection_event.dart';
import '../bloc/ble_connection_state.dart';

class DeviceDetailPage extends StatelessWidget {
  final BleDevice device;

  const DeviceDetailPage({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final dataSource = BleDataSource();
    final repository = BleRepositoryImpl(dataSource);

    return BlocProvider(
      create: (_) => BleConnectionBloc(
        connectDeviceUseCase: ConnectDeviceUseCase(repository),
        disconnectDeviceUseCase: DisconnectDeviceUseCase(repository),
        discoverServicesUseCase: DiscoverServicesUseCase(repository),
      )..add(ConnectDeviceEvent(device.id)),
      child: _DeviceDetailView(device: device),
    );
  }
}

class _DeviceDetailView extends StatelessWidget {
  final BleDevice device;

  const _DeviceDetailView({required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: [
          BlocBuilder<BleConnectionBloc, BleConnectionState>(
            builder: (context, state) {
              if (state is BleConnectionConnected ||
                  state is BleConnectionServicesDiscovered) {
                return TextButton.icon(
                  onPressed: () => context
                      .read<BleConnectionBloc>()
                      .add(DisconnectDeviceEvent(device.id)),
                  icon: const Icon(Icons.bluetooth_disabled,
                      color: Colors.red),
                  label: const Text('Disconnect',
                      style: TextStyle(color: Colors.red)),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: BlocBuilder<BleConnectionBloc, BleConnectionState>(
        builder: (context, state) {
          if (state is BleConnectionConnecting) {
            return _buildConnecting();
          }
          if (state is BleConnectionConnected ||
              state is BleConnectionDiscovering) {
            return _buildDiscovering();
          }
          if (state is BleConnectionServicesDiscovered) {
            return _buildServicesView(
                state.characteristics);
          }
          if (state is BleConnectionDisconnected) {
            return _buildDisconnected(context);
          }
          if (state is BleConnectionError) {
            return _buildError(context, state.message);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildConnecting() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Connecting...'),
          SizedBox(height: 8),
          Text(
            'This may take a few seconds',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscovering() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Connected! Discovering services...'),
        ],
      ),
    );
  }

  Widget _buildServicesView(
      List<BleCharacteristic> characteristics) {
    // Group by service UUID
    final Map<String, List<BleCharacteristic>> grouped = {};
    for (final c in characteristics) {
      grouped.putIfAbsent(c.serviceUuid, () => []).add(c);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Connection status card
        Card(
          child: ListTile(
            leading: const Icon(Icons.bluetooth_connected,
                color: Colors.green),
            title: Text(device.name),
            subtitle: Text(device.id),
            trailing: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Connected',
                style: TextStyle(
                    color: Colors.green, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        Text(
          '${characteristics.length} characteristics across ${grouped.length} services',
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 13),
        ),

        const SizedBox(height: 12),

        // Services
        ...grouped.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Service: ${_shortUuid(entry.key)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.blue,
                  ),
                ),
              ),
              ...entry.value.map((c) => _CharacteristicTile(
                characteristic: c,
              )),
              const SizedBox(height: 8),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildDisconnected(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bluetooth_disabled,
              size: 60, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Disconnected'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context
                .read<BleConnectionBloc>()
                .add(ConnectDeviceEvent(device.id)),
            child: const Text('Reconnect'),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context
                .read<BleConnectionBloc>()
                .add(ConnectDeviceEvent(device.id)),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  String _shortUuid(String uuid) {
    if (uuid.length > 8) return uuid.substring(0, 8).toUpperCase();
    return uuid.toUpperCase();
  }
}

class _CharacteristicTile extends StatelessWidget {
  final BleCharacteristic characteristic;

  const _CharacteristicTile({required this.characteristic});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // UUID
            Text(
              characteristic.uuid.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 6),

            // Properties
            Row(
              children: [
                if (characteristic.canRead)
                  _PropertyChip('READ', Colors.blue),
                if (characteristic.canWrite)
                  _PropertyChip('WRITE', Colors.orange),
                if (characteristic.canNotify)
                  _PropertyChip('NOTIFY', Colors.green),
              ],
            ),

            // Value if available
            if (characteristic.value.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                'Value: ${characteristic.hexValue}',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PropertyChip extends StatelessWidget {
  final String label;
  final Color color;

  const _PropertyChip(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}