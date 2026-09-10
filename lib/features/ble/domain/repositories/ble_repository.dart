import '../entities/ble_device.dart';
import '../entities/ble_characteristic.dart';

abstract class BleRepository {
  Stream<List<BleDevice>> scanDevices({Duration timeout});
  Future<bool> isBluetoothEnabled();
  Future<void> stopScan();
  Future<BleDevice> connectToDevice(String deviceId);
  Future<void> disconnectDevice(String deviceId);
  Future<List<BleCharacteristic>> discoverServices(String deviceId);
  Stream<List<int>> subscribeToCharacteristic({
    required String deviceId,
    required String serviceUuid,
    required String characteristicUuid,
  });
  Future<void> writeCharacteristic({
    required String deviceId,
    required String serviceUuid,
    required String characteristicUuid,
    required List<int> value,
  });
}