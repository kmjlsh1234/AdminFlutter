import 'package:acnoo_flutter_admin_panel/app/models/currency/base_currency_record.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coin_record.g.dart';

@JsonSerializable(includeIfNull: false)
class CoinRecord extends BaseCurrencyRecord{

  final int changeCoin;
  final int resultCoin;

  CoinRecord({
    required int id,
    required int userId,
    required String changeType,
    required this.changeCoin,
    required this.resultCoin,
    required String changeDesc,
    required String idempotentKey,
    required DateTime createdAt,
  }) : super(
    id: id,
    userId: userId,
    changeType: changeType,
    changeAmount: changeCoin,
    resultAmount: resultCoin,
    changeDesc: changeDesc,
    idempotentKey: idempotentKey,
    createdAt: createdAt,
  );

  factory CoinRecord.fromJson(Map<String, dynamic> json) => _$CoinRecordFromJson(json);
  Map<String, dynamic> toJson() => _$CoinRecordToJson(this);
}
