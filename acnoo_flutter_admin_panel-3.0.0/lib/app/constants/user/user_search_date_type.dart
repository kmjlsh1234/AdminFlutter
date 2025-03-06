import 'package:acnoo_flutter_admin_panel/app/constants/search_type_enum.dart';

enum UserSearchDateType implements SearchTypeEnum {
  CREATED_AT('생성 시각'),
  UPDATED_AT('변경 시각'),
  LOGIN_AT('로그인 시각'),
  ;

  @override
  final String value;
  const UserSearchDateType(this.value);
}