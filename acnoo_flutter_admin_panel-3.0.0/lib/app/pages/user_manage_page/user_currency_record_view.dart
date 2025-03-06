// 🐦 Flutter imports:

import 'package:acnoo_flutter_admin_panel/app/pages/user_manage_page/component/widget/chip_record_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../constants/shop/item/currency_type.dart';
import '../../constants/user/user_menu.dart';
import '../../core/service/currency/currency_record_service.dart';
import '../../widgets/widgets.dart';
import 'component/nav_bar/currency_nav_tab_bar.dart';
import 'component/nav_bar/user_nav_bar.dart';
import 'component/widget/coin_record_widget.dart';
import 'component/widget/diamond_record_widget.dart';


class UserCurrencyRecordView extends StatefulWidget {
  const UserCurrencyRecordView({super.key, required this.userId});
  final int userId;

  @override
  State<UserCurrencyRecordView> createState() => _UserCurrencyRecordViewState();
}

class _UserCurrencyRecordViewState extends State<UserCurrencyRecordView> {
  UserMenu currentMenu = UserMenu.CURRENCY_RECORD;
  CurrencyType currentCurrency = CurrencyType.CHIP;

  //Service
  final CurrencyRecordService currencyRecordService = CurrencyRecordService();

  void selectCurrency(CurrencyType type){
    CurrencyType currencyType = type;
    setState(() {
      currentCurrency = currencyType;
    });
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
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
                        child: UserNavBar(userMenu: currentMenu, userId: widget.userId),
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
                    child: getContentWidget(),
                  ),
                ],
              )
            ),
          );
        },
      ),
    );
  }

  Widget getContentWidget() {
    switch(currentCurrency){
      case CurrencyType.CHIP:
        return ChipRecordWidget(userId: widget.userId);
      case CurrencyType.COIN:
        return CoinRecordWidget(userId: widget.userId);
      case CurrencyType.DIAMOND:
        return DiamondRecordWidget(userId: widget.userId);
      default:
        return ChipRecordWidget(userId: widget.userId);
    }
  }
}
