enum AdminStatus{
  NORMAL('정상'),
  LOGOUT('로그 아웃'),
  STOP('이용 정지'),
  BAN('강제 탈퇴'),
  EXIT('탈퇴'),
  ;

  final String value;
  const AdminStatus(this.value);
}