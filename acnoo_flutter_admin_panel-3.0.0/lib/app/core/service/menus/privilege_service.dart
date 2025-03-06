import 'package:acnoo_flutter_admin_panel/app/models/common/count_vo.dart';
import 'package:acnoo_flutter_admin_panel/app/models/menus/privilege/privilege_mod_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/menus/privilege/privilege_search_param.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/menus/privilege/privilege.dart';
import '../../../models/menus/privilege/privilege_add_param.dart';
import '../../../models/menus/privilege/privilege_menu.dart';
import '../../repository/menus/privilege_repository.dart';
import '../../utils/dio_factory.dart';

class PrivilegeService{
  late PrivilegeRepository repository = PrivilegeRepository(DioFactory.createDio());

  //권한 목록 조회
  Future<List<Privilege>> getPrivilegeList(PrivilegeSearchParam privilegeSearchParam) async {
    return await repository.getPrivilegeList(privilegeSearchParam);
  }

  //권한 목록 갯수 조회
  Future<int> getPrivilegeListCount(PrivilegeSearchParam privilegeSearchParam) async {
    CountVo countVo = await repository.getPrivilegeListCount(privilegeSearchParam);
    return countVo.count;
  }

  //권한 - 메뉴 리스트 조회(정렬됨)
  Future<List<PrivilegeMenu>> getPrivilegeSortMenuList() async {
    return await repository.getPrivilegeSortMenuList();
  }

  //권한 - 메뉴 외 리스트 조회 (버튼이나 특수 권한등 메뉴에 묶여있지 않은 권한만 따로 조회)
  Future<List<Privilege>> getPrivilegeNotMenuList() async {
    return await repository.getPrivilegeNotMenuList();
  }

  //권한 추가
  Future<Privilege> addPrivilege(PrivilegeAddParam privilegeAddParam) async {
    return await repository.addPrivilege(privilegeAddParam);
  }

  //권한 수정
  Future<Privilege> modPrivilege(int privilegeId, PrivilegeModParam privilegeModParam) async {
    return await repository.modPrivilege(privilegeId, privilegeModParam);
  }

  //권한 삭제
  Future<bool> delPrivilege(int privilegeId) async {
    HttpResponse res = await repository.delPrivilege(privilegeId);
    return res.response.statusCode == 204;
  }
}