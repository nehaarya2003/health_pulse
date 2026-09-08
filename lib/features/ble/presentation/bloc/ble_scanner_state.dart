import 'package:equatable/equatable.dart';
import '../../domain/entities/ble_device.dart';

abstract class BleScannerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BleScannerInitial extends BleScannerState {}

class BleScannerLoading extends BleScannerState {}

class BleScannerScanning extends BleScannerState {
  final List<BleDevice> devices;

  BleScannerScanning(this.devices);

  @override
  List<Object?> get props => [devices];
}

class BleScannerStopped extends BleScannerState {
  final List<BleDevice> devices;

  BleScannerStopped(this.devices);

  @override
  List<Object?> get props => [devices];
}

class BleScannerError extends BleScannerState {
  final String message;

  BleScannerError(this.message);

  @override
  List<Object?> get props => [message];
}