enum AppVersionType{
  FORCE("FORCE"),   //강제 업데이트
  INDUCE("INDUCE"), //권장 업데이트
  BUNDLE("BUNDLE"), // 번들 업데이트
  ;
  final String type;

  const AppVersionType(this.type);
}