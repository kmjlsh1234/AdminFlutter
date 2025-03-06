import 'package:acnoo_flutter_admin_panel/app/constants/search_type_enum.dart';

enum BundleStatus implements SearchTypeEnum{
  READY('준비 중'),
  ON_SALE('판매 중'),
  STOP_SELLING('판매 중지'),
  REMOVED('제거 됨'),
  ;

  @override
  final String value;
  const BundleStatus(this.value);
}