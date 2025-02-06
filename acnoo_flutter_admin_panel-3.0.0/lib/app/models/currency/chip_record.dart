import 'package:json_annotation/json_annotation.dart';
part 'chip_record.g.dart';
@JsonSerializable()
class ChipRecord{
  final int id;
  final int userId;
  final String changeType;
  final int changeChip;
  final int resultChip;
  final String changeDesc;
  final String idempotentKey;
  final String createdAt;

  ChipRecord(this.id, this.userId, this.changeType, this.changeChip, this.resultChip, this.changeDesc, this.idempotentKey, this.createdAt);
  factory ChipRecord.fromJson(Map<String, dynamic> json) => _$ChipRecordFromJson(json);
  Map<String, dynamic> toJson() => _$ChipRecordToJson(this);
}