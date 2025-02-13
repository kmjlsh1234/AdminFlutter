import 'package:acnoo_flutter_admin_panel/app/models/user/drop_out_user.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/common/count_vo.dart';
import '../../../models/user/drop_out_user_search_param.dart';
import '../../app_config/app_config.dart';

part 'drop_out_user_client.g.dart';

@RestApi(baseUrl: AppConfig.baseUrl)
abstract class DropOutUserClient{
  factory DropOutUserClient(Dio dio, {String baseUrl}) = _DropOutUserClient;

  //탈퇴 유저 리스트 조회
  @POST("/admin/v1/users/leave/list")
  Future<List<DropOutUser>> getDropOutUserList(@Body() DropOutUserSearchParam dropOutUserSearchParam);

  //탈퇴 유저 리스트 갯수 카운트
  @POST("/admin/v1/users/leave/list/count")
  Future<CountVo> getDropOutUserListCount(@Body() DropOutUserSearchParam dropOutUserSearchParam);
}