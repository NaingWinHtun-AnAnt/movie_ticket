// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionVOAdapter extends TypeAdapter<TransactionVO> {
  @override
  final int typeId = 11;

  @override
  TransactionVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionVO(
      id: fields[0] as int,
      bookingNo: fields[1] as String,
      bookingDate: fields[2] as String,
      row: fields[3] as String,
      seat: fields[4] as String,
      totalSeat: fields[5] as int,
      total: fields[6] as String,
      movieId: fields[7] as int,
      cinemaId: fields[8] as int,
      username: fields[9] as String,
      timeslot: fields[10] as TimeSlotVO,
      snacks: (fields[11] as List).cast<SnackVO>(),
    );
  }

  @override
  void write(BinaryWriter writer, TransactionVO obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.bookingNo)
      ..writeByte(2)
      ..write(obj.bookingDate)
      ..writeByte(3)
      ..write(obj.row)
      ..writeByte(4)
      ..write(obj.seat)
      ..writeByte(5)
      ..write(obj.totalSeat)
      ..writeByte(6)
      ..write(obj.total)
      ..writeByte(7)
      ..write(obj.movieId)
      ..writeByte(8)
      ..write(obj.cinemaId)
      ..writeByte(9)
      ..write(obj.username)
      ..writeByte(10)
      ..write(obj.timeslot)
      ..writeByte(11)
      ..write(obj.snacks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionVO _$TransactionVOFromJson(Map<String, dynamic> json) {
  return TransactionVO(
    id: json['id'] as int,
    bookingNo: json['booking_no'] as String,
    bookingDate: json['booking_date'] as String,
    row: json['row'] as String,
    seat: json['seat'] as String,
    totalSeat: json['total_seat'] as int,
    total: json['total'] as String,
    movieId: json['movie_id'] as int,
    cinemaId: json['cinema_id'] as int,
    username: json['username'] as String,
    timeslot: TimeSlotVO.fromJson(json['timeslot'] as Map<String, dynamic>),
    snacks: (json['snacks'] as List<dynamic>)
        .map((e) => SnackVO.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$TransactionVOToJson(TransactionVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booking_no': instance.bookingNo,
      'booking_date': instance.bookingDate,
      'row': instance.row,
      'seat': instance.seat,
      'total_seat': instance.totalSeat,
      'total': instance.total,
      'movie_id': instance.movieId,
      'cinema_id': instance.cinemaId,
      'username': instance.username,
      'timeslot': instance.timeslot,
      'snacks': instance.snacks,
    };
