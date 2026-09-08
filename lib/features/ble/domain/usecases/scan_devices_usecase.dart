import '../entities/ble_device.dart';
import '../repositories/ble_repository.dart';

class ScanDevicesUseCase {
  final BleRepository repository;

  ScanDevicesUseCase(this.repository);

  Stream<List<BleDevice>> call({
    Duration timeout = const Duration(seconds: 10),
  }) {
    return repository.scanDevices(timeout: timeout);
  }
}