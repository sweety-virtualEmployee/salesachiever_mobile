// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../shared/models/locale.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocaleAdapter extends TypeAdapter<Locale> {
  @override
  final int typeId = 0;

  @override
  Locale read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Locale(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Locale obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.contextId)
      ..writeByte(1)
      ..write(obj.itemId)
      ..writeByte(2)
      ..write(obj.localeId)
      ..writeByte(3)
      ..write(obj.displayValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocaleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
