
import 'package:acnoo_flutter_admin_panel/app/models/user/user_mod_status_param.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/common/count_vo.dart';
import '../../../models/user/user_detail.dart';
import '../../../models/user/user_profile.dart';
import '../../../models/user/user_search_param.dart';
import '../../repository/user/user_manage_repository.dart';
import '../../utils/dio_factory.dart';

class UserManageService{
  late UserManageRepository repository = UserManageRepository(DioFactory.createDio());

  //유저 리스트 조회
  Future<List<UserProfile>> getUserList(UserSearchParam userSearchParam) async {
    return await repository.getUserList(userSearchParam);
  }

  //유저 리스트 갯수
  Future<int> getUserListCount(UserSearchParam userSearchParam) async {
    CountVo countVo = await repository.getUserListCount(userSearchParam);
    return countVo.count;
  }

  //유저 단일 조회(detail)
  Future<UserDetail> getUser(int userId) async{
    return await repository.getUser(userId);
  }

  //유저 상태 변경
  Future<bool> modUserStatus(int userId, UserModStatusParam userModStatusParam) async {
    HttpResponse res = await repository.modUserStatus(userId, userModStatusParam);
    return res.response.statusCode == 200;
  }
}