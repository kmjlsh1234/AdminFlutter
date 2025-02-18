import 'dart:html';

import 'package:acnoo_flutter_admin_panel/app/core/repository/admin/admin_repository.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/dio_factory.dart';
import 'package:acnoo_flutter_admin_panel/app/models/admin/login_view_model.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/admin/admin.dart';
import '../../../models/admin/admin_join_param.dart';
import '../../error/custom_exception.dart';
import '../../error/error_code.dart';

class AdminService {
  late AdminRepository repository = AdminRepository(DioFactory.createDio());
  final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",);
  final RegExp mobileRegex = RegExp(r"^01[0-9]\d{7,8}$",);

  //로그인
  Future<Admin> login(LoginViewModel loginViewModel) async {
    HttpResponse<Admin> result = await repository.login(loginViewModel);
    final jwtToken = result.response.headers['authorization']?.first;
    window.localStorage['jwt'] = jwtToken!;
    return result.data;
  }

  //로그아웃
  Future<bool> logout() async {
    HttpResponse result = await repository.logout();
    if(result.response.statusCode == 204){
      window.localStorage.remove('jwt');
      return true;
    }
    return false;
  }

  //회원가입
  Future<bool> join(AdminJoinParam adminJoinParam) async {
    checkJoinParam(adminJoinParam);
    HttpResponse result = await repository.join(adminJoinParam);
    return true;
  }

  //자기 자신 조회
  Future<Admin> getAdmin() async {
    return await repository.getAdmin();
  }

  void checkJoinParam(AdminJoinParam adminJoinParam){
    //이메일 형식 체크
    if(!emailRegex.hasMatch(adminJoinParam.email)){
      throw CustomException(ErrorCode.EMAIL_REGEX_VALIDATION);
    }

    //전화번호 형식 체크
    if(!mobileRegex.hasMatch(adminJoinParam.mobile)){
      throw CustomException(ErrorCode.MOBILE_REGEX_VALIDATION);
    }
  }
}
