import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../app_config/app_config.dart';

part 'jwt_client.g.dart';

@RestApi(baseUrl: AppConfig.baseUrl)
abstract class JwtClient{
  factory JwtClient(Dio dio, {String baseUrl}) = _JwtClient;

  //auth token 이 동작하는지 확인
  @POST('/admin/token/check')
  Future<HttpResponse> tokenCheck();
}