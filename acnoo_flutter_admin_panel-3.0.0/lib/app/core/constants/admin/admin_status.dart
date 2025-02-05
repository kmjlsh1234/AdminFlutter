enum AdminStatus{
  NORMAL('NORMAL'),
  LOGOUT('LOGOUT'),
  STOP('STOP'),
  BAN('BAN'),
  EXIT('EXIT'),
  ;
  const AdminStatus(this.adminStatus);

  final String adminStatus;
}