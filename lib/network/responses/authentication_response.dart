import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie_ticket/data/vos/user_vo.dart';
import 'package:movie_ticket/persistence/hive_constants.dart';

part 'authentication_response.g.dart';

@JsonSerializable()
@HiveType(
    typeId: HIVE_TYPE_ID_AUTH_RESPONSE,
    adapterName: "AuthenticationResponseAdapter")
class AuthenticationResponse {
  @JsonKey(name: "code")
  @HiveField(0)
  int code;

  @JsonKey(name: "message")
  @HiveField(1)
  String message;

  @JsonKey(name: "data")
  @HiveField(2)
  UserVO? data;

  @JsonKey(name: "token")
  @HiveField(3)
  String? token;

  AuthenticationResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.token,
  });

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticationResponseToJson(this);
}
