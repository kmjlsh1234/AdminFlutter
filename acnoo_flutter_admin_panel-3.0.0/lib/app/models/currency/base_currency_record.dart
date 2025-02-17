import 'package:json_annotation/json_annotation.dart';

part 'base_currency_record.g.dart';

@JsonSerializable(includeIfNull: false)
class BaseCurrencyRecord {
  final int id;
  final int userId;
  final String changeType;
  final int changeAmount;
  final int resultAmount;
  final String changeDesc;
  final String idempotentKey;
  final DateTime createdAt;

  BaseCurrencyRecord({
    required this.id,
    required this.userId,
    required this.changeType,
    required this.changeAmount,
    required this.resultAmount,
    required this.changeDesc,
    required this.idempotentKey,
    required this.createdAt
  });

  factory BaseCurrencyRecord.fromJson(Map<String, dynamic> json) => _$BaseCurrencyRecordFromJson(json);
  Map<String, dynamic> toJson() => _$BaseCurrencyRecordToJson(this);
}
