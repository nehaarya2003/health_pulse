import '../entities/ble_device.dart';
import '../repositories/ble_repository.dart';

class ConnectDeviceUseCase {
  final BleRepository repository;
  ConnectDeviceUseCase(this.repository);

  Future<BleDevice> call(String deviceId) =>
      repository.connectToDevice(deviceId);
}