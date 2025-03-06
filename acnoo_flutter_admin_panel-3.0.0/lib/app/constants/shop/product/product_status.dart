import 'package:acnoo_flutter_admin_panel/app/constants/search_type_enum.dart';

enum ProductStatus implements SearchTypeEnum{
  NONE('선택 안함'),
  READY('준비 중'),
  ON_SALE('판매 중'),
  STOP_SELLING('판매 중지'),
  REMOVED('제거 됨'),
  ;

  @override
  final String value;
  const ProductStatus(this.value);
}