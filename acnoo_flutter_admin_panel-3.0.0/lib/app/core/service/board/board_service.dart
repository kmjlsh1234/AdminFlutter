import 'package:acnoo_flutter_admin_panel/app/models/board/board_add_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/board/board_search_param.dart';

import '../../../models/board/board.dart';
import '../../../models/common/count_vo.dart';
import '../../repository/board/board_client.dart';
import '../../utils/dio_factory.dart';

class BoardService{
  late BoardClient client = BoardClient(DioFactory.createDio());

  Future<Board> getBoard(int boardId) async{
    return await client.getBoard(boardId);
  }

  //게시판 추가
  Future<Board> addBoard(BoardAddParam boardAddParam) async {
    return await client.addBoard(boardAddParam);
  }

  //게시판 목록 조회
  Future<List<Board>> getBoardList(BoardSearchParam boardSearchParam) async {
    return await client.getBoardList(boardSearchParam);
  }

  //게시판 목록 갯수 조회
  Future<int> getBoardListCount(BoardSearchParam boardSearchParam) async {
    CountVo countVo = await client.getBoardListCount(boardSearchParam);
    return countVo.count;
  }
}