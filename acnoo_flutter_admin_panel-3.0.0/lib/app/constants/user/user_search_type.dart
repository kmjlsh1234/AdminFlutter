import 'package:acnoo_flutter_admin_panel/app/constants/search_type_enum.dart';

enum UserSearchType implements SearchTypeEnum {
  EMAIL('이메일'),
  NICKNAME('닉네임'),
  MOBILE('모바일'),
  ;

  @override
  final String value;
  const UserSearchType(this.value);
}