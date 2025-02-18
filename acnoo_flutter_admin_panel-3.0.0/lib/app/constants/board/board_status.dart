enum BoardStatus{
  publish('PUBLISH'),
  notPublish('NOT_PUBLISH'),
  ;

  final String value;
  const BoardStatus(this.value);
}