// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../../core/constants/user/user_menu.dart';
import '../../../../core/theme/_app_colors.dart';

class UserNavTabBar extends StatefulWidget {
  const UserNavTabBar({super.key, required this.userId, required this.selectMenu});
  final int userId;
  final UserMenu selectMenu;

  @override
  State<UserNavTabBar> createState() => _UserNavTabBarState();
}

class _UserNavTabBarState extends State<UserNavTabBar> with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<String> get menues => UserMenu.values.map((e) => e.value).toList();


  void selectMenu(String value){
    UserMenu menu = UserMenu.values.firstWhere(
          (menu) => menu.value == value,
      orElse: () => UserMenu.profile,
    );

    switch(menu){
      case UserMenu.profile:
        GoRouter.of(context).go('/users/profile/${widget.userId}');
        break;
      case UserMenu.currency:
        GoRouter.of(context).go('/users/currency/${widget.userId}');
        break;
      case UserMenu.currencyRecord:
        GoRouter.of(context).go('/users/currency/record/${widget.userId}');
        break;
      case UserMenu.log:
        GoRouter.of(context).go('/users/log/${widget.userId}');
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: menues.length, vsync: this, initialIndex: menues.indexOf(widget.selectMenu.value));
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 16,
    );

    return TabBar(
      indicatorPadding: EdgeInsets.zero,
      splashBorderRadius: BorderRadius.circular(12),
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      indicatorSize: TabBarIndicatorSize.tab,
      controller: tabController,
      indicatorColor: AcnooAppColors.kPrimary600,
      indicatorWeight: 2.0,
      dividerColor: Colors.transparent,
      unselectedLabelColor: theme.colorScheme.onTertiary,
      onTap: (index) => setState(() {
        selectMenu(menues[index]);
      }),
      tabs: menues
          .map(
            (e) => Tab(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: _padding / 2,
                ),
                child: Text(e),
              ),
            ),
          )
          .toList(),
    );
  }
}
