import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../app_config/server_config.dart';

part 'jwt_repository.g.dart';

@RestApi(baseUrl: ServerConfig.baseUrl)
abstract class JwtRepository{
  factory JwtRepository(Dio dio, {String baseUrl}) = _JwtRepository;

  @POST('/admin/token/check')
  Future<HttpResponse> tokenCheck();
}