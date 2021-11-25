import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie_ticket/data/vos/snack_vo.dart';
import 'package:movie_ticket/data/vos/time_slot_vo.dart';
import 'package:movie_ticket/persistence/hive_constants.dart';

part 'transaction_vo.g.dart';

@JsonSerializable()
@HiveType(
    typeId: HIVE_TYPE_ID_TRANSACTION_VO, adapterName: "TransactionVOAdapter")
class TransactionVO {
  @JsonKey(name: "id")
  @HiveField(0)
  int id;

  @JsonKey(name: "booking_no")
  @HiveField(1)
  String? bookingNo;

  @JsonKey(name: "booking_date")
  @HiveField(2)
  String? bookingDate;

  @JsonKey(name: "row")
  @HiveField(3)
  String? row;

  @JsonKey(name: "seat")
  @HiveField(4)
  String? seat;

  @JsonKey(name: "total_seat")
  @HiveField(5)
  int? totalSeat;

  @JsonKey(name: "total")
  @HiveField(6)
  String? total;

  @JsonKey(name: "movie_id")
  @HiveField(7)
  int? movieId;

  @JsonKey(name: "cinema_id")
  @HiveField(8)
  int? cinemaId;

  @JsonKey(name: "username")
  @HiveField(9)
  String? username;

  @JsonKey(name: "timeslot")
  @HiveField(10)
  TimeSlotVO? timeslot;

  @JsonKey(name: "snacks")
  @HiveField(11)
  List<SnackVO>? snacks;

  TransactionVO({
    required this.id,
    this.bookingNo,
    this.bookingDate,
    this.row,
    this.seat,
    this.totalSeat,
    this.total,
    this.movieId,
    this.cinemaId,
    this.username,
    this.timeslot,
    this.snacks,
  });

  factory TransactionVO.fromJson(Map<String, dynamic> json) =>
      _$TransactionVOFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionVOToJson(this);
}
