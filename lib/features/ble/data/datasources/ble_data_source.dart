import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../domain/entities/ble_device.dart';

class BleDataSource {
  Stream<List<BleDevice>> scanDevices({
    Duration timeout = const Duration(seconds: 10),
  }) async* {
    // Check if Bluetooth is on
    if (await FlutterBluePlus.adapterState.first !=
        BluetoothAdapterState.on) {
      yield [];
      return;
    }

    final List<BleDevice> devices = [];

    await FlutterBluePlus.startScan(timeout: timeout);

    yield* FlutterBluePlus.scanResults.map((results) {
      for (final result in results) {
        final device = BleDevice(
          id: result.device.remoteId.str,
          name: result.device.platformName.isEmpty
              ? 'Unknown Device'
              : result.device.platformName,
          rssi: result.rssi,
          serviceUuids: result.advertisementData.serviceUuids
              .map((uuid) => uuid.str)
              .toList(),
        );

        final existingIndex =
        devices.indexWhere((d) => d.id == device.id);
        if (existingIndex >= 0) {
          devices[existingIndex] = device;
        } else {
          devices.add(device);
        }
      }
      // Sort by signal strength
      devices.sort((a, b) => b.rssi.compareTo(a.rssi));
      return List<BleDevice>.from(devices);
    });
  }

  Future<bool> isBluetoothEnabled() async {
    final state = await FlutterBluePlus.adapterState.first;
    return state == BluetoothAdapterState.on;
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }
}