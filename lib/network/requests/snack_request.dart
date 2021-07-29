import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'snack_request.g.dart';

@JsonSerializable(ignoreUnannotated: true)
class SnackRequest {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "quantity")
  @HiveField(5)
  int? count;

  SnackRequest({
    this.id,
    this.count,
  });

  factory SnackRequest.fromJson(Map<String, dynamic> json) =>
      _$SnackRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SnackRequestToJson(this);
}
