import 'package:acnoo_flutter_admin_panel/app/models/common/paging_param.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/common/count_vo.dart';
import '../../../models/menus/role/role.dart';
import '../../../models/menus/role/role_add_param.dart';
import '../../../models/menus/role/role_mod_param.dart';
import '../../app_config/server_config.dart';

part 'role_repository.g.dart';

@RestApi(baseUrl: ServerConfig.baseUrl)
abstract class RoleRepository{

  factory RoleRepository(Dio dio, {String baseUrl}) = _RoleRepository;

  //역할 단일 조회
  @GET('/admin/v1/roles/{roleId}')
  Future<Role> getRole(@Path() int roleId);

  //역할 관리 리스트 전체 조회
  @GET('/admin/v1/roles/list/all')
  Future<List<Role>> getTotalRoleList();

  // 역할 관리 리스트
  @POST('/admin/v1/roles/list')
  Future<List<Role>> getRoleList(@Body() PagingParam pagingParam);

  // 역할 관리 리스트 갯수
  @POST('/admin/v1/roles/list/count')
  Future<CountVo> getRoleListCount();

  //역할 추가
  @POST('/admin/v1/roles')
  Future<Role> addRole(@Body() RoleAddParam roleAddParam);
  
  //역할 변경
  @PUT('/admin/v1/roles/{roleId}')
  Future<Role> modRole(@Path() int roleId, @Body() RoleModParam roleModParam);

  // 역할 삭제
  @DELETE('/admin/v1/roles/{roleId}')
  Future<HttpResponse> delRole(@Path() int roleId);
}