import 'package:json_annotation/json_annotation.dart';
import 'package:movie_ticket/data/vos/transaction_vo.dart';

part 'profile_transaction_response.g.dart';

@JsonSerializable()
class ProfileTransactionResponse {
  @JsonKey(name: "code")
  int code;

  @JsonKey(name: "message")
  String message;

  @JsonKey(name: "data")
  List<TransactionVO> data;

  ProfileTransactionResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory ProfileTransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileTransactionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileTransactionResponseToJson(this);
}
