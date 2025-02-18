import 'package:retrofit/retrofit.dart';

import '../../../../models/common/count_vo.dart';
import '../../../../models/shop/item_unit/item_unit.dart';
import '../../../../models/shop/item_unit/item_unit_add_param.dart';
import '../../../../models/shop/item_unit/item_unit_mod_param.dart';
import '../../../../models/shop/item_unit/item_unit_search_param.dart';
import '../../../repository/shop/item_unit/item_unit_repository.dart';
import '../../../utils/dio_factory.dart';

class ItemUnitService{
  late ItemUnitRepository repository = ItemUnitRepository(DioFactory.createDio());

  //아이템 유닛 단일 조회
  Future<ItemUnit> getItemUnit(int unitId) async {
    return await repository.getItemUnit(unitId);
  }

  //아이템 유닛 목록 조회
  Future<List<ItemUnit>> getItemUnitList(ItemUnitSearchParam itemUnitSearchParam) async{
    return await repository.getItemUnitList(itemUnitSearchParam);
  }

  //아이템 유닛 목록 개수 조회
  Future<int> getItemUnitListCount(ItemUnitSearchParam itemUnitSearchParam) async {
    CountVo countVo = await repository.getItemUnitListCount(itemUnitSearchParam);
    return countVo.count;

  }

  //아이템 유닛 생성
  Future<ItemUnit> addItemUnit(ItemUnitAddParam itemUnitAddParam) async {
    return await repository.addItemUnit(itemUnitAddParam);
  }

  //아이템 유닛 변경
  Future<ItemUnit> modItemUnit(int unitId, ItemUnitModParam itemUnitModParam) async {
    return await repository.modItemUnit(unitId, itemUnitModParam);
  }

  //아이템 유닛 삭제
  Future<bool> delItemUnit(int unitId) async {
    HttpResponse res = await repository.delItemUnit(unitId);
    return res.response.statusCode == 204;
  }
}