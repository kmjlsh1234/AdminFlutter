import 'package:acnoo_flutter_admin_panel/app/models/shop/item_unit/item_unit.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../models/common/count_vo.dart';
import '../../../../models/shop/item_unit/item_unit_add_param.dart';
import '../../../../models/shop/item_unit/item_unit_mod_param.dart';
import '../../../../models/shop/item_unit/item_unit_search_param.dart';
import '../../../app_config/app_config.dart';

part 'item_unit_client.g.dart';

@RestApi(baseUrl: AppConfig.baseUrl)
abstract class ItemUnitClient{
  factory ItemUnitClient(Dio dio, {String baseUrl}) = _ItemUnitClient;

  //아이템 유닛 단일 조회
  @GET('/admin/v1/item-units/{unitId}')
  Future<ItemUnit> getItemUnit(@Path() int unitId);

  //아이템 유닛 목록 조회
  @POST('/admin/v1/item-units/list')
  Future<List<ItemUnit>> getItemUnitList(@Body() ItemUnitSearchParam itemUnitSearchParam);

  //아이템 유닛 목록 개수 조회
  @POST('/admin/v1/item-units/list/count')
  Future<CountVo> getItemUnitListCount(@Body() ItemUnitSearchParam itemUnitSearchParam);

  //아이템 유닛 생성
  @POST('/admin/v1/item-units')
  Future<ItemUnit> addItemUnit(@Body() ItemUnitAddParam itemUnitAddParam);

  //아이템 유닛 변경
  @PUT('/admin/v1/item-units/{unitId}')
  Future<ItemUnit> modItemUnit(@Path() int unitId, @Body() ItemUnitModParam itemUnitModParam);

  //아이템 유닛 삭제
  @DELETE('/admin/v1/item-units/{unitId}')
  Future<HttpResponse> delItemUnit(@Path() int unitId);

}