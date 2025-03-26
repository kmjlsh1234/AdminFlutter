import 'package:acnoo_flutter_admin_panel/app/constants/search_type_enum.dart';

enum UserStatus implements SearchTypeEnum {
  NORMAL('정상'),
  LOGOUT('로그 아웃'),
  STOP('이용 정지'),
  BAN('강제 탈퇴'),
  TRY_EXIT('탈퇴 진행'),
  EXIT('탈퇴'),
  ;

  @override
  final String value;
  const UserStatus(this.value);
}