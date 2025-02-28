import 'package:acnoo_flutter_admin_panel/app/models/currency/base_currency_record.dart';
import 'package:json_annotation/json_annotation.dart';

part 'diamond_record.g.dart';

@JsonSerializable(includeIfNull: false)
class DiamondRecord extends BaseCurrencyRecord{
  final int changeDiamond;
  final int resultDiamond;

  DiamondRecord({
    required int id,
    required int userId,
    required String changeType,
    required this.changeDiamond,
    required this.resultDiamond,
    required String changeDesc,
    required String idempotentKey,
    required DateTime createdAt,
  }) : super(
    id: id,
    userId: userId,
    changeType: changeType,
    changeAmount: changeDiamond,
    resultAmount: resultDiamond,
    changeDesc: changeDesc,
    idempotentKey: idempotentKey,
    createdAt: createdAt,
  );

  factory DiamondRecord.fromJson(Map<String, dynamic> json) => _$DiamondRecordFromJson(json);
  Map<String, dynamic> toJson() => _$DiamondRecordToJson(this);
}
