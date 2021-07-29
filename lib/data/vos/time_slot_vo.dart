import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie_ticket/persistence/hive_constants.dart';

part 'time_slot_vo.g.dart';

@JsonSerializable(ignoreUnannotated: true)
@HiveType(typeId: HIVE_TYPE_ID_TIME_SLOT_VO, adapterName: "TimeSlotVOAdapter")
class TimeSlotVO {
  @JsonKey(name: "cinema_day_timeslot_id")
  @HiveField(0)
  int cinemaDayTimeslotId;

  @JsonKey(name: "start_time")
  @HiveField(1)
  String starTime;

  @HiveField(2)
  bool? isSelected;

  TimeSlotVO({
    required this.cinemaDayTimeslotId,
    required this.starTime,
    this.isSelected = false,
  });

  factory TimeSlotVO.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotVOFromJson(json);

  Map<String, dynamic> toJson() => _$TimeSlotVOToJson(this);
}
