import 'package:retrofit/retrofit.dart';

import '../../repository/admin/jwt_repository.dart';
import '../../utils/dio_factory.dart';

class JwtService{
  late JwtRepository repository = JwtRepository(DioFactory.createDio());

  // auth token 이 동작하는지 확인
  Future<bool> tokenCheck() async {
    HttpResponse res = await repository.tokenCheck();
    if(res.response.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }
}