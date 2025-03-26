enum CurrencyType{
  DIAMOND('다이아 재화'),
  COIN('코인 재화'),
  CHIP('칩 재화'),
  FREE('무료 재화'),
  EVENT('이벤트 재화'),
  ;

  final String value;
  const CurrencyType(this.value);
}