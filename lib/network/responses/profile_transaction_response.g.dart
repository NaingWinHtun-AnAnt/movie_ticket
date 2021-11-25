// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_transaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileTransactionResponse _$ProfileTransactionResponseFromJson(
    Map<String, dynamic> json) {
  return ProfileTransactionResponse(
    code: json['code'] as int?,
    message: json['message'] as String?,
    data: (json['data'] as List<dynamic>?)
        ?.map((e) => TransactionVO.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ProfileTransactionResponseToJson(
        ProfileTransactionResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
