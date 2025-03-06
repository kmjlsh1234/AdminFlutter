import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../models/menus/menu/menu.dart';

class SidebarMenuWidget extends StatefulWidget {
  final List<Menu> menus;
  final bool iconOnly;

  const SidebarMenuWidget({
    super.key,
    required this.menus,
    this.iconOnly = false,
  });

  @override
  State<SidebarMenuWidget> createState() => _SidebarMenuWidgetState();
}

class _SidebarMenuWidgetState extends State<SidebarMenuWidget> {
  int? _selectedMenuId;

  @override
  Widget build(BuildContext context) {
    // parentId가 null인 메뉴만 필터링
    final topLevelMenus = widget.menus.where((menu) => menu.parentId == null).toList();

    return ListView(
      shrinkWrap: true,
      children: topLevelMenus.map((menu) {
        return _buildMenuTile(context, menu);
      }).toList(),
    );
  }

  Widget _buildMenuTile(BuildContext context, Menu menu, {String? parentPath}) {
    // 현재 메뉴의 하위 메뉴를 찾기
    final submenus = widget.menus.where((m) => m.parentId == menu.id).toList();

    // 현재 메뉴의 전체 경로 구성
    final fullPath = parentPath != null ? '$parentPath${menu.menuPath}' : menu.menuPath;

    // 현재 메뉴가 선택되었는지 확인
    final isSelected = _selectedMenuId == menu.id;

    // 하위 메뉴가 있는 경우 ExpansionTile 사용
    if (submenus.isNotEmpty) {
      return ExpansionTile(
        leading: SvgPicture.asset(menu.image),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        title: Text(
          menu.menuName,
          style: TextStyle(
            color: isSelected ? Colors.blue : null,
          ),
        ),
        children: submenus.map((submenu) {
          return _buildMenuTile(context, submenu, parentPath: fullPath);
        }).toList(),
      );
    } else {
      return ListTile(
        leading: SvgPicture.asset(menu.image!),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        selected: isSelected,
        selectedTileColor: Colors.blue,

        title: Text(
          menu.menuName,
          style: TextStyle(color: isSelected ? Colors.white : null),
        ),
        onTap: () {
          setState(() {
            _selectedMenuId = menu.id;
          });
          context.go(fullPath);
        },
      );
    }
  }
}