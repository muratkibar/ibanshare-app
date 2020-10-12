// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iban_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IbanModelAdapter extends TypeAdapter<IbanModel> {
  @override
  final typeId = 0;

  @override
  IbanModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IbanModel(
      ibanNo: fields[0] as String,
      ibanIsim: fields[1] as String,
      isIbanBenim: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, IbanModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.ibanNo)
      ..writeByte(1)
      ..write(obj.ibanIsim)
      ..writeByte(2)
      ..write(obj.isIbanBenim);
  }
}
