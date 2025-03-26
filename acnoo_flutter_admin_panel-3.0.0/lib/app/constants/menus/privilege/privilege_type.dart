enum PrivilegeType{
  MENU('메뉴 권한'),
  NOT_MENU('그 외 권한'),
  ;
  final String value;
  const PrivilegeType(this.value);
}