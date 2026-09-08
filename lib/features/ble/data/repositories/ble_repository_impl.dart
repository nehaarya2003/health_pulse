import '../../domain/entities/ble_device.dart';
import '../../domain/repositories/ble_repository.dart';
import '../datasources/ble_data_source.dart';

class BleRepositoryImpl implements BleRepository {
  final BleDataSource dataSource;

  BleRepositoryImpl(this.dataSource);

  @override
  Stream<List<BleDevice>> scanDevices({
    Duration timeout = const Duration(seconds: 10),
  }) {
    return dataSource.scanDevices(timeout: timeout);
  }

  @override
  Future<bool> isBluetoothEnabled() {
    return dataSource.isBluetoothEnabled();
  }

  @override
  Future<void> stopScan() {
    return dataSource.stopScan();
  }
}