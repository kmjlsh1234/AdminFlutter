enum UserStatus{
  normal('NORMAL'),
  logout('LOGOUT'),
  stop('STOP'),
  ban('BAN'),
  tryExit('TRYEXIT'),
  exit('EXIT');

  final String value;
  const UserStatus(this.value);

  static UserStatus fromValue(String value) {
    return UserStatus.values.firstWhere((type) => type.value == value,
      orElse: () => throw ArgumentError("Invalid UserStatus: $value"),
    );
  }
}