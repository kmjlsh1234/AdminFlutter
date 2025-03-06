import 'package:acnoo_flutter_admin_panel/app/models/shop/product/product/product_add_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/product/product/product_mod_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/product/product/product_mod_status_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/product/product/product_search_param.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../models/common/count_vo.dart';
import '../../../../models/shop/product/product/product.dart';
import '../../../repository/shop/product/product_repository.dart';
import '../../../utils/dio_factory.dart';

class ProductService{
  late ProductRepository repository = ProductRepository(DioFactory.createDio());

  //상품 상세 조회(옵션 포함)
  Future<Product> getProduct(int productId) async {
    return await repository.getProduct(productId);
  }

  //상품 목록 조회(옵션 포함 X)
  Future<List<Product>> getProductList(ProductSearchParam productSearchParam) async {
    return await repository.getProductList(productSearchParam);
  }

  //상품 목록 갯수 조회(옵션 포함 X)
  Future<int> getProductListCount(ProductSearchParam productSearchParam) async {
    CountVo countVo = await repository.getProductListCount(productSearchParam);
    return countVo.count;
  }

  //상품 등록(옵션 포함 X)
  Future<Product> addProduct(ProductAddParam productAddParam) async{
    return await repository.addProduct(productAddParam);
  }

  //상품 변경
  Future<Product> modProduct(int productId,ProductModParam productModParam) async{
    return await repository.modProduct(productId, productModParam);
  }

  //상품 상태 변경
  Future<bool> modProductStatus(int productId,ProductModStatusParam productModStatusParam) async{
    HttpResponse res = await repository.modProductStatus(productId, productModStatusParam);
    return res.response.statusCode == 200;
  }

  //상품 삭제
  Future<bool> delProduct(int productId) async {
    HttpResponse res = await repository.delProduct(productId);
    return res.response.statusCode == 204;
  }
}