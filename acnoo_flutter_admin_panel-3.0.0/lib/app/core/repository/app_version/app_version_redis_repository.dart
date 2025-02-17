import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../app_config/server_config.dart';

part 'app_version_redis_repository.g.dart';

@RestApi(baseUrl: ServerConfig.baseUrl)
abstract class AppVersionRedisRepository {
  factory AppVersionRedisRepository(Dio dio, {String baseUrl}) = _AppVersionRedisRepository;
  
  //REDIS 캐시 삭제
  @DELETE('/admin/v1/versions/cache')
  Future<HttpResponse> delAppVersionCache();
}