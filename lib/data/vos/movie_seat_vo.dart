import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie_ticket/persistence/hive_constants.dart';
import 'package:movie_ticket/resources/strings.dart';

part 'movie_seat_vo.g.dart';

@JsonSerializable(ignoreUnannotated: true)
@HiveType(typeId: HIVE_TYPE_ID_MOVIE_SEAT_VO, adapterName: "MovieSeatVOAdapter")
class MovieSeatVO {
  @JsonKey(name: "id")
  @HiveField(0)
  int? id;

  @JsonKey(name: "type")
  @HiveField(1)
  String? type;

  @JsonKey(name: "seat_name")
  @HiveField(2)
  String? seatName;

  @JsonKey(name: "symbol")
  @HiveField(3)
  String? title;

  @JsonKey(name: "price")
  @HiveField(4)
  double? price;

  @HiveField(5)
  bool isSelected;

  MovieSeatVO({
    this.id,
    this.type,
    this.seatName,
    this.title,
    this.price,
    this.isSelected = false,
  });

  factory MovieSeatVO.fromJson(Map<String, dynamic> json) =>
      _$MovieSeatVOFromJson(json);

  Map<String, dynamic> toJson() => _$MovieSeatVOToJson(this);

  bool isMovieSeatAvailable() {
    return type == SEAT_TYPE_AVAILABLE;
  }

  bool isMovieSeatTaken() {
    return type == SEAT_TYPE_TAKEN;
  }

  bool isMovieSeatTitle() {
    return type == SEAT_TYPE_TEXT;
  }
}
