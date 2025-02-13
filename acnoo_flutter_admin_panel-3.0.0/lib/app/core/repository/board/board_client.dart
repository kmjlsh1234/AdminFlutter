import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/board/board.dart';
import '../../../models/board/board_add_param.dart';
import '../../../models/board/board_search_param.dart';
import '../../../models/common/count_vo.dart';
import '../../app_config/app_config.dart';

part 'board_client.g.dart';

@RestApi(baseUrl: AppConfig.baseUrl)
abstract class BoardClient{
  factory BoardClient(Dio dio, {String baseUrl}) = _BoardClient;

  @GET('/admin/v1/boards/{boardId}')
  Future<Board> getBoard(@Path() int boardId);

  @POST('/admin/v1/boards')
  Future<Board> addBoard(@Body() BoardAddParam boardAddParam);

  @POST("/admin/v1/boards/list")
  Future<List<Board>> getBoardList(@Body() BoardSearchParam boardSearchParam);

  @POST("/admin/v1/boards/list/count")
  Future<CountVo> getBoardListCount(@Body() BoardSearchParam boardSearchParam);
}