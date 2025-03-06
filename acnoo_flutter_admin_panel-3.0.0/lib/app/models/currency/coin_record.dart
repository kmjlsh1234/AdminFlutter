import 'package:json_annotation/json_annotation.dart';

import '../../constants/currency/change_type.dart';

part 'coin_record.g.dart';

@JsonSerializable(includeIfNull: false)
class CoinRecord {
  final int id;
  final int userId;
  final ChangeType changeType;
  final int changeCoin;
  final int resultCoin;
  final String changeDesc;
  final String idempotentKey;
  final DateTime createdAt;

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
