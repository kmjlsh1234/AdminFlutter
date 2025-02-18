// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../constants/admin/admin_menu.dart';
import '../../../core/theme/_app_colors.dart';

class AdminNavTabBar extends StatefulWidget {
  const AdminNavTabBar({super.key, required this.onTabSelected});
  final void Function(String) onTabSelected;
  @override
  State<AdminNavTabBar> createState() => _AdminNavTabBarState();
}

class _AdminNavTabBarState extends State<AdminNavTabBar> with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<String> get menues => AdminMenu.values.map((e) => e.value).toList();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: menues.length, vsync: this);
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
        widget.onTabSelected(menues[index]);
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
