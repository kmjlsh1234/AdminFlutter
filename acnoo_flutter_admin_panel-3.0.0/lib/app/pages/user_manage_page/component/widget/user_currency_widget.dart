// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/currency/currency_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:acnoo_flutter_admin_panel/app/models/currency/base_currency_model.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/user_manage_page/component/popup/user_common_currency_mod_popup.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/user_manage_page/component/popup/user_diamond_mod_popup.dart';
import 'package:flutter/material.dart';

import '../../../../constants/shop/item/currency_type.dart';
import '../../../../core/error/error_code.dart';
import '../../../../models/currency/chips.dart';
import '../../../../models/currency/coins.dart';
import '../../../../models/currency/diamonds.dart';

class UserCurrencyWidget extends StatefulWidget {
  const UserCurrencyWidget({super.key, required this.userId, required this.padding, required this.theme, required this.textTheme});
  final int userId;
  final double padding;
  final ThemeData theme;
  final TextTheme textTheme;

  @override
  State<UserCurrencyWidget> createState() => _UserCurrencyWidgetState();
}

class _UserCurrencyWidgetState extends State<UserCurrencyWidget> {
  //Service
  final CurrencyService currencyService = CurrencyService();

  //Future Model
  late Future<Chips> chip;
  late Future<Coins> coin;
  late Future<Diamonds> diamond;

  //칩 조회
  Future<Chips> getChip() async {
    try {
      return await currencyService.getChip(widget.userId);
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  //코인 조회
  Future<Coins> getCoin() async {
    try {
      return await currencyService.getCoin(widget.userId);
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  //다이아 조회
  Future<Diamonds> getDiamond() async {
    try {
      return await currencyService.getDiamond(widget.userId);
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  Future<T> getCurrency<T extends BaseCurrencyModel>(CurrencyType type) async {
    try{
      switch(type){
        case CurrencyType.CHIP:
          return await currencyService.getChip(widget.userId) as T;
        case CurrencyType.COIN:
          return await currencyService.getCoin(widget.userId) as T;
        case CurrencyType.DIAMOND:
          return await currencyService.getDiamond(widget.userId) as T;
        default:
          throw CustomException(ErrorCode.UNKNOWN_ERROR);
      }
    } catch(e){
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    chip = getCurrency(CurrencyType.CHIP);
    coin = getCurrency(CurrencyType.COIN);
    diamond = getCurrency(CurrencyType.DIAMOND);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(widget.padding),
          child: Container(
              decoration: BoxDecoration(
                color: widget.theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: widget.theme.colorScheme.outline,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildCurrencyRow(CurrencyType.CHIP, chip),
                  buildDivider(),
                  buildCurrencyRow(CurrencyType.COIN, coin),
                  buildDivider(),
                  buildCurrencyRow(CurrencyType.DIAMOND, diamond),
                ],
              )
          ),
        )
      ],
    );
  }

  Widget buildCurrencyRow<T extends BaseCurrencyModel>(CurrencyType type, Future<T> model) {
    return FutureBuilderFactory.createFutureBuilder(
        future: model,
        onSuccess: (context, model) {
          return Padding(
            padding: EdgeInsets.all(widget.padding),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(type.value),
                ),
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      Text(':'),
                      const SizedBox(width: 8.0),
                      Flexible(
                        child: Text(model.amount.toString()),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showModCurrencyDialog(type, model);
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  Widget buildDivider() {
    return Divider(
      color: widget.theme.colorScheme.outline,
      height: 0.0,
    );
  }

  void showModCurrencyDialog<T extends BaseCurrencyModel>(CurrencyType type, T model) async {
    bool? isSuccess = await showDialog(
      context: context,
      builder: (BuildContext context) {
        if(type == CurrencyType.DIAMOND){
          return UserDiamondModDialog(userId: widget.userId, diamond: model as Diamonds);
        }
        return UserCommonCurrencyModDialog(userId: widget.userId, type: type, amount: model.amount);
      },
    );

    if (isSuccess != null && isSuccess) {
      setState(() {
        switch(type){
          case CurrencyType.CHIP:
            chip = getCurrency(type);
            break;
          case CurrencyType.COIN:
            coin = getCurrency(type);
            break;
          case CurrencyType.DIAMOND:
            diamond = getCurrency(type);
            break;
          default:
            break;
        }
      });
    }
  }
}
