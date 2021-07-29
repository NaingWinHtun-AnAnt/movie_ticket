// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_seat_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieSeatVOAdapter extends TypeAdapter<MovieSeatVO> {
  @override
  final int typeId = 8;

  @override
  MovieSeatVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieSeatVO(
      id: fields[0] as int?,
      type: fields[1] as String?,
      seatName: fields[2] as String?,
      title: fields[3] as String?,
      price: fields[4] as double?,
      isSelected: fields[5] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, MovieSeatVO obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.seatName)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.isSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieSeatVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieSeatVO _$MovieSeatVOFromJson(Map<String, dynamic> json) {
  return MovieSeatVO(
    id: json['id'] as int?,
    type: json['type'] as String?,
    seatName: json['seat_name'] as String?,
    title: json['symbol'] as String?,
    price: (json['price'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$MovieSeatVOToJson(MovieSeatVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'seat_name': instance.seatName,
      'symbol': instance.title,
      'price': instance.price,
    };
