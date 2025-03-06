import 'package:json_annotation/json_annotation.dart';

import '../../constants/currency/change_type.dart';
import '../../constants/user/os.dart';

part 'diamond_record.g.dart';

@JsonSerializable(includeIfNull: false)
class DiamondRecord {
  final int id;
  final int userId;
  final ChangeType changeType;
  final Os os;
  final int changeDiamond;
  final int resultFreeDiamond;
  final int resultAndroidDiamond;
  final int resultIosDiamond;
  final int resultPaidDiamond;
  final String changeDesc;
  final String idempotentKey;
  final DateTime createdAt;

  DiamondRecord({
    required this.id,
    required this.userId,
    required this.changeType,
    required this.os,
    required this.changeDiamond,
    required this.resultFreeDiamond,
    required this.resultAndroidDiamond,
    required this.resultIosDiamond,
    required this.resultPaidDiamond,
    required this.changeDesc,
    required this.idempotentKey,
    required this.createdAt
  });

  factory DiamondRecord.fromJson(Map<String, dynamic> json) => _$DiamondRecordFromJson(json);
  Map<String, dynamic> toJson() => _$DiamondRecordToJson(this);
}
