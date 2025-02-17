import 'package:acnoo_flutter_admin_panel/app/models/app_version/app_version.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/app_version/app_version_add_param.dart';
import '../../../models/app_version/app_version_mod_param.dart';
import '../../../models/app_version/app_version_search_param.dart';
import '../../../models/app_version/latest_app_version.dart';
import '../../../models/common/count_vo.dart';
import '../../app_config/server_config.dart';

part 'app_version_repository.g.dart';

@RestApi(baseUrl: ServerConfig.baseUrl)
abstract class AppVersionRepository{
  factory AppVersionRepository(Dio dio, {String baseUrl}) = _AppVersionRepository;

  //현재 출시 된 최신 버전 조회
  @GET('/admin/v1/versions/latest')
  Future<LatestAppVersion> getLatestAppVersion();

  //단일 앱 버전 조회
  @GET('/admin/v1/versions/{versionId}')
  Future<AppVersion> getAppVersion(@Path() int versionId);

  //앱 버전 리스트
  @POST('/admin/v1/versions/list')
  Future<List<AppVersion>> getAppVersionList(@Body() AppVersionSearchParam appVersionSearchParam);

  //앱 버전 리스트 갯수 카운트
  @POST('/admin/v1/versions/list/count')
  Future<CountVo> getAppVersionListCount(@Body() AppVersionSearchParam appVersionSearchParam);

  //앱 버전 추가
  @POST('/admin/v1/versions')
  Future<AppVersion> addAppVersion(@Body() AppVersionAddParam appVersionAddParam);

  //특정 앱 버전 수정
  @PUT('/admin/v1/versions/{versionId}')
  Future<AppVersion> modAppVersion(@Path() int versionId, @Body() AppVersionModParam appVersionModParam);

  //특정 앱 버전 제거
  @DELETE('/admin/v1/versions/{versionId}')
  Future<HttpResponse> delAppVersion(@Path() int versionId);
}