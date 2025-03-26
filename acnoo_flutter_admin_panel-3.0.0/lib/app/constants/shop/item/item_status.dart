enum ItemStatus{
  READY('준비 중'),
  ON_SALE('판매 중'),
  STOP_SELLING('판매 중지'),
  REMOVED('제거 됨'),
  ;

  final String value;
  const ItemStatus(this.value);
}