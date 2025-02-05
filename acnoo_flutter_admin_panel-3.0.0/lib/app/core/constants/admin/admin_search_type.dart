enum AdminSearchType{
  NONE("NONE"),
  EMAIL("EMAIL"),
  NAME("NAME"),
  MOBILE("MOBILE"),
  ;
  const AdminSearchType(this.searchType);

  final String searchType;
}