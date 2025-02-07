enum ChangeType{
  NONE('NONE'),
  ADD('ADD'),
  USE('USE'),
  ;
  const ChangeType(this.changeType);

  final String changeType;
}