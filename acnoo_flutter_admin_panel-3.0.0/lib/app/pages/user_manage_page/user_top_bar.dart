import 'package:acnoo_flutter_admin_panel/app/pages/user_manage_page/user_info_nav_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserTopBar extends StatefulWidget {
  const UserTopBar({super.key, required this.userId});
  final int userId;
  @override
  State<UserTopBar> createState() => _UserTopBarState();
}

class _UserTopBarState extends State<UserTopBar> {

  List<UserInfoNavItem> get navItems {
    return <UserInfoNavItem>[
      UserInfoNavItem(title: 'profile', navigationPath: '/users/info/${widget.userId}'),
      UserInfoNavItem(title: 'currency', navigationPath: '/users/currency/${widget.userId}'),
      UserInfoNavItem(title: 'currency Record', navigationPath: '/users/currency/record/${widget.userId}'),
      UserInfoNavItem(title: 'log', navigationPath: '/users/log'),
      UserInfoNavItem(title: 'extra', navigationPath: '/users/extra'),
    ];
  }

  @override
  Widget build(BuildContext context) {
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

  Widget buildNavTile(BuildContext context, {required UserInfoNavItem navItem, required Function() isSelected, required void Function(String title) onClick}){
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