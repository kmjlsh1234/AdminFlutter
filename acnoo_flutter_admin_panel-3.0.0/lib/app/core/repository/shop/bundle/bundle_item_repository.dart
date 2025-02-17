import 'package:acnoo_flutter_admin_panel/app/models/shop/bundle/bundle_item/bundle_item_detail.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../models/shop/bundle/bundle_item/bundle_item_mod_param.dart';
import '../../../app_config/server_config.dart';

part 'bundle_item_repository.g.dart';

@RestApi(baseUrl: ServerConfig.baseUrl)
abstract class BundleItemRepository {

  factory BundleItemRepository(Dio dio, {String baseUrl}) = _BundleItemRepository;

  //번들에 매핑된 아이템 리스트 조회
  @GET('/admin/v1/bundles/{bundleId}/items')
  Future<List<BundleItemDetail>> getBundleItemList(@Path() int bundleId);

  //번들 아이템 매핑 변경
  @PUT('/admin/v1/bundles/{bundleId}/items')
  Future<HttpResponse> modBundleItem(@Path() int bundleId, @Body() BundleItemModParam bundleItemModParam);
}
