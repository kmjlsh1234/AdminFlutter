enum UserSearchType{
  NONE("NONE"),
  EMAIL("EMAIL"),
  NICKNAME("NICKNAME"),
  MOBILE("MOBILE"),
  ;
  const UserSearchType(this.value);

  final String value;
}