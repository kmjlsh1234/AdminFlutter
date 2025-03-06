import 'package:acnoo_flutter_admin_panel/app/models/shop/product/product/product.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../models/common/count_vo.dart';
import '../../../../models/shop/product/product/product_add_param.dart';
import '../../../../models/shop/product/product/product_mod_param.dart';
import '../../../../models/shop/product/product/product_mod_status_param.dart';
import '../../../../models/shop/product/product/product_search_param.dart';
import '../../../app_config/server_config.dart';

part 'product_repository.g.dart';

@RestApi(baseUrl: ServerConfig.baseUrl)
abstract class ProductRepository{
  factory ProductRepository(Dio dio, {String baseUrl}) = _ProductRepository;

  //상품 상세 조회(옵션 포함)
  @GET('/admin/v1/products/{productId}')
  Future<Product> getProduct(@Path() int productId);

  //상품 목록 조회(옵션 포함 X)
  @POST('/admin/v1/products/list')
  Future<List<Product>> getProductList(@Body() ProductSearchParam productSearchParam);

  //상품 목록 갯수 조회(옵션 포함 X)
  @POST('/admin/v1/products/list/count')
  Future<CountVo> getProductListCount(@Body() ProductSearchParam productSearchParam);

  //상품 등록(옵션 포함 X)
  @POST('/admin/v1/products')
  Future<Product> addProduct(@Body() ProductAddParam productAddParam);

  //상품 변경
  @PUT('/admin/v1/products/{productId}')
  Future<Product> modProduct(@Path() int productId, @Body() ProductModParam productModParam);

  //상품 상태 변경
  @PUT('/admin/v1/products/{productId}/status')
  Future<HttpResponse> modProductStatus(@Path() int productId, @Body() ProductModStatusParam productModStatusParam);

  //상품 삭제
  @DELETE('/admin/v1/products/{productId}')
  Future<HttpResponse> delProduct(@Path() int productId);

}