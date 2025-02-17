import 'package:retrofit/retrofit.dart';

import '../../repository/app_version/app_version_redis_repository.dart';
import '../../utils/dio_factory.dart';

class AppVersionRedisService{
  late AppVersionRedisRepository repository = AppVersionRedisRepository(DioFactory.createDio());

  Future<bool> delAppVersionCache() async {
    HttpResponse res = await repository.delAppVersionCache();
    return res.response.statusCode == 204;
  }
}