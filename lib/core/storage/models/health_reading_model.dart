import 'package:hive/hive.dart';

class HealthReadingModel extends HiveObject {
  final String metricType;
  final double value;
  final DateTime timestamp;
  final String unit;

  HealthReadingModel({
    required this.metricType,
    required this.value,
    required this.timestamp,
    required this.unit,
  });
}

class HealthReadingModelAdapter extends TypeAdapter<HealthReadingModel> {
  @override
  final int typeId = 0;

  @override
  HealthReadingModel read(BinaryReader reader) {
    return HealthReadingModel(
      metricType: reader.readString(),
      value: reader.readDouble(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      unit: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, HealthReadingModel obj) {
    writer.writeString(obj.metricType);
    writer.writeDouble(obj.value);
    writer.writeInt(obj.timestamp.millisecondsSinceEpoch);
    writer.writeString(obj.unit);
  }
}