enum AdminMenu{
  profile('PROFILE'),
  log('LOG'),
  ;

  final String value;
  const AdminMenu(this.value);

  static AdminMenu fromValue(String value) {
    return AdminMenu.values.firstWhere((type) => type.value == value,
      orElse: () => throw ArgumentError("Invalid AdminMenu: $value"),
    );
  }
}