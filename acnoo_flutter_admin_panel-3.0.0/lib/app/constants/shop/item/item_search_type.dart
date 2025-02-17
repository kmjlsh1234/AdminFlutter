enum ItemSearchType{
  none('NONE'),
  name('NAME'),
  sku('SKU'),
  ;

  final String value;
  const ItemSearchType(this.value);
}