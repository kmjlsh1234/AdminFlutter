enum AdminSearchType{
  NONE("NONE"),
  EMAIL("EMAIL"),
  NAME("NAME"),
  MOBILE("MOBILE"),
  ;
  const AdminSearchType(this.value);

  final String value;
}