import 'package:acnoo_flutter_admin_panel/app/models/shop/bundle/bundle/bundle_mod_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/bundle/bundle/bundle_mod_status_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/bundle/bundle/bundle_search_param.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../models/common/count_vo.dart';
import '../../../../models/shop/bundle/bundle/bundle.dart';
import '../../../../models/shop/bundle/bundle/bundle_add_param.dart';
import '../../../repository/shop/bundle/bundle_repository.dart';
import '../../../utils/dio_factory.dart';

class BundleService{
  late BundleRepository repository = BundleRepository(DioFactory.createDio());

  //번들 단일 조회
  Future<Bundle> getBundle(int bundleId) async {
    return await repository.getBundle(bundleId);
  }

  //번들 목록 조회
  Future<List<Bundle>> getBundleList(BundleSearchParam bundleSearchParam) async {
    return await repository.getBundleList(bundleSearchParam);
  }

  //번들 목록 갯수 조회
  Future<int> getBundleListCount(BundleSearchParam bundleSearchParam) async {
    CountVo countVo = await repository.getBundleListCount(bundleSearchParam);
    return countVo.count;
  }

  //번들 추가
  Future<Bundle> addBundle(BundleAddParam bundleAddParam) async {
    return await repository.addBundle(bundleAddParam);
  }

  //번들 상태 변경
  Future<bool> modBundleStatus(int bundleId, BundleModStatusParam bundleModStatusParam) async {
    HttpResponse res = await repository.modBundleStatus(bundleId, bundleModStatusParam);
    return res.response.statusCode == 200;
  }

  //번들 정보 변경
  Future<Bundle> modBundle(int bundleId, BundleModParam bundleModParam) async {
    return await repository.modBundle(bundleId, bundleModParam);
  }

  //번들 삭제
  Future<bool> delBundle(int bundleId) async {
    HttpResponse res = await repository.delBundle(bundleId);
    return res.response.statusCode == 204;
  }
}