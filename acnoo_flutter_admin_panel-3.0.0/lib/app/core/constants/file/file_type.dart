enum FileType{
  IMAGE('image'),
  CSV('csv'),
  ;
  final String type;

  const FileType(this.type);
}