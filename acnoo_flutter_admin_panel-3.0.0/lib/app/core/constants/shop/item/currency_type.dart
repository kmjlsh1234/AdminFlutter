enum CurrencyType{
  DIAMOND('DIAMOND'),
  COIN('COIN'),
  CHIP('CHIP'),
  FREE('FREE'),
  EVENT('EVENT'),
  ;

  final String value;

  const CurrencyType(this.value);
}