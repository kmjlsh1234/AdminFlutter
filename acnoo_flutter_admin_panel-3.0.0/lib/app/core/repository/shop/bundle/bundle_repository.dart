import 'package:acnoo_flutter_admin_panel/app/models/shop/bundle/bundle/bundle_mod_status_param.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../models/common/count_vo.dart';
import '../../../../models/shop/bundle/bundle/bundle.dart';
import '../../../../models/shop/bundle/bundle/bundle_add_param.dart';
import '../../../../models/shop/bundle/bundle/bundle_mod_param.dart';
import '../../../../models/shop/bundle/bundle/bundle_search_param.dart';
import '../../../app_config/server_config.dart';

part 'bundle_repository.g.dart';

@RestApi(baseUrl: ServerConfig.baseUrl)
abstract class BundleRepository{
  factory BundleRepository(Dio dio, {String baseUrl}) = _BundleRepository;

  //번들 단일 조회
  @GET('/admin/v1/bundles/{bundleId}')
  Future<Bundle> getBundle(@Path() int bundleId);

  //번들 목록 조회
  @POST('/admin/v1/bundles/list')
  Future<List<Bundle>> getBundleList(@Body() BundleSearchParam bundleSearchParam);

  //번들 목록 갯수 조회
  @POST('/admin/v1/bundles/list/count')
  Future<CountVo> getBundleListCount(@Body() BundleSearchParam bundleSearchParam);

  //번들 추가
  @POST('/admin/v1/bundles')
  Future<Bundle> addBundle(@Body() BundleAddParam bundleAddParam);

  //번들 상태 변경
  @PUT('/admin/v1/bundles/{bundleId}/status')
  Future<HttpResponse> modBundleStatus(@Path() int bundleId, @Body() BundleModStatusParam bundleModStatusParam);

  //번들 정보 변경
  @PUT('/admin/v1/bundles/{bundleId}')
  Future<Bundle> modBundle(@Path() int bundleId, @Body() BundleModParam bundleModParam);

  //번들 삭제
  @DELETE('/admin/v1/bundles/{bundleId}')
  Future<HttpResponse> delBundle(@Path() int bundleId);
}