enum ItemUnitSearchType{
  none('NONE'),
  name('NAME'),
  sku('SKU'),
  ;

  final String value;
  const ItemUnitSearchType(this.value);
}