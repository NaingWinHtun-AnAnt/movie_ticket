// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snack_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SnackResponse _$SnackResponseFromJson(Map<String, dynamic> json) {
  return SnackResponse(
    code: json['code'] as int,
    message: json['message'] as String,
    data: (json['data'] as List<dynamic>)
        .map((e) => SnackVO.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SnackResponseToJson(SnackResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
