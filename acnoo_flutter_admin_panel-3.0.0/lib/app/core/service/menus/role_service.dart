

import 'package:acnoo_flutter_admin_panel/app/models/common/paging_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/menus/role/role_add_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/menus/role/role_mod_param.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/common/count_vo.dart';
import '../../../models/menus/role/role.dart';
import '../../repository/menus/role_repository.dart';
import '../../utils/dio_factory.dart';

class RoleService{
  late RoleRepository repository = RoleRepository(DioFactory.createDio());

  // 역할 단일 조회
  Future<Role> getRole(int roleId) async {
    return await repository.getRole(roleId);
  }
  // 역할 전체 조회
  Future<List<Role>> getTotalRoleList() async {
    return await repository.getTotalRoleList();
  }

  // 역할 관리 리스트
  Future<List<Role>> getRoleList(PagingParam pagingParam) async {
    return await repository.getRoleList(pagingParam);
  }

  // 역할 관리 리스트 갯수
  Future<int> getRoleListCount() async {
    CountVo countVo = await repository.getRoleListCount();
    return countVo.count;
  }

  //역할 추가
  Future<Role> addRole(RoleAddParam roleAddParam) async {
    return await repository.addRole(roleAddParam);
  }

  //역할 변경
  Future<Role> modRole(int roleId, RoleModParam roleModParam) async {
    return await repository.modRole(roleId, roleModParam);
  }

  // 역할 삭제
  Future<bool> delRole(int roleId) async {
    HttpResponse res = await repository.delRole(roleId);
    return res.response.statusCode == 204;
  }
}