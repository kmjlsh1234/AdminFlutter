// 🐦 Flutter imports:
import 'dart:ui';

import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/currency/currency_service.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/user_manage_page/component/popup/user_currency_mod_popup.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../constants/shop/item/currency_type.dart';
import '../../../../core/theme/_app_colors.dart';

class UserCurrencyWidget extends StatefulWidget {
  const UserCurrencyWidget(
      {super.key,
      required this.padding,
      required this.theme,
      required this.textTheme,
      required this.userId,
      required this.lang});

  final int userId;
  final double padding;
  final ThemeData theme;
  final TextTheme textTheme;
  final l.S lang;

  @override
  State<UserCurrencyWidget> createState() => _UserCurrencyWidgetState();
}

class _UserCurrencyWidgetState extends State<UserCurrencyWidget> {

  //Service
  final CurrencyService currencyService = CurrencyService();

  //Future Model
  late Future<int> chip;
  late Future<int> coin;
  late Future<int> diamond;

  //재화 정보 가져오기
  Future<int> getCurrency(CurrencyType currencyType) async {
    try {
      switch (currencyType) {
        case CurrencyType.diamond:
          return await currencyService.getDiamond(widget.userId);
        case CurrencyType.coin:
          return await currencyService.getCoin(widget.userId);
        case CurrencyType.chip:
          return await currencyService.getChip(widget.userId);
        default:
          return await currencyService.getChip(widget.userId);
      }
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    chip = getCurrency(CurrencyType.chip);
    coin = getCurrency(CurrencyType.coin);
    diamond = getCurrency(CurrencyType.diamond);
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
                  buildFutureCurrencyRow(CurrencyType.chip, chip),
                  buildDivider(),
                  buildFutureCurrencyRow(CurrencyType.coin, coin),
                  buildDivider(),
                  buildFutureCurrencyRow(CurrencyType.diamond, diamond),
                ],
              ),
          ),
        ),
      ],
    );
  }

  ElevatedButton modAdminButton(TextTheme textTheme, CurrencyType currencyType, int count) {
    final lang = l.S.of(context);
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: () {
        showFormDialog(context, currencyType, count);
      },
      label: Text(
        lang.edit,
        style: textTheme.bodySmall?.copyWith(
          color: AcnooAppColors.kWhiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildFutureCurrencyRow(CurrencyType currencyType, Future<int> future) {
    return
      FutureBuilder<int>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.all(widget.padding),
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Padding(
            padding: EdgeInsets.all(widget.padding),
            child: Text('Error: ${snapshot.error}', style: widget.textTheme.bodyLarge),
          );
        }

        final count = snapshot.data ?? 0;
        return buildProfileDetailRow(currencyType, count);
      },
    );
  }

  Widget buildProfileDetailRow(CurrencyType currencyType, int count) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              currencyType.value,
              style: widget.textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Text(
                  ':',
                  style: widget.textTheme.bodyMedium,
                ),
                const SizedBox(width: 8.0),
                Flexible(
                  child: Text(
                    count.toString() ?? "EMPTY",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: widget.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: modAdminButton(widget.textTheme, currencyType, count),
          ),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return Divider(
      color: widget.theme.colorScheme.outline,
      height: 0.0,
    );
  }

  void showFormDialog(BuildContext context, CurrencyType currencyType, int count) async {
    bool? isSuccess = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: UserCurrencyModDialog(
                userId: widget.userId,
                currencyType: currencyType.value,
                count: count));
      },
    );

    if (isSuccess != null && isSuccess) {
      setState(() {
        switch(currencyType){
          case CurrencyType.chip:
            chip = getCurrency(CurrencyType.chip);
            break;
          case CurrencyType.diamond:
            diamond = getCurrency(CurrencyType.diamond);
            break;
          case CurrencyType.coin:
            coin = getCurrency(CurrencyType.coin);
            break;
          default:
            break;
        }
      });
    }
  }
}
