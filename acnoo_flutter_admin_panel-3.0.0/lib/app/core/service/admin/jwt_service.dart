import 'package:retrofit/retrofit.dart';

import '../../repository/admin/jwt_client.dart';
import '../../utils/dio_factory.dart';

class JwtService{
  late JwtClient client = JwtClient(DioFactory.createDio());

  // auth token 이 동작하는지 확인
  Future<bool> tokenCheck() async {
    HttpResponse res = await client.tokenCheck();
    if(res.response.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }
}