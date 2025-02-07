import 'package:json_annotation/json_annotation.dart';
part 'diamond_record.g.dart';
@JsonSerializable()
class DiamondRecord{
  final int id;
  final int userId;
  final String changeType;
  final int changeDiamond;
  final int resultDiamond;
  final String changeDesc;
  final String idempotentKey;
  final String createdAt;

  DiamondRecord(this.id, this.userId, this.changeType, this.changeDiamond, this.resultDiamond, this.changeDesc, this.idempotentKey, this.createdAt);
  factory DiamondRecord.fromJson(Map<String, dynamic> json) => _$DiamondRecordFromJson(json);
  Map<String, dynamic> toJson() => _$DiamondRecordToJson(this);
}