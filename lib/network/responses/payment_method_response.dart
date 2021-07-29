import 'package:json_annotation/json_annotation.dart';
import 'package:movie_ticket/data/vos/payment_method_vo.dart';

part 'payment_method_response.g.dart';

@JsonSerializable()
class PaymentMethodResponse {
  @JsonKey(name: "code")
  int code;

  @JsonKey(name: "message")
  String message;

  @JsonKey(name: "data")
  List<PaymentMethodVO> data;

  PaymentMethodResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory PaymentMethodResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodResponseToJson(this);
}
