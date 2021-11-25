import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie_ticket/persistence/hive_constants.dart';

part 'card_vo.g.dart';

@JsonSerializable(ignoreUnannotated: true)
@HiveType(typeId: HIVE_TYPE_ID_CARD_VO, adapterName: "CardVOAdapter")
class CardVO {
  @JsonKey(name: "id")
  @HiveField(5)
  int id;

  @JsonKey(name: "card_holder")
  @HiveField(1)
  String? cardHolder;

  @JsonKey(name: "card_number")
  @HiveField(2)
  String? cardNumber;

  @JsonKey(name: "expiration_date")
  @HiveField(3)
  String? expirationDate;

  @JsonKey(name: "card_type")
  @HiveField(4)
  String? cardType;

  bool isSelected;

  CardVO({
    required this.id,
    this.cardHolder,
    this.cardNumber,
    this.expirationDate,
    this.cardType,
    this.isSelected = false,
  });

  factory CardVO.fromJson(Map<String, dynamic> json) => _$CardVOFromJson(json);

  Map<String, dynamic> toJson() => _$CardVOToJson(this);
}
