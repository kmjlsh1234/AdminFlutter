enum ItemStatus{
  ready('READY'),
  onSale('ON_SALE'),
  stopSelling('STOP_SELLING'),
  removed('REMOVED'),
  ;

  final String value;
  const ItemStatus(this.value);

  static ItemStatus fromValue(String value) {
    return ItemStatus.values.firstWhere((type) => type.value == value,
      orElse: () => throw ArgumentError("Invalid ItemStatus: $value"),
    );
  }
}