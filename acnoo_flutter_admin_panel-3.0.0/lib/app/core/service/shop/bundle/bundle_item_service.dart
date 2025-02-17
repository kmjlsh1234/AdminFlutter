import 'package:acnoo_flutter_admin_panel/app/models/shop/bundle/bundle_item/bundle_item_detail.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../models/shop/bundle/bundle_item/bundle_item_mod_param.dart';
import '../../../repository/shop/bundle/bundle_item_repository.dart';
import '../../../utils/dio_factory.dart';

class BundleItemService{
  late BundleItemRepository repository = BundleItemRepository(DioFactory.createDio());

  //번들에 매핑된 아이템 리스트 조회
  Future<List<BundleItemDetail>> getBundleItemList(int bundleId) async {
    return await repository.getBundleItemList(bundleId);
  }

  //번들 아이템 매핑 변경
  Future<bool> modBundleItem(int bundleId, BundleItemModParam bundleItemModParam) async {
    HttpResponse res = await repository.modBundleItem(bundleId, bundleItemModParam);
    return res.response.statusCode == 200;
  }
}