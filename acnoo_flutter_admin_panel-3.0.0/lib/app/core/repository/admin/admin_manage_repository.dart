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

  @POST("/admin/v1/admins/list")
  Future<List<Admin>> getAdminList(@Body() AdminSearchParam adminSearchParam);

  @POST("/admin/v1/admins/list/count")
  Future<CountVo> getAdminListCount(@Body() AdminSearchParam adminSearchParam);

  @POST("/admin/v1/admins")
  Future<Admin> addAdmin(@Body() AdminAddParam adminAddParam);

  @PUT("/admin/v1/admins/{adminId}")
  Future<Admin> modAdmin(@Path() int adminId, @Body() AdminModParam adminModParam);

  @PUT("/admin/v1/admins/{adminId}/status")
  Future<HttpResponse> modAdminStatus(@Path() int adminId, @Body() AdminModStatusParam adminModStatusParam);

  @GET("/admin/v1/admins/{adminId}")
  Future<Admin> getAdmin(@Path() int adminId);
}