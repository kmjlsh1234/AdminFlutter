enum UserStatus{
  NORMAL('NORMAL'),
  LOGOUT('LOGOUT'),
  STOP('STOP'),
  BAN('BAN'),
  TRYEXIT('TRYEXIT'),
  EXIT('EXIT');

  final String status;

  const UserStatus(this.status);

}