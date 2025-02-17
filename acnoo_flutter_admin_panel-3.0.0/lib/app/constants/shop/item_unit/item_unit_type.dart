enum ItemUnitType{
  none('NONE'),
  consumable('CONSUMABLE'),
  permanent('PERMANENT'),
  expiration('EXPIRATION'),
  ;

  final String value;
  const ItemUnitType(this.value);

  static ItemUnitType fromValue(String value) {
    return ItemUnitType.values.firstWhere((type) => type.value == value,
      orElse: () => throw ArgumentError("Invalid ItemUnitType: $value"),
    );
  }
}