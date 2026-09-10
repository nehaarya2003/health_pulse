import '../../domain/entities/ble_device.dart';
import '../../domain/entities/ble_characteristic.dart';
import '../../domain/repositories/ble_repository.dart';
import '../datasources/ble_data_source.dart';

class BleRepositoryImpl implements BleRepository {
  final BleDataSource dataSource;

  BleRepositoryImpl(this.dataSource);

  @override
  Stream<List<BleDevice>> scanDevices({
    Duration timeout = const Duration(seconds: 10),
  }) => dataSource.scanDevices(timeout: timeout);

  @override
  Future<bool> isBluetoothEnabled() =>
      dataSource.isBluetoothEnabled();

  @override
  Future<void> stopScan() => dataSource.stopScan();

  @override
  Future<BleDevice> connectToDevice(String deviceId) =>
      dataSource.connectToDevice(deviceId);

  @override
  Future<void> disconnectDevice(String deviceId) =>
      dataSource.disconnectDevice(deviceId);

  @override
  Future<List<BleCharacteristic>> discoverServices(String deviceId) =>
      dataSource.discoverServices(deviceId);

  @override
  Stream<List<int>> subscribeToCharacteristic({
    required String deviceId,
    required String serviceUuid,
    required String characteristicUuid,
  }) =>
      dataSource.subscribeToCharacteristic(
        deviceId: deviceId,
        serviceUuid: serviceUuid,
        characteristicUuid: characteristicUuid,
      );

  @override
  Future<void> writeCharacteristic({
    required String deviceId,
    required String serviceUuid,
    required String characteristicUuid,
    required List<int> value,
  }) =>
      dataSource.writeCharacteristic(
        deviceId: deviceId,
        serviceUuid: serviceUuid,
        characteristicUuid: characteristicUuid,
        value: value,
      );
}