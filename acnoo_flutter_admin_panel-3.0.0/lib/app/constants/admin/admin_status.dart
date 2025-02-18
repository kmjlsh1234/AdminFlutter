enum AdminStatus{
  normal('NORMAL'),
  logout('LOGOUT'),
  stop('STOP'),
  ban('BAN'),
  exit('EXIT'),
  ;

  final String value;
  const AdminStatus(this.value);
}