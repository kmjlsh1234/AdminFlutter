enum AppVersionType{
  force("FORCE"),
  induce("INDUCE"),
  bundle("BUNDLE"),
  ;

  final String value;
  const AppVersionType(this.value);
}