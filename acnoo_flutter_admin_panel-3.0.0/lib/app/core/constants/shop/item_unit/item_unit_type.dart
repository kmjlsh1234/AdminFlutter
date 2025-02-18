enum ItemUnitType{
  none('NONE'),
  consumable('CONSUMABLE'),
  permanent('PERMANENT'),
  expiration('EXPIRATION'),
  ;

  final String value;
  const ItemUnitType(this.value);
}