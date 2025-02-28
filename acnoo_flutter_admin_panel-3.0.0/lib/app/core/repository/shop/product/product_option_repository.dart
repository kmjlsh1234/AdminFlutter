import 'package:acnoo_flutter_admin_panel/app/models/shop/product/product_option/product_option_add_param.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../models/shop/product/product_option/product_option.dart';
import '../../../../models/shop/product/product_option/product_option_mod_param.dart';
import '../../../../models/shop/product/product_option/product_option_simple.dart';
import '../../../app_config/server_config.dart';

part 'product_option_repository.g.dart';

@RestApi(baseUrl: ServerConfig.baseUrl)
abstract class ProductOptionRepository{
  factory ProductOptionRepository(Dio dio, {String baseUrl}) = _ProductOptionRepository;

  //상품 옵션 단일 조회
  @GET('/admin/v1/products/{productId}/options/{optionId}')
  Future<ProductOption> getProductOption(@Path() int productId, @Path() int optionId);

  //상품 옵션 리스트 조회
  @GET('/admin/v1/products/{productId}/options')
  Future<List<ProductOptionSimple>> getProductOptionList(@Path() int productId);

  //상품 옵션 일괄 등록
  @POST('/admin/v1/products/{productId}/options')
  Future<HttpResponse> addProductOptions(@Path() int productId, @Body() ProductOptionAddParam productOptionAddParam);

  //상품 옵션 변경
  @PUT('/admin/v1/products/{productId}/options')
  Future<HttpResponse> modProductOptions(@Path() int productId, @Body() ProductOptionModParam productOptionModParam);

  //상품 옵션 일괄 삭제
  @DELETE('/admin/v1/products/{productId}/options')
  Future<HttpResponse> delProductOptions(@Path() int productId);
}