import 'package:acnoo_flutter_admin_panel/app/models/menus/role_privilege/role_privilege.dart';

import '../../repository/menus/role_privilege_repository.dart';
import '../../utils/dio_factory.dart';

class RolePrivilegeService{
  late RolePrivilegeRepository repository = RolePrivilegeRepository(DioFactory.createDio());

  Future<RolePrivilege> getRolePrivilege(int roleId, int privilegeId) async {
    return await repository.getRolePrivilege(roleId, privilegeId);
  }

  Future<List<RolePrivilege>> getPrivilegeListByRoleId(int roleId) async {
    return await repository.getPrivilegeListByRoleId(roleId);
  }
}