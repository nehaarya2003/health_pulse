import 'package:flutter/material.dart';
import '../../domain/entities/ble_device.dart';
import '../pages/device_detail_page.dart';

class BleDeviceTile extends StatelessWidget {
  final BleDevice device;

  const BleDeviceTile({
    super.key,
    required this.device,
  });

  Color get _rssiColor {
    if (device.rssi >= -60) return Colors.green;
    if (device.rssi >= -70) return Colors.orange;
    if (device.rssi >= -80) return Colors.amber;
    return Colors.red;
  }

  IconData get _rssiIcon {
    if (device.rssi >= -60) return Icons.signal_wifi_4_bar;
    if (device.rssi >= -70) return Icons.network_wifi_3_bar;
    if (device.rssi >= -80) return Icons.network_wifi_2_bar;
    return Icons.network_wifi_1_bar;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.bluetooth,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          device.name,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              device.id,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontFamily: 'monospace',
              ),
            ),
            if (device.serviceUuids.isNotEmpty)
              Text(
                '${device.serviceUuids.length} service${device.serviceUuids.length > 1 ? 's' : ''}',
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_rssiIcon, color: _rssiColor, size: 20),
            const SizedBox(height: 2),
            Text(
              '${device.rssi} dBm',
              style: TextStyle(
                fontSize: 11,
                color: _rssiColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              device.signalStrength,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DeviceDetailPage(device: device),
            ),
          );
        },
      ),
    );
  }
}