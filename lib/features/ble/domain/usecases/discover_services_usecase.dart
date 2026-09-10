import '../entities/ble_characteristic.dart';
import '../repositories/ble_repository.dart';

class DiscoverServicesUseCase {
  final BleRepository repository;
  DiscoverServicesUseCase(this.repository);

  Future<List<BleCharacteristic>> call(String deviceId) =>
      repository.discoverServices(deviceId);
}