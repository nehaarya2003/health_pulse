abstract class BleConnectionEvent {}

class ConnectDeviceEvent extends BleConnectionEvent {
  final String deviceId;
  ConnectDeviceEvent(this.deviceId);
}

class DisconnectDeviceEvent extends BleConnectionEvent {
  final String deviceId;
  DisconnectDeviceEvent(this.deviceId);
}

class DiscoverServicesEvent extends BleConnectionEvent {
  final String deviceId;
  DiscoverServicesEvent(this.deviceId);
}