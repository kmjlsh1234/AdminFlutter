enum UserSearchDateType{
  NONE("NONE"),
  CREATED_AT("CREATED_AT"),
  UPDATED_AT("UPDATED_AT"),
  LOGIN_AT("LOGIN_AT"),
  ;
  const UserSearchDateType(this.searchType);

  final String searchType;
}