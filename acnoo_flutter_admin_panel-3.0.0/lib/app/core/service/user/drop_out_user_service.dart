import '../../../models/common/count_vo.dart';
import '../../../models/user/drop_out_user.dart';
import '../../../models/user/drop_out_user_search_param.dart';
import '../../repository/user/drop_out_user_repository.dart';
import '../../utils/dio_factory.dart';

class DropOutUserService{
  late DropOutUserRepository repository = DropOutUserRepository(DioFactory.createDio());

  //탈퇴 유저 리스트 조회
  Future<List<DropOutUser>> getDropOutUserList(DropOutUserSearchParam dropOutUserSearchParam) async {
    return await repository.getDropOutUserList(dropOutUserSearchParam);
  }

  //탈퇴 유저 리스트 갯수 카운트
  Future<int> getDropOutUserListCount(DropOutUserSearchParam dropOutUserSearchParam) async {
    CountVo countVo = await repository.getDropOutUserListCount(dropOutUserSearchParam);
    return countVo.count;
  }
}