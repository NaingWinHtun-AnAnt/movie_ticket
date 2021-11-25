import 'package:json_annotation/json_annotation.dart';
import 'package:movie_ticket/data/vos/transaction_vo.dart';

part 'check_out_response.g.dart';

@JsonSerializable()
class CheckOutResponse {
  @JsonKey(name: "code")
  int? code;

  @JsonKey(name: "message")
  String? message;

  @JsonKey(name: "data")
  TransactionVO? data;

  CheckOutResponse({
    this.code,
    this.message,
    this.data,
  });

  factory CheckOutResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckOutResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckOutResponseToJson(this);
}
