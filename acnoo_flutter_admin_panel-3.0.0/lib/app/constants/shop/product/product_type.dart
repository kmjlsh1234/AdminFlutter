enum ProductType{
  currency('CURRENCY'),
  ;
  final String value;

  const ProductType(this.value);

  static ProductType fromValue(String value) {
    return ProductType.values.firstWhere((type) => type.value == value,
      orElse: () => throw ArgumentError("Invalid ProductType: $value"),
    );
  }
}