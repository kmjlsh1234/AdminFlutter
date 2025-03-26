import 'package:acnoo_flutter_admin_panel/app/models/menus/menu/menu_search_param.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/common/count_vo.dart';
import '../../../models/menus/menu/menu.dart';
import '../../../models/menus/menu/menu_add_param.dart';
import '../../../models/menus/menu/menu_mod_param.dart';
import '../../app_config/server_config.dart';

part 'menu_repository.g.dart';

@RestApi(baseUrl: ServerConfig.baseUrl)
abstract class MenuRepository {

  factory MenuRepository(Dio dio, {String baseUrl}) = _MenuRepository;

  //메뉴 목록 조회
  @POST('/admin/v1/menus/list')
  Future<List<Menu>> getMenuList(@Body() MenuSearchParam menuSearchParam);

  //메뉴 목록 갯수 조회
  @POST('/admin/v1/menus/list/count')
  Future<CountVo> getMenuListCount(@Body() MenuSearchParam menuSearchParam);

  // 메뉴 리스트 계층 기준 정렬
  @GET('/admin/v1/menus/sort')
  Future<List<Menu>> getMenuListSort();

  // 메뉴 추가
  @POST('/admin/v1/menus')
  Future<Menu> addMenu(@Body() MenuAddParam menuAddParam);

  // 메뉴 변경
  @PUT('/admin/v1/menus/{menuId}')
  Future<Menu> modMenu(@Path() int menuId, @Body() MenuModParam menuModParam);
  
  // 메뉴 삭제
  @DELETE('/admin/v1/menus/{menuId}')
  Future<HttpResponse> delMenu(@Path() int menuId);
}