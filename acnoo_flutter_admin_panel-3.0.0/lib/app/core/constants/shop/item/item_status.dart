enum ItemStatus{
  READY('READY'),        // 준비중
  ON_SALE('ON_SALE'),      // 판매중
  STOP_SELLING('STOP_SELLING'), // 판매중지
  REMOVED('REMOVED'),
  ;
  final String value;

  const ItemStatus(this.value);

}