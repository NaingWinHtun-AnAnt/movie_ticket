import 'package:json_annotation/json_annotation.dart';

part 'cinema_vo.g.dart';

@JsonSerializable()
class CinemaVO {
  @JsonKey(name: "id")
  int id;

  @JsonKey(name: "name")
  String name;

  @JsonKey(name: "phone")
  String phone;

  @JsonKey(name: "email")
  String email;

  @JsonKey(name: "address")
  String address;

  CinemaVO({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
  });

  factory CinemaVO.fromJson(Map<String, dynamic> json) => _$CinemaVOFromJson(json);

  Map<String, dynamic> toJson() => _$CinemaVOToJson(this);
}
