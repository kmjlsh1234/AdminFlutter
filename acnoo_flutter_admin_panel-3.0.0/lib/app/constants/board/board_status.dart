import 'package:acnoo_flutter_admin_panel/app/constants/search_type_enum.dart';

enum BoardStatus implements SearchTypeEnum {
  PUBLISH('출시'),
  NOT_PUBLISH('출시 안됨'),
  ;

  @override
  final String value;
  const BoardStatus(this.value);
}