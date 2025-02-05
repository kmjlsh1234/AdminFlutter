import 'package:acnoo_flutter_admin_panel/app/models/admin/admin.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/admin_manage_page/admin_info_nav_item.dart';
import 'package:acnoo_flutter_admin_panel/app/widgets/shadow_container/_shadow_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminInfoTopBarWidget extends StatefulWidget{
  const AdminInfoTopBarWidget({super.key});

  @override
  State<AdminInfoTopBarWidget> createState() => _AdminInfoTopBarState();
}

class _AdminInfoTopBarState extends State<AdminInfoTopBarWidget>{
  String curPath = '/admins/info/1';

  List<AdminInfoNavItem> get navItems {
    return <AdminInfoNavItem>[
      AdminInfoNavItem(title: 'profile', navigationPath: '/admins/info'),
      AdminInfoNavItem(title: 'log', navigationPath: '/admins/log'),
      AdminInfoNavItem(title: 'currency', navigationPath: '/admins/currency'),
      AdminInfoNavItem(title: 'currency Record', navigationPath: '/admins/currency/record'),
      AdminInfoNavItem(title: 'extra', navigationPath: '/admins/extra'),
    ];
  }

  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: 50,
      child: ListView.separated(
        itemCount: 5,
        shrinkWrap: true,
        primary: false,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8),
        itemBuilder: (BuildContext context, int index) {
          final navItem = navItems[index];
          return buildNavTile(
            context,
            navItem: navItem,
            isSelected: () {
              final _currentRoute = GoRouter.of(context)
                  .routerDelegate
                  .currentConfiguration
                  .fullPath;
              if (_currentRoute.contains(navItem.navigationPath)) {
                return true;
              }
            },
            onClick: (path) async {
              setState(() {
                curPath = path;
              });
              GoRouter.of(context).go(path);
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
        const VerticalDivider(
          width: 5,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildNavTile(BuildContext context, {required AdminInfoNavItem navItem, required Function() isSelected, required void Function(String title) onClick}){
    final theme = Theme.of(context);
    final isSelect = isSelected.call() ?? false;
    const _buttonPadding = EdgeInsetsDirectional.symmetric(
      horizontal: 2,
      vertical: 2,
    );
    final _buttonTextStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
    );

    return SizedBox(
      width: 150,
      child: TextButton(
        onPressed: () {
          onClick(navItem.navigationPath);
        },
        style: TextButton.styleFrom(
          backgroundColor: isSelect ? Colors.lightBlueAccent : Colors.white,
          foregroundColor: Colors.blue,
          shadowColor: Colors.transparent,
          padding: _buttonPadding,
          textStyle: _buttonTextStyle,
          elevation: 0,
        ),
        child: Text(navItem.title),
      ),
    );
  }
}