import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/scan_devices_usecase.dart';
import 'ble_scanner_event.dart';
import 'ble_scanner_state.dart';

class BleScannerBloc extends Bloc<BleScannerEvent, BleScannerState> {
  final ScanDevicesUseCase scanDevicesUseCase;
  StreamSubscription? _scanSubscription;

  BleScannerBloc({required this.scanDevicesUseCase})
      : super(BleScannerInitial()) {
    on<StartScanEvent>(_onStartScan);
    on<StopScanEvent>(_onStopScan);
  }

  Future<void> _onStartScan(
      StartScanEvent event,
      Emitter<BleScannerState> emit,
      ) async {
    emit(BleScannerLoading());

    await _scanSubscription?.cancel();

    await emit.forEach(
      scanDevicesUseCase(timeout: const Duration(seconds: 15)),
      onData: (devices) => BleScannerScanning(devices),
      onError: (error, _) => BleScannerError(error.toString()),
    );

    emit(BleScannerStopped(
      state is BleScannerScanning
          ? (state as BleScannerScanning).devices
          : [],
    ));
  }

  Future<void> _onStopScan(
      StopScanEvent event,
      Emitter<BleScannerState> emit,
      ) async {
    await _scanSubscription?.cancel();
    final currentDevices = state is BleScannerScanning
        ? (state as BleScannerScanning).devices
        : [];
    emit(BleScannerStopped(currentDevices.cast()));
  }

  @override
  Future<void> close() {
    _scanSubscription?.cancel();
    return super.close();
  }
}