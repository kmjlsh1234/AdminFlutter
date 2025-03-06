import 'package:acnoo_flutter_admin_panel/app/constants/search_type_enum.dart';

enum MenuVisibility implements SearchTypeEnum {
  VISIBLE('표시'),
  INVISIBLE('미 표시'),
  ;

  @override
  final String value;
  const MenuVisibility(this.value);
}