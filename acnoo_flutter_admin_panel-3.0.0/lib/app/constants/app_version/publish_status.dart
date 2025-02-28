enum PublishStatus{
  publish('PUBLISH'),
  notPublish('NOT_PUBLISH'),
  ;

  final String value;
  const PublishStatus(this.value);

  static PublishStatus fromValue(String value) {
    return PublishStatus.values.firstWhere((type) => type.value == value,
      orElse: () => throw ArgumentError("Invalid PublishStatus: $value"),
    );
  }
}