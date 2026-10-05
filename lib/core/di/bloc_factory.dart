import '../../features/ble/domain/usecases/connect_device_usecase.dart';
import '../../features/ble/domain/usecases/disconnect_device_usecase.dart';
import '../../features/ble/domain/usecases/discover_services_usecase.dart';
import '../../features/ble/domain/usecases/scan_devices_usecase.dart';
import '../../features/ble/presentation/bloc/ble_connection_bloc.dart';
import '../../features/ble/presentation/bloc/ble_scanner_bloc.dart';
import '../../features/dashboard/domain/usecases/get_health_metrics_usecase.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/history/domain/usecases/get_history_usecase.dart';
import '../../features/history/presentation/bloc/history_bloc.dart';
import 'injection.dart';

class BlocFactory {
  // BLE Scanner BLoC
  static BleScannerBloc createBleScannerBloc() {
    return BleScannerBloc(
      scanDevicesUseCase: getIt<ScanDevicesUseCase>(),
    );
  }

  // BLE Connection BLoC
  static BleConnectionBloc createBleConnectionBloc() {
    return BleConnectionBloc(
      connectDeviceUseCase: getIt<ConnectDeviceUseCase>(),
      disconnectDeviceUseCase: getIt<DisconnectDeviceUseCase>(),
      discoverServicesUseCase: getIt<DiscoverServicesUseCase>(),
    );
  }

  // Dashboard BLoC
  static DashboardBloc createDashboardBloc() {
    return DashboardBloc(
      getHealthMetricsUseCase: getIt<GetHealthMetricsUseCase>(),
    );
  }

  // History BLoC
  static HistoryBloc createHistoryBloc() {
    return HistoryBloc(
      getHistoryUseCase: getIt<GetHistoryUseCase>(),
    );
  }
}