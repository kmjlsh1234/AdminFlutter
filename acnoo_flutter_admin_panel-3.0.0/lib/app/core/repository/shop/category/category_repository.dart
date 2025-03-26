import 'package:acnoo_flutter_admin_panel/app/models/common/paging_param.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../models/common/count_vo.dart';
import '../../../../models/shop/category/category.dart';
import '../../../../models/shop/category/category_add_param.dart';
import '../../../../models/shop/category/category_mod_param.dart';
import '../../../app_config/server_config.dart';

part 'category_repository.g.dart';

@RestApi(baseUrl: ServerConfig.baseUrl)
abstract class CategoryRepository {
  factory CategoryRepository(Dio dio, {String baseUrl}) = _CategoryRepository;

  //카테고리 단일 조회
  @GET('/admin/v1/categories/{categoryId}')
  Future<Category> getCategory(@Path() int categoryId);

  //카테고리 리스트 조회
  @POST('/admin/v1/categories/list')
  Future<List<Category>> getCategoryList(@Body() PagingParam pagingParam);

  //카테고리 갯수 조회
  @POST('/admin/v1/categories/list/count')
  Future<CountVo> getUserListCount();

  //카테고리 추가
  @POST('/admin/v1/categories')
  Future<Category> addCategory(@Body() CategoryAddParam categoryAddParam);

  //카테고리 변경
  @PUT('/admin/v1/categories/{categoryId}')
  Future<Category> modCategory(@Path() int categoryId, @Body() CategoryModParam categoryModParam);

  //카테고리 삭제
  @DELETE('/admin/v1/categories/{categoryId}')
  Future<HttpResponse> delCategory(@Path() int categoryId);
}