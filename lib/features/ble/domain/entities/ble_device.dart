import 'package:equatable/equatable.dart';
import 'ble_characteristic.dart';

class BleDevice extends Equatable {
  final String id;
  final String name;
  final int rssi;
  final bool isConnected;
  final List<String> serviceUuids;
  final List<BleCharacteristic> characteristics;

  const BleDevice({
    required this.id,
    required this.name,
    required this.rssi,
    this.isConnected = false,
    this.serviceUuids = const [],
    this.characteristics = const [],
  });

  BleDevice copyWith({
    String? id,
    String? name,
    int? rssi,
    bool? isConnected,
    List<String>? serviceUuids,
    List<BleCharacteristic>? characteristics,
  }) {
    return BleDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      rssi: rssi ?? this.rssi,
      isConnected: isConnected ?? this.isConnected,
      serviceUuids: serviceUuids ?? this.serviceUuids,
      characteristics: characteristics ?? this.characteristics,
    );
  }

  String get signalStrength {
    if (rssi >= -60) return 'Excellent';
    if (rssi >= -70) return 'Good';
    if (rssi >= -80) return 'Fair';
    return 'Weak';
  }

  @override
  List<Object?> get props => [id, name, rssi, isConnected, characteristics];
}