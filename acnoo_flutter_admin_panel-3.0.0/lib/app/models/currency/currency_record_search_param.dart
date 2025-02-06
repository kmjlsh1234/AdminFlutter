import 'package:json_annotation/json_annotation.dart';
part 'currency_record_search_param.g.dart';
@JsonSerializable()
class CurrencyRecordSearchParam{
  final int userId;

  @JsonKey(includeIfNull: true)
  final String? changeType;

  @JsonKey(includeIfNull: true)
  final String? startDate;
  @JsonKey(includeIfNull: true)
  final String? endDate;

  final int page;
  final int limit;

  CurrencyRecordSearchParam(this.userId, this.changeType, this.startDate, this.endDate, this.page, this.limit);
  factory CurrencyRecordSearchParam.fromJson(Map<String, dynamic> json) => _$CurrencyRecordSearchParamFromJson(json);
  Map<String, dynamic> toJson() => _$CurrencyRecordSearchParamToJson(this);
}