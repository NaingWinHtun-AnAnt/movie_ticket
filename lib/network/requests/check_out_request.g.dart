// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_out_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckOutRequest _$CheckOutRequestFromJson(Map<String, dynamic> json) {
  return CheckOutRequest(
    cinemaDayTimeSlotId: json['cinema_day_timeslot_id'] as int?,
    seatNumber: json['seat_number'] as String?,
    bookingDate: json['booking_date'] as String?,
    movieId: json['movie_id'] as int?,
    cardId: json['card_id'] as int?,
    snacks: (json['snacks'] as List<dynamic>?)
        ?.map((e) => SnackRequest.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$CheckOutRequestToJson(CheckOutRequest instance) =>
    <String, dynamic>{
      'cinema_day_timeslot_id': instance.cinemaDayTimeSlotId,
      'seat_number': instance.seatNumber,
      'booking_date': instance.bookingDate,
      'movie_id': instance.movieId,
      'card_id': instance.cardId,
      'snacks': instance.snacks,
    };
