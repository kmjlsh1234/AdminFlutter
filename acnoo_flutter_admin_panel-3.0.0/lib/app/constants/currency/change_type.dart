import 'package:acnoo_flutter_admin_panel/app/constants/search_type_enum.dart';

enum ChangeType implements SearchTypeEnum {
  NONE('선택 안함'),
  ADD('입금'),
  USE('인출'),
  ;

  @override
  final String value;
  const ChangeType(this.value);
}