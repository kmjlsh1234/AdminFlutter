import 'package:json_annotation/json_annotation.dart';

part 'diamond_record.g.dart';

@JsonSerializable(includeIfNull: false)
class DiamondRecord {
  final int id;
  final int userId;
  final String changeType;
  final int changeDiamond;
  final int resultDiamond;
  final String changeDesc;
  final String idempotentKey;
  final String createdAt;

  DiamondRecord({
    required this.id,
      required this.userId,
      required this.changeType,
      required this.changeDiamond,
      required this.resultDiamond,
      required this.changeDesc,
      required this.idempotentKey,
      required this.createdAt
  });

  factory DiamondRecord.fromJson(Map<String, dynamic> json) => _$DiamondRecordFromJson(json);
  Map<String, dynamic> toJson() => _$DiamondRecordToJson(this);
}
