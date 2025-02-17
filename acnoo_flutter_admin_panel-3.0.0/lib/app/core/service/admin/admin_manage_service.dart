import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:acnoo_flutter_admin_panel/app/models/admin/admin_mod_status_param.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/admin/admin.dart';
import '../../../models/admin/admin_add_param.dart';
import '../../../models/admin/admin_mod_param.dart';
import '../../../models/admin/admin_search_param.dart';
import '../../../models/common/count_vo.dart';
import '../../error/error_code.dart';
import '../../repository/admin/admin_manage_client.dart';
import '../../utils/dio_factory.dart';

class AdminManageService{
  late AdminManageClient client = AdminManageClient(DioFactory.createDio());
  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  final mobileRegex = RegExp(r'^(010-?\d{4}-?\d{4})$');

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
    checkAddParameter(adminAddParam);
    return await client.addAdmin(adminAddParam);
  }

  //관리자 정보 수정
  Future<Admin> modAdmin(int adminId, AdminModParam adminModParam) async{
    return await client.modAdmin(adminId, adminModParam);
  }

  //관리자 상태 변경
  Future<bool> modAdminStatus(int adminId, AdminModStatusParam adminModStatusParam) async {
    HttpResponse res = await client.modAdminStatus(adminId, adminModStatusParam);
    return res.response.statusCode == 204;
  }

  //관리자 조회
  Future<Admin> getAdmin(int adminId) async{
    return await client.getAdmin(adminId);
  }

  //관리자 추가 파라미터 검사
  void checkAddParameter(AdminAddParam adminAddParam) {
    //TODO : email 형식 검사
    if(!emailRegex.hasMatch(adminAddParam.email)){
      throw CustomException(ErrorCode.EMAIL_REGEX_VALIDATION);
    }

    //TODO : password 길이가 2~14 사이인지, 특수문자 들어가는지 검사


    //TODO : 전화번호 형식 검사
    if(!mobileRegex.hasMatch(adminAddParam.mobile)){
      throw CustomException(ErrorCode.MOBILE_REGEX_VALIDATION);
    }
  }
}