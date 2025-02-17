import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../models/common/count_vo.dart';
import '../../../../models/shop/item/item.dart';
import '../../../../models/shop/item/item_add_param.dart';
import '../../../../models/shop/item/item_search_param.dart';
import '../../../app_config/app_config.dart';

part 'item_client.g.dart';

@RestApi(baseUrl: AppConfig.baseUrl)
abstract class ItemClient {
  factory ItemClient(Dio dio, {String baseUrl}) = _ItemClient;

  @GET('/admin/v1/items/{itemId}')
  Future<Item> getItem(@Path() int itemId);

  @POST('/admin/v1/items/list')
  Future<List<Item>> getItemList(@Body() ItemSearchParam itemSearchParam);

  @POST('/admin/v1/items/list/count')
  Future<CountVo> getItemListCount(@Body() ItemSearchParam itemSearchParam);

  @POST('/admin/v1/items')
  Future<Item> addItem(@Body() ItemAddParam itemAddParam);


}