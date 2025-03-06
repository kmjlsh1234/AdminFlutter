enum AppVersionType{
  FORCE("강제"),
  INDUCE("권장"),
  BUNDLE("번들"),
  ;

  final String value;
  const AppVersionType(this.value);
}