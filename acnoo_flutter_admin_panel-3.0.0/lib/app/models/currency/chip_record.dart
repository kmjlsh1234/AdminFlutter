import 'package:json_annotation/json_annotation.dart';

import '../../constants/currency/change_type.dart';

part 'chip_record.g.dart';

@JsonSerializable(includeIfNull: false)
class ChipRecord {
  final int id;
  final int userId;
  final ChangeType changeType;
  final int changeChip;
  final int resultChip;
  final String changeDesc;
  final String idempotentKey;
  final DateTime createdAt;

  ChipRecord({
    required this.id,
    required this.userId,
    required this.changeType,
    required this.changeChip,
    required this.resultChip,
    required this.changeDesc,
    required this.idempotentKey,
    required this.createdAt
  });

  factory ChipRecord.fromJson(Map<String, dynamic> json) => _$ChipRecordFromJson(json);
  Map<String, dynamic> toJson() => _$ChipRecordToJson(this);
}
