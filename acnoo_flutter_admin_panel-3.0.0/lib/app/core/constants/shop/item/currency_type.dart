enum CurrencyType{
  diamond('DIAMOND'),
  coin('COIN'),
  chip('CHIP'),
  free('FREE'),
  event('EVENT'),
  ;

  final String value;
  const CurrencyType(this.value);
}