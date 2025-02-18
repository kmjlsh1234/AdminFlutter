enum UserStatus{
  normal('NORMAL'),
  logout('LOGOUT'),
  stop('STOP'),
  ban('BAN'),
  tryExit('TRYEXIT'),
  exit('EXIT');

  final String value;
  const UserStatus(this.value);

}