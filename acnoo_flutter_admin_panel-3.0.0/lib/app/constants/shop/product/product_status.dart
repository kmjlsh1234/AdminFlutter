enum ProductStatus {
  none('NONE'),
  ready('READY'),
  onSale('ON_SALE'),
  stopSelling('STOP_SELLING'),
  removed('REMOVED'),
  ;

  final String value;

  const ProductStatus(this.value);
}