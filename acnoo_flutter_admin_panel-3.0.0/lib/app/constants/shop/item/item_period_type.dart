enum ItemPeriodType{
  none('NONE'),
  day('DAY'),
  month('MONTH'),
  expiration('EXPIRATION'),
  ;

  final String value;
  const ItemPeriodType(this.value);

  static ItemPeriodType fromValue(String value) {
    return ItemPeriodType.values.firstWhere((type) => type.value == value,
      orElse: () => throw ArgumentError("Invalid ItemPeriodType: $value"),
    );
  }
}