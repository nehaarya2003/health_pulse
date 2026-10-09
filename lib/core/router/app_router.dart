import 'package:flutter/material.dart';
import '../../features/ble/domain/entities/ble_device.dart';
import '../../features/ble/presentation/pages/ble_scanner_page.dart';
import '../../features/ble/presentation/pages/device_detail_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/history/presentation/pages/history_page.dart';

class AppRouter {
  static const String dashboard = '/';
  static const String bleScanner = '/ble-scanner';
  static const String deviceDetail = '/device-detail';
  static const String history = '/history';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const DashboardPage(),
        );
      case bleScanner:
        return MaterialPageRoute(
          builder: (_) => const BleScannerPage(),
        );
      case deviceDetail:
        final device = settings.arguments as BleDevice;
        return MaterialPageRoute(
          builder: (_) => DeviceDetailPage(device: device),
        );
      case history:
        return MaterialPageRoute(
          builder: (_) => const HistoryPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const DashboardPage(),
        );
    }
  }

  // Navigation helpers
  static void goToScanner(BuildContext context) {
    Navigator.pushNamed(context, bleScanner);
  }

  static void goToDeviceDetail(BuildContext context, BleDevice device) {
    Navigator.pushNamed(context, deviceDetail, arguments: device);
  }

  static void goToHistory(BuildContext context) {
    Navigator.pushNamed(context, history);
  }
}