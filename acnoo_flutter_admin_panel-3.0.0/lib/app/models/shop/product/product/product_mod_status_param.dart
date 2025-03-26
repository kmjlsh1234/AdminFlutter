import 'package:json_annotation/json_annotation.dart';

import '../../../../constants/shop/product/product_status.dart';
part 'product_mod_status_param.g.dart';

@JsonSerializable(includeIfNull: false)
class ProductModStatusParam {
  final ProductStatus status;

  ProductModStatusParam({required this.status});

  factory ProductModStatusParam.fromJson(Map<String, dynamic> json) => _$ProductModStatusParamFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModStatusParamToJson(this);
}