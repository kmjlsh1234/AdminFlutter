import 'package:acnoo_flutter_admin_panel/app/core/repository/shop/bundle/bundle_currency_repository.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/bundle/bundle_currency/bundle_currency_mod_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/bundle/bundle_currency/bundle_currency_simple.dart';
import 'package:retrofit/retrofit.dart';

import '../../../utils/dio_factory.dart';

class BundleCurrencyService {
  late BundleCurrencyRepository repository = BundleCurrencyRepository(DioFactory.createDio());

  //번들 재화 목록 조회
  Future<List<BundleCurrencySimple>> getBundleCurrencyList(int bundleId) async {
    return await repository.getBundleCurrencyList(bundleId);
  }

  //번들 재화 변경
  Future<bool> modBundleCurrency(int bundleId, BundleCurrencyModParam bundleCurrencyModParam) async {
    HttpResponse res = await repository.modBundleCurrency(bundleId, bundleCurrencyModParam);
    return res.response.statusCode == 200;
  }
}