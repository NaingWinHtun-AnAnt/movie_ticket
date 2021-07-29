// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cinema_day_timeslot_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CinemaDayTimeSlotResponse _$CinemaDayTimeSlotResponseFromJson(
    Map<String, dynamic> json) {
  return CinemaDayTimeSlotResponse(
    code: json['code'] as int,
    message: json['message'] as String,
    data: (json['data'] as List<dynamic>)
        .map((e) => CinemaDayTimeSlotVO.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$CinemaDayTimeSlotResponseToJson(
        CinemaDayTimeSlotResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
