import 'package:json_annotation/json_annotation.dart';
import 'package:movie_ticket/data/vos/cinema_day_time_slot_vo.dart';

part 'cinema_day_timeslot_response.g.dart';

@JsonSerializable()
class CinemaDayTimeSlotResponse {
  @JsonKey(name: "code")
  int? code;

  @JsonKey(name: "message")
  String? message;

  @JsonKey(name: "data")
  List<CinemaDayTimeSlotVO>? data;

  CinemaDayTimeSlotResponse({
    this.code,
    this.message,
    this.data,
  });

  factory CinemaDayTimeSlotResponse.fromJson(Map<String, dynamic> json) =>
      _$CinemaDayTimeSlotResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CinemaDayTimeSlotResponseToJson(this);
}
