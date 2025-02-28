import 'package:json_annotation/json_annotation.dart';

part 'bundle.g.dart';

@JsonSerializable(includeIfNull: true)
class Bundle {
  final int id;
  final String name;
  final String sku;
  final String description;
  final String status;
  final String thumbnail;
  final String image;
  final String info;
  final int? countPerPerson;
  final DateTime? saleStartDate;
  final DateTime? saleEndDate;
  final String currencyType;
  final int amount;
  final int originAmount;
  final int? stockQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  Bundle({
    required this.id,
    required this.name,
    required this.sku,
    required this.description,
    required this.status,
    required this.thumbnail,
    required this.image,
    required this.info,
    required this.countPerPerson,
    required this.saleStartDate,
    required this.saleEndDate,
    required this.currencyType,
    required this.amount,
    required this.originAmount,
    required this.stockQuantity,
    required this.createdAt,
    required this.updatedAt
  });

  factory Bundle.fromJson(Map<String, dynamic> json) => _$BundleFromJson(json);
  Map<String, dynamic> toJson() => _$BundleToJson(this);
}
