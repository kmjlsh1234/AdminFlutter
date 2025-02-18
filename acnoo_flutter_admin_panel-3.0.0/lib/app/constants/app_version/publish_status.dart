enum PublishStatus{
  publish('PUBLISH'),
  notPublish('NOT_PUBLISH'),
  ;

  final String value;
  const PublishStatus(this.value);
}