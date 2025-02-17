
import 'package:acnoo_flutter_admin_panel/app/models/shop/product/product_option/product_option.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/product/product_option/product_option_add_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/product/product_option/product_option_mod_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/product/product_option/product_option_simple.dart';
import 'package:retrofit/retrofit.dart';

import '../../../repository/shop/product/product_option_repository.dart';
import '../../../utils/dio_factory.dart';

class ProductOptionService{
  late ProductOptionRepository repository = ProductOptionRepository(DioFactory.createDio());

  //상품 옵션 단일 조회
  Future<ProductOption> getProductOption(int productId, int optionId) async{
    return await repository.getProductOption(productId, optionId);
  }

  //상품 옵션 리스트 조회
  Future<List<ProductOptionSimple>> getProductOptionList(int productId) async {
    return await repository.getProductOptionList(productId);
  }

  //상품 옵션 일괄 등록
  Future<bool> addProductOptions(int productId, ProductOptionAddParam productOptionAddParam) async {
    HttpResponse res = await repository.addProductOptions(productId, productOptionAddParam);
    return res.response.statusCode == 200;
  }

  //상품 옵션 변경
  Future<bool> modProductOptions(int productId, ProductOptionModParam productOptionModParam) async{
    HttpResponse res = await repository.modProductOptions(productId, productOptionModParam);
    return res.response.statusCode == 200;
  }

  //상품 옵션 일괄 삭제
  Future<bool> delProductOptions(int productId) async {
    HttpResponse res = await repository.delProductOptions(productId);
    return res.response.statusCode == 204;
  }

}