import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/common/count_vo.dart';
import '../../../models/user/user_detail.dart';
import '../../../models/user/user_mod_status_param.dart';
import '../../../models/user/user_profile.dart';
import '../../../models/user/user_search_param.dart';
import '../../app_config/server_config.dart';

part 'user_manage_repository.g.dart';

@RestApi(baseUrl: ServerConfig.baseUrl)
abstract class UserManageRepository {

  factory UserManageRepository(Dio dio, {String baseUrl}) = _UserManageRepository;

  @POST("/admin/v1/users/list")
  Future<List<UserProfile>> getUserList(@Body() UserSearchParam userSearchParam);

  @POST("/admin/v1/users/list/count")
  Future<CountVo> getUserListCount(@Body() UserSearchParam userSearchParam);

  @GET("/admin/v1/users/{userId}")
  Future<UserDetail> getUser(@Path('userId') int userId);

  @PUT("/admin/v1/users/{userId}/status")
  Future<HttpResponse> modUserStatus(@Path('userId') int userId, @Body() UserModStatusParam userModStatusParam);
}