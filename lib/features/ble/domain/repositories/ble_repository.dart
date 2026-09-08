import '../entities/ble_device.dart';

abstract class BleRepository {
  Stream<List<BleDevice>> scanDevices({Duration timeout});
  Future<bool> isBluetoothEnabled();
  Future<void> stopScan();
}