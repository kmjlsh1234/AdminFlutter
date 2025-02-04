import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/admin/admin.dart';
import '../../../models/admin/admin_add_param.dart';
import '../../../models/admin/admin_mod_param.dart';
import '../../../models/admin/admin_search_param.dart';
import '../../../models/common/count_vo.dart';
import '../../app_config/app_config.dart';
part 'admin_manage_client.g.dart';

@RestApi(baseUrl: AppConfig.baseUrl)
abstract class AdminManageClient {

  factory AdminManageClient(Dio dio, {String baseUrl}) = _AdminManageClient;

  @POST("/admin/v1/admins/list")
  Future<List<Admin>> getAdminList(@Body() AdminSearchParam adminSearchParam);

  @POST("/admin/v1/admins/list/count")
  Future<CountVo> getAdminListCount(@Body() AdminSearchParam adminSearchParam);

  @POST("/admin/v1/admins")
  Future<Admin> addAdmin(@Body() AdminAddParam adminAddParam);

  @PUT("/admin/v1/admins/{adminId}")
  Future<Admin> modAdmin(@Path() int adminId, @Body() AdminModParam adminModParam);

  @GET("/admin/v1/admins/{adminId}")
  Future<Admin> getAdmin(@Path() int adminId);
}