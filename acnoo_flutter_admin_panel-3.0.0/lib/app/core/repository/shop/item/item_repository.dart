import 'package:acnoo_flutter_admin_panel/app/models/shop/item/item_mod_param.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../models/common/count_vo.dart';
import '../../../../models/shop/item/item.dart';
import '../../../../models/shop/item/item_add_param.dart';
import '../../../../models/shop/item/item_mod_status_param.dart';
import '../../../../models/shop/item/item_search_param.dart';
import '../../../app_config/server_config.dart';

part 'item_repository.g.dart';

@RestApi(baseUrl: ServerConfig.baseUrl)
abstract class ItemRepository {
  factory ItemRepository(Dio dio, {String baseUrl}) = _ItemRepository;

  @GET('/admin/v1/items/{itemId}')
  Future<Item> getItem(@Path() int itemId);

  @POST('/admin/v1/items/list')
  Future<List<Item>> getItemList(@Body() ItemSearchParam itemSearchParam);

  @POST('/admin/v1/items/list/count')
  Future<CountVo> getItemListCount(@Body() ItemSearchParam itemSearchParam);

  @POST('/admin/v1/items')
  Future<Item> addItem(@Body() ItemAddParam itemAddParam);

  @PUT('/admin/v1/items/{itemId}')
  Future<Item> modItem(@Path() int itemId, @Body() ItemModParam itemModParam);

  @PUT('/admin/v1/items/{itemId}/status')
  Future<HttpResponse> modItemStatus(@Path() int itemId, @Body() ItemModStatusParam itemModStatusParam);
  
  @DELETE('/admin/v1/items/{itemId}')
  Future<HttpResponse> delItem(@Path() int itemId);
}