enum ItemUnitType{
  CONSUMABLE('소모성'),
  PERMANENT('영구'),
  EXPIRATION('기간제'),
  ;

  final String value;
  const ItemUnitType(this.value);
}