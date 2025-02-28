import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../models/shop/bundle/bundle_currency/bundle_currency_mod_param.dart';
import '../../../../models/shop/bundle/bundle_currency/bundle_currency_simple.dart';
import '../../../app_config/server_config.dart';

part 'bundle_currency_repository.g.dart';

@RestApi(baseUrl: ServerConfig.baseUrl)
abstract class BundleCurrencyRepository {

  factory BundleCurrencyRepository(Dio dio, {String baseUrl}) = _BundleCurrencyRepository;

  //번들 재화 목록 검색
  @GET('/admin/v1/bundles/{bundleId}/currencies')
  Future<List<BundleCurrencySimple>> getBundleCurrencyList(@Path() int bundleId);

  //번들 재화 변경
  @PUT('/admin/v1/bundles/{bundleId}/currencies')
  Future<HttpResponse> modBundleCurrency(@Path() int bundleId, @Body() BundleCurrencyModParam bundleCurrencyModParam);
}