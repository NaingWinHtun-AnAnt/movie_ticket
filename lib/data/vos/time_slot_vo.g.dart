// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_slot_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimeSlotVOAdapter extends TypeAdapter<TimeSlotVO> {
  @override
  final int typeId = 7;

  @override
  TimeSlotVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeSlotVO(
      cinemaDayTimeslotId: fields[0] as int,
      starTime: fields[1] as String,
      isSelected: fields[2] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, TimeSlotVO obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.cinemaDayTimeslotId)
      ..writeByte(1)
      ..write(obj.starTime)
      ..writeByte(2)
      ..write(obj.isSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeSlotVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeSlotVO _$TimeSlotVOFromJson(Map<String, dynamic> json) {
  return TimeSlotVO(
    cinemaDayTimeslotId: json['cinema_day_timeslot_id'] as int,
    starTime: json['start_time'] as String,
  );
}

Map<String, dynamic> _$TimeSlotVOToJson(TimeSlotVO instance) =>
    <String, dynamic>{
      'cinema_day_timeslot_id': instance.cinemaDayTimeslotId,
      'start_time': instance.starTime,
    };
