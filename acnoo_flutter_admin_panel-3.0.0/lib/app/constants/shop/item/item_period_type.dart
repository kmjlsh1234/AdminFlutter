enum ItemPeriodType{
  NONE('없음'),
  DAY('일 별'),
  MONTH('월 별'),
  EXPIRATION('기한'),
  ;

  final String value;
  const ItemPeriodType(this.value);
}