// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat_plan_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeatPlanResponse _$SeatPlanResponseFromJson(Map<String, dynamic> json) {
  return SeatPlanResponse(
    code: json['code'] as int,
    message: json['message'] as String,
    data: (json['data'] as List<dynamic>)
        .map((e) => (e as List<dynamic>)
            .map((e) => MovieSeatVO.fromJson(e as Map<String, dynamic>))
            .toList())
        .toList(),
  );
}

Map<String, dynamic> _$SeatPlanResponseToJson(SeatPlanResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
