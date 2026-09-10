import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../domain/entities/ble_device.dart';
import '../../domain/entities/ble_characteristic.dart';

class BleDataSource {
  // Cache connected devices
  final Map<String, BluetoothDevice> _connectedDevices = {};

  Stream<List<BleDevice>> scanDevices({
    Duration timeout = const Duration(seconds: 10),
  }) async* {
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

  Future<BleDevice> connectToDevice(String deviceId) async {
    final device = BluetoothDevice.fromId(deviceId);

    // Retry logic for GATT 133 error
    int retries = 3;
    while (retries > 0) {
      try {
        await device.connect(
          timeout: const Duration(seconds: 10),
          autoConnect: false,
        );
        _connectedDevices[deviceId] = device;

        return BleDevice(
          id: deviceId,
          name: device.platformName.isEmpty
              ? 'Unknown Device'
              : device.platformName,
          rssi: 0,
          isConnected: true,
        );
      } catch (e) {
        retries--;
        if (retries == 0) rethrow;
        // Wait before retry — handles GATT 133 error
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
    throw Exception('Failed to connect after 3 attempts');
  }

  Future<void> disconnectDevice(String deviceId) async {
    final device = _connectedDevices[deviceId];
    if (device != null) {
      await device.disconnect();
      _connectedDevices.remove(deviceId);
    }
  }

  Future<List<BleCharacteristic>> discoverServices(
      String deviceId) async {
    final device = _connectedDevices[deviceId];
    if (device == null) throw Exception('Device not connected');

    final services = await device.discoverServices();
    final characteristics = <BleCharacteristic>[];

    for (final service in services) {
      for (final characteristic in service.characteristics) {
        characteristics.add(BleCharacteristic(
          uuid: characteristic.uuid.str,
          serviceUuid: service.uuid.str,
          value: characteristic.lastValue,
          canRead: characteristic.properties.read,
          canWrite: characteristic.properties.write ||
              characteristic.properties.writeWithoutResponse,
          canNotify: characteristic.properties.notify ||
              characteristic.properties.indicate,
        ));
      }
    }
    return characteristics;
  }

  Stream<List<int>> subscribeToCharacteristic({
    required String deviceId,
    required String serviceUuid,
    required String characteristicUuid,
  }) async* {
    final device = _connectedDevices[deviceId];
    if (device == null) throw Exception('Device not connected');

    final services = await device.discoverServices();
    final service = services.firstWhere(
          (s) => s.uuid.str == serviceUuid,
    );
    final characteristic = service.characteristics.firstWhere(
          (c) => c.uuid.str == characteristicUuid,
    );

    // Enable notifications
    await characteristic.setNotifyValue(true);

    yield* characteristic.onValueReceived;
  }

  Future<void> writeCharacteristic({
    required String deviceId,
    required String serviceUuid,
    required String characteristicUuid,
    required List<int> value,
  }) async {
    final device = _connectedDevices[deviceId];
    if (device == null) throw Exception('Device not connected');

    final services = await device.discoverServices();
    final service = services.firstWhere(
          (s) => s.uuid.str == serviceUuid,
    );
    final characteristic = service.characteristics.firstWhere(
          (c) => c.uuid.str == characteristicUuid,
    );

    await characteristic.write(value);
  }
}