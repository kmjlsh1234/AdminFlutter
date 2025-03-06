enum UserMenu {
  PROFILE('유저 프로필'),
  CURRENCY('유저 재화'),
  CURRENCY_RECORD('유저 재화 기록'),
  LOG('유저 로그'),
  ;

  final String value;
  const UserMenu(this.value);
}