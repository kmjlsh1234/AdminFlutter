import 'package:json_annotation/json_annotation.dart';
part 'bundle_mod_param.g.dart';

@JsonSerializable(includeIfNull: true)
class BundleModParam{
  final String? name;
  final String? sku;
  final String? description;
  final String? thumbnail;
  final String? image;
  final String? info;
  final int? countPerPerson;
  final String? saleStartDate;
  final String? saleEndDate;
  final String? currencyType;
  final int? amount;
  final int? originAmount;
  final int? stockQuantity;

  BundleModParam({
    required this.name,
    required this.sku,
    required this.description,
    required this.thumbnail,
    required this.image,
    required this.info,
    required this.countPerPerson,
    required this.saleStartDate,
    required this.saleEndDate,
    required this.currencyType,
    required this.amount,
    required this.originAmount,
    required this.stockQuantity
  });

  factory BundleModParam.fromJson(Map<String, dynamic> json) => _$BundleModParamFromJson(json);
  Map<String, dynamic> toJson() => _$BundleModParamToJson(this);
}