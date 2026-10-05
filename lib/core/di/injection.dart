import 'package:get_it/get_it.dart';

import '../../features/ble/data/datasources/ble_data_source.dart';
import '../../features/ble/data/repositories/ble_repository_impl.dart';
import '../../features/ble/domain/repositories/ble_repository.dart';
import '../../features/ble/domain/usecases/connect_device_usecase.dart';
import '../../features/ble/domain/usecases/disconnect_device_usecase.dart';
import '../../features/ble/domain/usecases/discover_services_usecase.dart';
import '../../features/ble/domain/usecases/scan_devices_usecase.dart';
import '../../features/dashboard/data/datasources/health_simulator.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/domain/usecases/get_health_metrics_usecase.dart';
import '../../features/history/data/datasources/history_data_source.dart';
import '../../features/history/data/repositories/history_repository_impl.dart';
import '../../features/history/domain/repositories/history_repository.dart';
import '../../features/history/domain/usecases/get_history_usecase.dart';

final GetIt getIt = GetIt.instance;

void configureDependencies() {
  _registerBle();
  _registerDashboard();
  _registerHistory();
}

void _registerBle() {
  // Data sources
  getIt.registerLazySingleton<BleDataSource>(
        () => BleDataSource(),
  );

  // Repositories
  getIt.registerLazySingleton<BleRepository>(
        () => BleRepositoryImpl(getIt<BleDataSource>()),
  );

  // Use cases
  getIt.registerFactory<ScanDevicesUseCase>(
        () => ScanDevicesUseCase(getIt<BleRepository>()),
  );
  getIt.registerFactory<ConnectDeviceUseCase>(
        () => ConnectDeviceUseCase(getIt<BleRepository>()),
  );
  getIt.registerFactory<DisconnectDeviceUseCase>(
        () => DisconnectDeviceUseCase(getIt<BleRepository>()),
  );
  getIt.registerFactory<DiscoverServicesUseCase>(
        () => DiscoverServicesUseCase(getIt<BleRepository>()),
  );
}

void _registerDashboard() {
  // Data sources
  getIt.registerLazySingleton<HealthSimulator>(
        () => HealthSimulator(),
  );

  // Repositories
  getIt.registerLazySingleton<DashboardRepository>(
        () => DashboardRepositoryImpl(getIt<HealthSimulator>()),
  );

  // Use cases
  getIt.registerFactory<GetHealthMetricsUseCase>(
        () => GetHealthMetricsUseCase(getIt<DashboardRepository>()),
  );
}

void _registerHistory() {
  // Data sources
  getIt.registerLazySingleton<HistoryDataSource>(
        () => HistoryDataSource(),
  );

  // Repositories
  getIt.registerLazySingleton<HistoryRepository>(
        () => HistoryRepositoryImpl(getIt<HistoryDataSource>()),
  );

  // Use cases
  getIt.registerFactory<GetHistoryUseCase>(
        () => GetHistoryUseCase(getIt<HistoryRepository>()),
  );
}