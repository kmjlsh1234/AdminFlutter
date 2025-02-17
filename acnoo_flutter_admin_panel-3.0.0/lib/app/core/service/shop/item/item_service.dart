import 'package:acnoo_flutter_admin_panel/app/models/shop/item/item_mod_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/item/item_mod_status_param.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../models/common/count_vo.dart';
import '../../../../models/shop/item/item.dart';
import '../../../../models/shop/item/item_add_param.dart';
import '../../../../models/shop/item/item_search_param.dart';
import '../../../repository/shop/item/item_repository.dart';
import '../../../utils/dio_factory.dart';

class ItemService{
  late ItemRepository repository = ItemRepository(DioFactory.createDio());

  //아이템 단일 조회
  Future<Item> getItem(int itemId) async {
    return await repository.getItem(itemId);
  }

  //아이템 목록 조회
  Future<List<Item>> getItemList(ItemSearchParam itemSearchParam) async{
    return await repository.getItemList(itemSearchParam);
  }

  //아이템 목록 개수 조회
  Future<int> getItemListCount(ItemSearchParam itemSearchParam) async {
    CountVo countVo = await repository.getItemListCount(itemSearchParam);
    return countVo.count;
  }

  //아이템 생성
  Future<Item> addItem(ItemAddParam itemAddParam) async {
    return await repository.addItem(itemAddParam);
  }

  //아이템 정보 변경
  Future<Item> modItem(int itemId, ItemModParam itemModParam) async {
    return await repository.modItem(itemId, itemModParam);
  }

  //아이템 상태 변경
  Future<bool> modItemStatus(int itemId, ItemModStatusParam itemModStatusParam) async {
    HttpResponse res = await repository.modItemStatus(itemId, itemModStatusParam);
    return res.response.statusCode == 200;
  }

  //아이템 삭제
  Future<bool> delItem(int itemId) async{
    HttpResponse res = await repository.delItem(itemId);
    return res.response.statusCode == 204;
  }
}