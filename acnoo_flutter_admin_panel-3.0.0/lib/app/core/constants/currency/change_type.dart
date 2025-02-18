enum ChangeType{
  none('NONE'),
  add('ADD'),
  use('USE'),
  ;

  final String value;
  const ChangeType(this.value);
}