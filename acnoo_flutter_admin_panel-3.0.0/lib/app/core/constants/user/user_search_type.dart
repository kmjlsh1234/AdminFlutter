enum UserSearchType{
  NONE("NONE"),
  EMAIL("EMAIL"),
  NICKNAME("NICKNAME"),
  MOBILE("MOBILE"),
  ;
  const UserSearchType(this.searchType);

  final String searchType;
}