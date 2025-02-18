enum ItemPeriodType{
  none('NONE'),
  day('DAY'),
  month('MONTH'),
  expiration('EXPIRATION'),
  ;

  final String value;
  const ItemPeriodType(this.value);
}