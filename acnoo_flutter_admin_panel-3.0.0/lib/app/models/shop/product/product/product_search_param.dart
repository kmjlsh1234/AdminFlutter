import 'package:acnoo_flutter_admin_panel/app/models/common/paging_param.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_search_param.g.dart';

@JsonSerializable(includeIfNull: true)
class ProductSearchParam extends PagingParam {
  final String? searchStatus;
  final String? searchValue;

  ProductSearchParam({
    required this.searchStatus,
    required this.searchValue,
    required int page,
    required int limit
  }) : super(page,limit);

  factory ProductSearchParam.fromJson(Map<String, dynamic> json) => _$ProductSearchParamFromJson(json);
  Map<String, dynamic> toJson() => _$ProductSearchParamToJson(this);
}