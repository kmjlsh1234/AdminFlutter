import 'package:acnoo_flutter_admin_panel/app/constants/search_type_enum.dart';

enum LoginType implements SearchTypeEnum {
 EMAIL('이메일'),
 MOBILE('모바일'),
 SOCIAL('소셜'),
 ID_PASS('아이디 & 패스워드'),
 GUEST('게스트'),
 ;

 @override
 final String value;
 const LoginType(this.value);
}