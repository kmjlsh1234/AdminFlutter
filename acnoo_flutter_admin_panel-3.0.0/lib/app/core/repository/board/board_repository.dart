import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/board/board.dart';
import '../../../models/board/board_add_param.dart';
import '../../../models/board/board_search_param.dart';
import '../../../models/common/count_vo.dart';
import '../../app_config/server_config.dart';

part 'board_repository.g.dart';

@RestApi(baseUrl: ServerConfig.baseUrl)
abstract class BoardRepository{
  factory BoardRepository(Dio dio, {String baseUrl}) = _BoardRepository;

  //게시판 단일 조회
  @GET('/admin/v1/boards/{boardId}')
  Future<Board> getBoard(@Path() int boardId);

  //게시판 추가
  @POST('/admin/v1/boards')
  Future<Board> addBoard(@Body() BoardAddParam boardAddParam);

  //게시판 리스트 조회
  @POST("/admin/v1/boards/list")
  Future<List<Board>> getBoardList(@Body() BoardSearchParam boardSearchParam);

  //게시판 리스트 갯수 조회
  @POST("/admin/v1/boards/list/count")
  Future<CountVo> getBoardListCount(@Body() BoardSearchParam boardSearchParam);
}