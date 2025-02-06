import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/common/count_vo.dart';
import '../../../models/user/user_detail.dart';
import '../../../models/user/user_mod_param.dart';
import '../../../models/user/user_profile.dart';
import '../../../models/user/user_search_param.dart';
import '../../app_config/app_config.dart';

part 'user_manage_client.g.dart';

@RestApi(baseUrl: AppConfig.baseUrl)
abstract class UserManageClient {

  factory UserManageClient(Dio dio, {String baseUrl}) = _UserManageClient;

  @POST("/admin/v1/users/list")
  Future<List<UserProfile>> getUserList(@Body() UserSearchParam userSearchParam);

  @POST("/admin/v1/users/list/count")
  Future<CountVo> getUserListCount(@Body() UserSearchParam userSearchParam);

  @GET("/admin/v1/users/{userId}")
  Future<UserDetail> getUser(@Path('userId') int userId);

  @PUT("/admin/v1/users/{userId}")
  Future<UserProfile> modUser(@Path('userId') int userId, @Body() UserModParam userModParam);
}