import 'package:acnoo_flutter_admin_panel/app/models/user/drop_out_user.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/common/count_vo.dart';
import '../../../models/user/drop_out_user_search_param.dart';
import '../../app_config/server_config.dart';

part 'drop_out_user_repository.g.dart';

@RestApi(baseUrl: ServerConfig.baseUrl)
abstract class DropOutUserRepository{
  factory DropOutUserRepository(Dio dio, {String baseUrl}) = _DropOutUserRepository;

  //탈퇴 유저 리스트 조회
  @POST("/admin/v1/users/leave/list")
  Future<List<DropOutUser>> getDropOutUserList(@Body() DropOutUserSearchParam dropOutUserSearchParam);

  //탈퇴 유저 리스트 갯수 카운트
  @POST("/admin/v1/users/leave/list/count")
  Future<CountVo> getDropOutUserListCount(@Body() DropOutUserSearchParam dropOutUserSearchParam);
}