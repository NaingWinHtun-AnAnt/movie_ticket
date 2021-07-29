// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cinema_day_time_slot_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CinemaDayTimeSlotVOAdapter extends TypeAdapter<CinemaDayTimeSlotVO> {
  @override
  final int typeId = 6;

  @override
  CinemaDayTimeSlotVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CinemaDayTimeSlotVO(
      cinemaId: fields[0] as int,
      cinema: fields[1] as String,
      timeslots: (fields[2] as List).cast<TimeSlotVO>(),
      isSelected: fields[3] as bool?,
      bookingDate: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CinemaDayTimeSlotVO obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.cinemaId)
      ..writeByte(1)
      ..write(obj.cinema)
      ..writeByte(2)
      ..write(obj.timeslots)
      ..writeByte(3)
      ..write(obj.isSelected)
      ..writeByte(4)
      ..write(obj.bookingDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CinemaDayTimeSlotVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CinemaDayTimeSlotVO _$CinemaDayTimeSlotVOFromJson(Map<String, dynamic> json) {
  return CinemaDayTimeSlotVO(
    cinemaId: json['cinema_id'] as int,
    cinema: json['cinema'] as String,
    timeslots: (json['timeslots'] as List<dynamic>)
        .map((e) => TimeSlotVO.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$CinemaDayTimeSlotVOToJson(
        CinemaDayTimeSlotVO instance) =>
    <String, dynamic>{
      'cinema_id': instance.cinemaId,
      'cinema': instance.cinema,
      'timeslots': instance.timeslots,
    };
