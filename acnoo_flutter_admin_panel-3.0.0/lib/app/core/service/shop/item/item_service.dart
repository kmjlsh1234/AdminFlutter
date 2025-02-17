import '../../../../models/common/count_vo.dart';
import '../../../../models/shop/item/item.dart';
import '../../../../models/shop/item/item_add_param.dart';
import '../../../../models/shop/item/item_search_param.dart';
import '../../../repository/shop/item/item_client.dart';
import '../../../utils/dio_factory.dart';

class ItemService{
  late ItemClient client = ItemClient(DioFactory.createDio());

  //아이템 단일 조회
  Future<Item> getItem(int itemId) async {
    return await client.getItem(itemId);
  }

  //아이템 목록 조회
  Future<List<Item>> getItemList(ItemSearchParam itemSearchParam) async{
    return await client.getItemList(itemSearchParam);
  }

  //아이템 목록 개수 조회
  Future<int> getItemListCount(ItemSearchParam itemSearchParam) async {
    CountVo countVo = await client.getItemListCount(itemSearchParam);
    return countVo.count;

  }

  //아이템 생성
  Future<Item> addItem(ItemAddParam itemAddParam) async {
    return await client.addItem(itemAddParam);
  }

}