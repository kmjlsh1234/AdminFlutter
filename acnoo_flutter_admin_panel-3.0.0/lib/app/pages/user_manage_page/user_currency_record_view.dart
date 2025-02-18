// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/pages/user_manage_page/widget/chip_record_widget.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/user_manage_page/widget/nav_bar/currency_nav_tab_bar.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/user_manage_page/widget/nav_bar/user_nav_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../../generated/l10n.dart' as l;
import '../../core/constants/shop/item/currency_type.dart';
import '../../core/constants/user/user_menu.dart';
import '../../widgets/widgets.dart';
import 'widget/coin_record_widget.dart';
import 'widget/diamond_record_widget.dart';

class UserCurrencyRecordView extends StatefulWidget {
  const UserCurrencyRecordView({super.key, required this.userId});
  final int userId;

  @override
  State<UserCurrencyRecordView> createState() => _UserCurrencyRecordViewState();
}

class _UserCurrencyRecordViewState extends State<UserCurrencyRecordView> {
  UserMenu currentMenu = UserMenu.currencyRecord;
  CurrencyType currentCurrency = CurrencyType.chip;


  void selectCurrency(String value){
    CurrencyType currencyType = CurrencyType.values.firstWhere(
          (type) => type.value == value,
      orElse: () => CurrencyType.chip,
    );
    setState(() => currentCurrency = currencyType);
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final lang = l.S.of(context);
    final double padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 16,
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: EdgeInsets.all(padding),
            child: ShadowContainer(
              contentPadding: EdgeInsets.zero,
              customHeader: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: UserNavTabBar(selectMenu: currentMenu, userId: widget.userId),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 0.3,
                    height: 0,
                    color: theme.colorScheme.outline,
                  )
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 50),
                  ShadowContainer(
                    customHeader: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CurrencyNavTabBar(onTabSelected: selectCurrency, selectCurrency: currentCurrency),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 0.3,
                          height: 0,
                          color: theme.colorScheme.outline,
                        )
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsetsDirectional.all(16),
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          selectWidget(constraints),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ),
          );
        },
      ),
    );
  }

  Widget selectWidget(BoxConstraints constraints){
    switch(currentCurrency){
      case CurrencyType.chip:
        return ChipRecordWidget(userId: widget.userId, constraints: constraints);
      case CurrencyType.diamond:
        return DiamondRecordWidget(userId: widget.userId, constraints: constraints);
      case CurrencyType.coin:
        return CoinRecordWidget(userId: widget.userId, constraints: constraints);
      case CurrencyType.free:
        return ChipRecordWidget(userId: widget.userId, constraints: constraints);
      case CurrencyType.event:
        return ChipRecordWidget(userId: widget.userId, constraints: constraints);
    }
  }
}
