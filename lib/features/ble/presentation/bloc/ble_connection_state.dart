import 'package:equatable/equatable.dart';
import '../../domain/entities/ble_device.dart';
import '../../domain/entities/ble_characteristic.dart';

abstract class BleConnectionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BleConnectionInitial extends BleConnectionState {}

class BleConnectionConnecting extends BleConnectionState {
  final String deviceId;
  BleConnectionConnecting(this.deviceId);
  @override
  List<Object?> get props => [deviceId];
}

class BleConnectionConnected extends BleConnectionState {
  final BleDevice device;
  BleConnectionConnected(this.device);
  @override
  List<Object?> get props => [device];
}

class BleConnectionDiscovering extends BleConnectionState {
  final BleDevice device;
  BleConnectionDiscovering(this.device);
  @override
  List<Object?> get props => [device];
}

class BleConnectionServicesDiscovered extends BleConnectionState {
  final BleDevice device;
  final List<BleCharacteristic> characteristics;
  BleConnectionServicesDiscovered(this.device, this.characteristics);
  @override
  List<Object?> get props => [device, characteristics];
}

class BleConnectionDisconnected extends BleConnectionState {}

class BleConnectionError extends BleConnectionState {
  final String message;
  BleConnectionError(this.message);
  @override
  List<Object?> get props => [message];
}