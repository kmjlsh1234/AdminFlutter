enum UserSearchType{
  NONE("NONE"),
  EMAIL("EMAIL"),
  NAME("NAME"),
  MOBILE("MOBILE"),
  ;
  const UserSearchType(this.searchType);

  final String searchType;
}