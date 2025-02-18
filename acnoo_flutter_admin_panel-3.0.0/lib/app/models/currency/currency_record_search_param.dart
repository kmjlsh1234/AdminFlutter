import 'package:acnoo_flutter_admin_panel/app/models/common/paging_param.dart';
import 'package:json_annotation/json_annotation.dart';
part 'currency_record_search_param.g.dart';
@JsonSerializable(includeIfNull: true)
class CurrencyRecordSearchParam extends PagingParam{
  final int userId;
  final String? changeType;
  final String? startDate;
  final String? endDate;

  CurrencyRecordSearchParam(
      this.userId,
      this.changeType,
      this.startDate,
      this.endDate,
      int page,
      int limit
  ) : super(page, limit);

  factory CurrencyRecordSearchParam.fromJson(Map<String, dynamic> json) => _$CurrencyRecordSearchParamFromJson(json);
  Map<String, dynamic> toJson() => _$CurrencyRecordSearchParamToJson(this);
}