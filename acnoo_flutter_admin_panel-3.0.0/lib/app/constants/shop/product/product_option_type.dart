enum ProductOptionType {
  diamond('DIAMOND'),
  coin('COIN'),
  item('ITEM'),
  ;
  final String value;
  const ProductOptionType(this.value);

  static ProductOptionType fromValue(String value) {
    return ProductOptionType.values.firstWhere((type) => type.value == value,
      orElse: () => throw ArgumentError("Invalid ProductOptionType: $value"),
    );
  }
}