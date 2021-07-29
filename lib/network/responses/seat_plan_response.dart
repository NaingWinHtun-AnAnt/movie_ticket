import 'package:json_annotation/json_annotation.dart';
import 'package:movie_ticket/data/vos/movie_seat_vo.dart';

part 'seat_plan_response.g.dart';

@JsonSerializable()
class SeatPlanResponse {
  @JsonKey(name: "code")
  int code;

  @JsonKey(name: "message")
  String message;

  @JsonKey(name: "data")
  List<List<MovieSeatVO>> data;

  SeatPlanResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory SeatPlanResponse.fromJson(Map<String, dynamic> json) =>
      _$SeatPlanResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SeatPlanResponseToJson(this);
}
