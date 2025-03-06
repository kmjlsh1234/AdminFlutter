import 'package:acnoo_flutter_admin_panel/app/models/common/paging_param.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../constants/currency/change_type.dart';
part 'currency_record_search_param.g.dart';
@JsonSerializable(includeIfNull: true)
class CurrencyRecordSearchParam extends PagingParam{
  final int userId;
  final ChangeType? changeType;
  final String? startDate;
  final String? endDate;

  CurrencyRecordSearchParam({
    required this.userId,
    required this.changeType,
    required this.startDate,
    required this.endDate,
    required int page,
    required int limit
  }) : super(page, limit);

  factory CurrencyRecordSearchParam.fromJson(Map<String, dynamic> json) => _$CurrencyRecordSearchParamFromJson(json);
  Map<String, dynamic> toJson() => _$CurrencyRecordSearchParamToJson(this);
}