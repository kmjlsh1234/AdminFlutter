import 'package:acnoo_flutter_admin_panel/app/models/currency/base_currency_record.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chip_record.g.dart';

@JsonSerializable(includeIfNull: false)
class ChipRecord extends BaseCurrencyRecord{
  final int changeChip;
  final int resultChip;

  ChipRecord({
    required int id,
    required int userId,
    required String changeType,
    required this.changeChip,
    required this.resultChip,
    required String changeDesc,
    required String idempotentKey,
    required DateTime createdAt,
  }) : super(
    id: id,
    userId: userId,
    changeType: changeType,
    changeAmount: changeChip,
    resultAmount: resultChip,
    changeDesc: changeDesc,
    idempotentKey: idempotentKey,
    createdAt: createdAt,
  );

  factory ChipRecord.fromJson(Map<String, dynamic> json) => _$ChipRecordFromJson(json);
  Map<String, dynamic> toJson() => _$ChipRecordToJson(this);
}
