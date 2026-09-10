import 'package:equatable/equatable.dart';

class BleCharacteristic extends Equatable {
  final String uuid;
  final String serviceUuid;
  final List<int> value;
  final bool canRead;
  final bool canWrite;
  final bool canNotify;

  const BleCharacteristic({
    required this.uuid,
    required this.serviceUuid,
    required this.value,
    this.canRead = false,
    this.canWrite = false,
    this.canNotify = false,
  });

  String get hexValue => value
      .map((b) => b.toRadixString(16).padLeft(2, '0'))
      .join(' ');

  @override
  List<Object?> get props => [uuid, serviceUuid, value];
}