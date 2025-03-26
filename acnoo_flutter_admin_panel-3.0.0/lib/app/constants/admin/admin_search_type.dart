import 'package:acnoo_flutter_admin_panel/app/constants/search_type_enum.dart';

enum AdminSearchType implements SearchTypeEnum{
  NAME('이름'),
  EMAIL('이메일'),
  MOBILE('모바일'),
  ;

  @override
  final String value;
  const AdminSearchType(this.value);
}