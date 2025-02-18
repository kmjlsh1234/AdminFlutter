import 'package:json_annotation/json_annotation.dart';

part 'coin_record.g.dart';

@JsonSerializable(includeIfNull: false)
class CoinRecord {
  final int id;
  final int userId;
  final String changeType;
  final int changeCoin;
  final int resultCoin;
  final String changeDesc;
  final String idempotentKey;
  final String createdAt;

  CoinRecord({
    required this.id,
    required this.userId,
    required this.changeType,
    required this.changeCoin,
    required this.resultCoin,
    required this.changeDesc,
    required this.idempotentKey,
    required this.createdAt
  });

  factory CoinRecord.fromJson(Map<String, dynamic> json) => _$CoinRecordFromJson(json);
  Map<String, dynamic> toJson() => _$CoinRecordToJson(this);
}
