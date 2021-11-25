// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cinema_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CinemaListResponse _$CinemaListResponseFromJson(Map<String, dynamic> json) {
  return CinemaListResponse(
    code: json['code'] as int?,
    message: json['message'] as String?,
    data: (json['data'] as List<dynamic>?)
        ?.map((e) => CinemaVO.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$CinemaListResponseToJson(CinemaListResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
