import 'package:acnoo_flutter_admin_panel/app/models/menus/role_privilege/role_privilege.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../app_config/server_config.dart';

part 'role_privilege_repository.g.dart';

@RestApi(baseUrl: ServerConfig.baseUrl)
abstract class RolePrivilegeRepository{

  factory RolePrivilegeRepository(Dio dio, {String baseUrl}) = _RolePrivilegeRepository;

  @GET('/admin/v1/roles/{roleId}/privileges')
  Future<List<RolePrivilege>> getPrivilegeListByRoleId(@Path() int roleId);

  @GET('/admin/v1/roles/{roleId}/privileges/{privilegeId}')
  Future<RolePrivilege> getRolePrivilege(@Path() int roleId, @Path() int privilegeId);
}