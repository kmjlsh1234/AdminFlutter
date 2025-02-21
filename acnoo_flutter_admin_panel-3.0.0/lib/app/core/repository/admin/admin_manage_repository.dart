import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/admin/admin.dart';
import '../../../models/admin/admin_add_param.dart';
import '../../../models/admin/admin_mod_param.dart';
import '../../../models/admin/admin_mod_status_param.dart';
import '../../../models/admin/admin_search_param.dart';
import '../../../models/common/count_vo.dart';
import '../../app_config/server_config.dart';

part 'admin_manage_repository.g.dart';

@RestApi(baseUrl: ServerConfig.baseUrl)
abstract class AdminManageRepository {

  factory AdminManageRepository(Dio dio, {String baseUrl}) = _AdminManageRepository;

  //ADMIN 리스트 조회
  @POST("/admin/v1/admins/list")
  Future<List<Admin>> getAdminList(@Body() AdminSearchParam adminSearchParam);

  //ADMIN 리스트 갯수
  @POST("/admin/v1/admins/list/count")
  Future<CountVo> getAdminListCount(@Body() AdminSearchParam adminSearchParam);

  //ADMIN 추가
  @POST("/admin/v1/admins")
  Future<Admin> addAdmin(@Body() AdminAddParam adminAddParam);

  //ADMIN 정보 수정
  @PUT("/admin/v1/admins/{adminId}")
  Future<Admin> modAdmin(@Path() int adminId, @Body() AdminModParam adminModParam);

  //ADMIN 상태 변경
  @PUT("/admin/v1/admins/{adminId}/status")
  Future<HttpResponse> modAdminStatus(@Path() int adminId, @Body() AdminModStatusParam adminModStatusParam);

  //ADMIN 조회
  @GET("/admin/v1/admins/{adminId}")
  Future<Admin> getAdmin(@Path() int adminId);
}