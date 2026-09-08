import 'package:get_it/get_it.dart';
import '../../features/ble/data/datasources/ble_data_source.dart';
import '../../features/ble/data/repositories/ble_repository_impl.dart';
import '../../features/ble/domain/repositories/ble_repository.dart';
import '../../features/ble/domain/usecases/scan_devices_usecase.dart';

final GetIt getIt = GetIt.instance;

void configureDependencies() {
  // BLE
  getIt.registerLazySingleton<BleDataSource>(() => BleDataSource());
  getIt.registerLazySingleton<BleRepository>(
        () => BleRepositoryImpl(getIt<BleDataSource>()),
  );
  getIt.registerFactory<ScanDevicesUseCase>(
        () => ScanDevicesUseCase(getIt<BleRepository>()),
  );
}