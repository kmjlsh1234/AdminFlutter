import 'package:json_annotation/json_annotation.dart';
part 'coin_record.g.dart';
@JsonSerializable()
class CoinRecord{
  final int id;
  final int userId;
  final String changeType;
  final int changeCoin;
  final int resultCoin;
  final String changeDesc;
  final String idempotentKey;
  final String createdAt;

  CoinRecord(this.id, this.userId, this.changeType, this.changeCoin, this.resultCoin, this.changeDesc, this.idempotentKey, this.createdAt);
  factory CoinRecord.fromJson(Map<String, dynamic> json) => _$CoinRecordFromJson(json);
  Map<String, dynamic> toJson() => _$CoinRecordToJson(this);
}