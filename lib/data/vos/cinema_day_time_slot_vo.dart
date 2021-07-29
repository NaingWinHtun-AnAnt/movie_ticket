import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie_ticket/data/vos/time_slot_vo.dart';
import 'package:movie_ticket/persistence/hive_constants.dart';

part 'cinema_day_time_slot_vo.g.dart';

@JsonSerializable(ignoreUnannotated: true)
@HiveType(
    typeId: HIVE_TYPE_ID_CINEMA_DAY_TIME_SLOT_VO,
    adapterName: "CinemaDayTimeSlotVOAdapter")
class CinemaDayTimeSlotVO {
  @JsonKey(name: "cinema_id")
  @HiveField(0)
  int cinemaId;

  @JsonKey(name: "cinema")
  @HiveField(1)
  String cinema;

  @JsonKey(name: "timeslots")
  @HiveField(2)
  List<TimeSlotVO> timeslots;

  @HiveField(3)
  bool? isSelected;

  @HiveField(4)
  String? bookingDate;

  CinemaDayTimeSlotVO({
    required this.cinemaId,
    required this.cinema,
    required this.timeslots,
    this.isSelected,
    this.bookingDate,
  });

  factory CinemaDayTimeSlotVO.fromJson(Map<String, dynamic> json) =>
      _$CinemaDayTimeSlotVOFromJson(json);

  Map<String, dynamic> toJson() => _$CinemaDayTimeSlotVOToJson(this);
}
