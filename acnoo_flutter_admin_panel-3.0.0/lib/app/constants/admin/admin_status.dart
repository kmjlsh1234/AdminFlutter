enum AdminStatus{
  normal('NORMAL'),
  logout('LOGOUT'),
  stop('STOP'),
  ban('BAN'),
  exit('EXIT'),
  ;

  final String value;
  const AdminStatus(this.value);

  static AdminStatus fromValue(String value) {
    return AdminStatus.values.firstWhere((type) => type.value == value,
      orElse: () => throw ArgumentError("Invalid AdminStatus: $value"),
    );
  }
}