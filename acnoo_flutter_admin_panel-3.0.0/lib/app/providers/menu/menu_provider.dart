import 'package:acnoo_flutter_admin_panel/app/core/service/menus/menu_service.dart';
import 'package:flutter/material.dart';
import '../../constants/menus/menu/menu_visibility.dart';
import '../../models/menus/menu/menu.dart';

class MenuProvider extends ChangeNotifier {

  final MenuService menuService = MenuService();

  List<Menu> menus = [];

  void fetchMenus() async {
    List<Menu> list = await menuService.getMenuListSort();
    menus = list.where((menu) => menu.visibility == MenuVisibility.VISIBLE).toList();
    notifyListeners();
  }
}