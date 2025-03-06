import 'package:acnoo_flutter_admin_panel/app/models/menus/privilege/privilege.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/common/count_vo.dart';
import '../../../models/menus/privilege/privilege_add_param.dart';
import '../../../models/menus/privilege/privilege_menu.dart';
import '../../../models/menus/privilege/privilege_mod_param.dart';
import '../../../models/menus/privilege/privilege_search_param.dart';
import '../../app_config/server_config.dart';

part 'privilege_repository.g.dart';

@RestApi(baseUrl: ServerConfig.baseUrl)
abstract class PrivilegeRepository {

  factory PrivilegeRepository(Dio dio, {String baseUrl}) = _PrivilegeRepository;

  //권한 목록 조회
  @POST('/admin/v1/privileges/list')
  Future<List<Privilege>> getPrivilegeList(@Body() PrivilegeSearchParam privilegeSearchParam);

  //권한 목록 갯수 조회
  @POST('/admin/v1/privileges/list/count')
  Future<CountVo> getPrivilegeListCount(@Body() PrivilegeSearchParam privilegeSearchParam);
  
  //권한 - 메뉴 리스트 조회(정렬됨)
  @GET('/admin/v1/privileges/menus')
  Future<List<PrivilegeMenu>> getPrivilegeSortMenuList();

  //권한 - 메뉴 외 리스트 조회 (버튼이나 특수 권한등 메뉴에 묶여있지 않은 권한만 따로 조회)
  @GET('/admin/v1/privileges/menus/other')
  Future<List<Privilege>> getPrivilegeNotMenuList();
  
  //권한 추가
  @POST('/admin/v1/privileges')
  Future<Privilege> addPrivilege(@Body() PrivilegeAddParam privilegeAddParam);

  //권한 변경
  @PUT('/admin/v1/privileges/{privilegeId}')
  Future<Privilege> modPrivilege(@Path() int privilegeId, @Body() PrivilegeModParam privilegeModParam);
  
  //권한 삭제
  @DELETE('/admin/v1/privileges/{privilegeId}')
  Future<HttpResponse> delPrivilege(@Path() int privilegeId);
}