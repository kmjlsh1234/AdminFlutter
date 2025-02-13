enum ItemUnitType{
  NONE('NONE'),
  CONSUMABLE('CONSUMABLE'), // 소모성
  PERMANENT('PERMANENT'),  // 영구
  EXPIRATION('EXPIRATION'),
  ;
  const ItemUnitType(this.type);

  final String type;
}