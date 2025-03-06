import 'package:acnoo_flutter_admin_panel/app/constants/search_type_enum.dart';

enum DropOutUserSearchType implements SearchTypeEnum{
  EMAIL('이메일'),
  MOBILE('모바일'),
  ;

  @override
  final String value;
  const DropOutUserSearchType(this.value);
}