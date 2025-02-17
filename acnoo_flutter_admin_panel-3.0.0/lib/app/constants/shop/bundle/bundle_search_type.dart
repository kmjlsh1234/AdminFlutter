enum BundleSearchType{
  none('NONE'),
  name('NAME'),
  sku('SKU'),
  ;

  final String value;

  const BundleSearchType(this.value);

  static BundleSearchType fromValue(String value) {
    return BundleSearchType.values.firstWhere((type) => type.value == value,
      orElse: () => throw ArgumentError("Invalid BundleSearchType: $value"),
    );
  }
}