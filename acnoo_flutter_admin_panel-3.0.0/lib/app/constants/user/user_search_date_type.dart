enum UserSearchDateType{
  none("NONE"),
  createdAt("CREATED_AT"),
  updatedAt("UPDATED_AT"),
  loginAt("LOGIN_AT"),
  ;

  final String value;
  const UserSearchDateType(this.value);
}