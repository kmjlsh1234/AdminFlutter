import 'package:acnoo_flutter_admin_panel/app/models/menus/menu/menu_search_param.dart';
import 'package:retrofit/dio.dart';

import '../../../models/common/count_vo.dart';
import '../../../models/menus/menu/menu.dart';
import '../../../models/menus/menu/menu_add_param.dart';
import '../../../models/menus/menu/menu_mod_param.dart';
import '../../repository/menus/menu_repository.dart';
import '../../utils/dio_factory.dart';

class MenuService{
  late MenuRepository repository = MenuRepository(DioFactory.createDio());

  //메뉴 목록 조회
  Future<List<Menu>> getMenuList(MenuSearchParam menuSearchParam) async {
    return await repository.getMenuList(menuSearchParam);
  }

  Future<int> getMenuListCount(MenuSearchParam menuSearchParam) async {
    CountVo countVo = await repository.getMenuListCount(menuSearchParam);
    return countVo.count;
  }

  // 메뉴 리스트 계층 기준 정렬
  Future<List<Menu>> getMenuListSort() async {
    return await repository.getMenuListSort();
  }

  // 메뉴 추가
  Future<Menu> addMenu(MenuAddParam menuAddParam) async {
    return await repository.addMenu(menuAddParam);
  }

  // 메뉴 변경
  Future<Menu> modMenu(int menuId, MenuModParam menuModParam) async {
    return await repository.modMenu(menuId, menuModParam);
  }

  // 메뉴 삭제
  Future<bool> delMenu(int menuId) async {
    HttpResponse res = await repository.delMenu(menuId);
    return res.response.statusCode == 204;
  }
}