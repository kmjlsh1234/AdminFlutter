import 'package:acnoo_flutter_admin_panel/app/constants/search_type_enum.dart';

enum BundleSearchType implements SearchTypeEnum{
  NAME('이름'),
  SKU('SKU'),
  ;

  @override
  final String value;
  const BundleSearchType(this.value);
}