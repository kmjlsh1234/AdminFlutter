enum ItemPeriodType{
  NONE('NONE'),
  DAY('DAY'),
  MONTH('MONTH'),
  EXPIRATION('EXPIRATION'),
  ;

  final String value;

  const ItemPeriodType(this.value);
}