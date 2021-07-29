import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie_ticket/persistence/hive_constants.dart';

part 'cast_vo.g.dart';

@JsonSerializable()
@HiveType(typeId: HIVE_TYPE_ID_CAST_VO, adapterName: "CastVOAdapter")
class CastVO {
  @JsonKey(name: "adult")
  @HiveField(0)
  bool adult;

  @JsonKey(name: "gender")
  @HiveField(1)
  int gender;

  @JsonKey(name: "id")
  @HiveField(2)
  int id;

  @JsonKey(name: "known_for_department")
  @HiveField(3)
  String knownForDepartment;

  @JsonKey(name: "name")
  @HiveField(4)
  String name;

  @JsonKey(name: "original_name")
  @HiveField(5)
  String originalName;

  @JsonKey(name: "popularity")
  @HiveField(6)
  double popularity;

  @JsonKey(name: "profile_path")
  @HiveField(7)
  String? profilePath;

  @JsonKey(name: "cast_id")
  @HiveField(8)
  int castId;

  @JsonKey(name: "character")
  @HiveField(9)
  String character;

  @JsonKey(name: "credit_id")
  @HiveField(10)
  String creditId;

  @JsonKey(name: "order")
  @HiveField(11)
  int order;

  CastVO({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
    required this.castId,
    required this.character,
    required this.creditId,
    required this.order,
  });

  factory CastVO.fromJson(Map<String, dynamic> json) => _$CastVOFromJson(json);

  Map<String, dynamic> toJson() => _$CastVOToJson(this);
}
