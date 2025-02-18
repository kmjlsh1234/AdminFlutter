enum AdminSearchType{
  none("NONE"),
  email("EMAIL"),
  name("NAME"),
  mobile("MOBILE"),
  ;

  final String value;
  const AdminSearchType(this.value);
}