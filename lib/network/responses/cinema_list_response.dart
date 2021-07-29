import 'package:json_annotation/json_annotation.dart';
import 'package:movie_ticket/data/vos/cinema_vo.dart';

part 'cinema_list_response.g.dart';

@JsonSerializable()
class CinemaListResponse {
  @JsonKey(name: "code")
  int code;

  @JsonKey(name: "message")
  String message;

  @JsonKey(name: "data")
  List<CinemaVO> data;

  CinemaListResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory CinemaListResponse.fromJson(Map<String, dynamic> json) =>
      _$CinemaListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CinemaListResponseToJson(this);
}
