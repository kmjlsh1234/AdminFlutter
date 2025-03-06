import 'package:acnoo_flutter_admin_panel/app/constants/search_type_enum.dart';

enum MenuSearchType implements SearchTypeEnum{
  NAME('이름'),
  PATH('경로'),
  ;

  @override
  final String value;
  const MenuSearchType(this.value);
}