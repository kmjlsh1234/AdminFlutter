enum ItemStatus{
  ready('READY'),
  onSale('ON_SALE'),
  stopSelling('STOP_SELLING'),
  removed('REMOVED'),
  ;

  final String value;
  const ItemStatus(this.value);

}