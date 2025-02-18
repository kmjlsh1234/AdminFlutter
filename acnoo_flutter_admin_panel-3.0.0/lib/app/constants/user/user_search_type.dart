enum UserSearchType{
  none("NONE"),
  email("EMAIL"),
  nickname("NICKNAME"),
  mobile("MOBILE"),
  ;

  final String value;
  const UserSearchType(this.value);
}