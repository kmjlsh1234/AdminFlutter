import 'package:acnoo_flutter_admin_panel/app/models/admin/admin_mod_status_param.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/admin/admin.dart';
import '../../../models/admin/admin_add_param.dart';
import '../../../models/admin/admin_detail.dart';
import '../../../models/admin/admin_mod_param.dart';
import '../../../models/admin/admin_search_param.dart';
import '../../../models/common/count_vo.dart';
import '../../repository/admin/admin_manage_repository.dart';
import '../../utils/dio_factory.dart';

class AdminManageService{
  late AdminManageRepository repository = AdminManageRepository(DioFactory.createDio());
  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  final mobileRegex = RegExp(r'^(010-?\d{4}-?\d{4})$');

  //ADMIN 리스트 조회
  Future<List<Admin>> getAdminList(AdminSearchParam adminSearchParam) async {
    return await repository.getAdminList(adminSearchParam);
  }

  //ADMIN 리스트 갯수
  Future<int> getAdminListCount(AdminSearchParam adminSearchParam) async {
    CountVo countVo = await repository.getAdminListCount(adminSearchParam);
    return countVo.count;
  }

  //ADMIN 추가
  Future<Admin> addAdmin(AdminAddParam adminAddParam) async {
    return await repository.addAdmin(adminAddParam);
  }

  //ADMIN 정보 수정
  Future<Admin> modAdmin(int adminId, AdminModParam adminModParam) async{
    return await repository.modAdmin(adminId, adminModParam);
  }

  //ADMIN 상태 변경
  Future<bool> modAdminStatus(int adminId, AdminModStatusParam adminModStatusParam) async {
    HttpResponse res = await repository.modAdminStatus(adminId, adminModStatusParam);
    return res.response.statusCode == 204;
  }

  //ADMIN 조회
  Future<AdminDetail> getAdmin(int adminId) async {
    return await repository.getAdmin(adminId);
  }
}