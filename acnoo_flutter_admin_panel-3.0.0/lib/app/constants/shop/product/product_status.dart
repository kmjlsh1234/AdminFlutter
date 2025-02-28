enum ProductStatus {
  none('NONE'),
  ready('READY'),
  onSale('ON_SALE'),
  stopSelling('STOP_SELLING'),
  removed('REMOVED'),
  ;

  final String value;
  const ProductStatus(this.value);

  static ProductStatus fromValue(String value) {
    return ProductStatus.values.firstWhere((type) => type.value == value,
      orElse: () => throw ArgumentError("Invalid ProductStatus: $value"),
    );
  }
}