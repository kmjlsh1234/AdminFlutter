// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/pages/shell_route_wrapper/components/sidebar/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../providers/menu/menu_provider.dart';
import '../../../../widgets/widgets.dart';

class CustomSideBarWidget extends StatefulWidget {
  const CustomSideBarWidget({
    super.key,
    required this.rootScaffoldKey,
    this.iconOnly = false,
  });

  final GlobalKey<ScaffoldState> rootScaffoldKey;
  final bool iconOnly;

  @override
  State<CustomSideBarWidget> createState() => _CustomSideBarWidgetState();
}

class _CustomSideBarWidgetState extends State<CustomSideBarWidget> {

  late MenuProvider menuProvider;

  @override
  void initState() {
    super.initState();
    menuProvider = Provider.of<MenuProvider>(context, listen: false);
    if(menuProvider.menus.isEmpty){
      menuProvider.fetchMenus();
    }
  }

  @override
  Widget build(BuildContext context) {
    menuProvider = context.watch<MenuProvider>();

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 16),
              child: CompanyHeaderWidget(
                showIconOnly: widget.iconOnly,
                showBottomBorder: true,
                onTap: () {
                  widget.rootScaffoldKey.currentState?.closeDrawer();
                  context.go('/admins/admin-list');
                },
              ),
            ),

            Expanded(
              child: SidebarMenuWidget(
                menus: menuProvider.menus,
                iconOnly: widget.iconOnly,
              ),
            ),
          ],
        ),
      ),
    );
  }
}