// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snack_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SnackRequest _$SnackRequestFromJson(Map<String, dynamic> json) {
  return SnackRequest(
    id: json['id'] as int?,
    count: json['quantity'] as int?,
  );
}

Map<String, dynamic> _$SnackRequestToJson(SnackRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.count,
    };
