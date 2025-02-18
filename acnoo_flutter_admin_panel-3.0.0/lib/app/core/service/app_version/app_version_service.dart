import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:acnoo_flutter_admin_panel/app/models/app_version/app_version.dart';
import 'package:acnoo_flutter_admin_panel/app/models/app_version/app_version_add_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/app_version/app_version_mod_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/app_version/app_version_search_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/app_version/latest_app_version.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/common/count_vo.dart';
import '../../error/error_code.dart';
import '../../repository/app_version/app_version_repository.dart';
import '../../utils/dio_factory.dart';

class AppVersionService{
  late AppVersionRepository repository = AppVersionRepository(DioFactory.createDio());

  //현재 출시 된 최신 버전 조회
  Future<LatestAppVersion> getLatestAppVersion() async {
    return await repository.getLatestAppVersion();
  }
  //단일 앱 버전 조회
  Future<AppVersion> getAppVersion(int versionId) async{
    return await repository.getAppVersion(versionId);
  }

  //앱 버전 리스트
  Future<List<AppVersion>> getAppVersionList(AppVersionSearchParam appVersionSearchParam) async{
    return await repository.getAppVersionList(appVersionSearchParam);
  }

  //앱 버전 리스트 갯수 카운트
  Future<int> getAppVersionListCount(AppVersionSearchParam appVersionSearchParam) async{
    CountVo countVo = await repository.getAppVersionListCount(appVersionSearchParam);
    return countVo.count;
  }

  //앱 버전 추가
  Future<AppVersion> addAppVersion(AppVersionAddParam appVersionAddParam) async {
    return await repository.addAppVersion(appVersionAddParam);
  }

  //특정 앱 버전 수정
  Future<AppVersion> modAppVersion(int versionId, AppVersionModParam appVersionModParam) async{
    return await repository.modAppVersion(versionId, appVersionModParam);
  }

  //특정 앱 버전 제거
  Future<bool> delAppVersion(int versionId) async{
    HttpResponse result = await repository.delAppVersion(versionId);
    if(result.response.statusCode == 204){
      return true;
    }
    throw CustomException(ErrorCode.UNKNOWN_ERROR);
  }
}