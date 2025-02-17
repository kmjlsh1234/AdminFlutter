import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/admin/admin.dart';
import '../../../models/admin/admin_join_param.dart';
import '../../../models/admin/login_view_model.dart';
import '../../app_config/server_config.dart';

part 'admin_repository.g.dart';

@RestApi(baseUrl: ServerConfig.baseUrl)
abstract class AdminRepository{
  factory AdminRepository(Dio dio, {String baseUrl}) = _AdminRepository;

  //로그인
  @POST('/admin/login')
  Future<HttpResponse<Admin>> login(@Body() LoginViewModel loginViewModel);

  //회원가입
  @POST('/admin/v1/join')
  Future<HttpResponse> join(@Body() AdminJoinParam adminJoinParam);

  //로그아웃
  @DELETE('/admin/logout')
  Future<HttpResponse> logout();

  @GET('/admin/v1/admins/self')
  Future<Admin> getAdmin();
}