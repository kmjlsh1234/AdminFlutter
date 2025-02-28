// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../../constants/shop/item/currency_type.dart';

import '../../../../core/theme/_app_colors.dart';

class CurrencyNavTabBar extends StatefulWidget {
  const CurrencyNavTabBar({super.key, required this.onTabSelected, required this.selectCurrency});
  final void Function(CurrencyType) onTabSelected;
  final CurrencyType selectCurrency;
  @override
  State<CurrencyNavTabBar> createState() => _CurrencyNavTabBarState();
}

class _CurrencyNavTabBarState extends State<CurrencyNavTabBar> with SingleTickerProviderStateMixin {
  late TabController tabController;
  //List<String> get menues => CurrencyType.values.map((e) => e.value).toList();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: CurrencyType.values.length, vsync: this, initialIndex: CurrencyType.values.indexOf(widget.selectCurrency));
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();

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
      onTap: (idx) => setState(() {
        widget.onTabSelected(CurrencyType.values.elementAt(idx));
      }),
      tabs: CurrencyType.values.map(
            (type) => Tab(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: _padding / 2,
                ),
                child: Text(type.value),
              ),
            ),
          )
          .toList(),
    );
  }
}
