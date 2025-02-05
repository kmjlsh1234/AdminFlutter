import '../../../models/admin/admin.dart';
import '../../../models/admin/admin_add_param.dart';
import '../../../models/admin/admin_mod_param.dart';
import '../../../models/admin/admin_search_param.dart';
import '../../../models/common/count_vo.dart';
import '../../repository/admin/admin_manage_client.dart';
import '../../utils/dio_factory.dart';

class AdminManageService{
  late AdminManageClient client = AdminManageClient(DioFactory.createDio());

  //관리자 리스트 조회
  Future<List<Admin>> getAdminList(AdminSearchParam adminSearchParam) async {
    return await client.getAdminList(adminSearchParam);
  }

  //관리자 리스트 갯수
  Future<int> getAdminListCount(AdminSearchParam adminSearchParam) async {
    CountVo countVo = await client.getAdminListCount(adminSearchParam);
    return countVo.count;
  }

  //관리자 추가
  Future<Admin> addAdmin(AdminAddParam adminAddParam) async {
    return await client.addAdmin(adminAddParam);
  }

  //관리자 정보 수정
  Future<Admin> modAdmin(int adminId, AdminModParam adminModParam) async{
    return await client.modAdmin(adminId, adminModParam);
  }

  //관리자 조회
  Future<Admin> getAdmin(int adminId) async{
    return await client.getAdmin(adminId);
  }
}