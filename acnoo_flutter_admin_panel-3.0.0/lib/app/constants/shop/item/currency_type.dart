enum CurrencyType{
  diamond('DIAMOND'),
  coin('COIN'),
  chip('CHIP'),
  free('FREE'),
  event('EVENT'),
  ;

  final String value;
  const CurrencyType(this.value);

  static CurrencyType fromValue(String value) {
    return CurrencyType.values.firstWhere((type) => type.value == value,
      orElse: () => throw ArgumentError("Invalid CurrencyType: $value"),
    );
  }
}