// 🐦 Flutter imports:
import 'dart:ui';

import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/currency/currency_service.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/user_manage_page/widget/popup/user_currency_mod_popup.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../core/theme/_app_colors.dart';

class UserCurrencyWidget extends StatefulWidget {
  const UserCurrencyWidget({
    super.key,
    required this.padding,
    required this.theme,
    required this.textTheme,
    required this.userId,
    required this.lang
  });

  final int userId;
  final double padding;
  final ThemeData theme;
  final TextTheme textTheme;
  final l.S lang;

  @override
  State<UserCurrencyWidget> createState() => _UserCurrencyWidgetState();
}

class _UserCurrencyWidgetState extends State<UserCurrencyWidget> {
  bool isLoading = true;

  late int chip;
  late int coin;
  late int diamond;
  final CurrencyService currencyService = CurrencyService();

  Future<void> getCurrency(BuildContext context) async {
    setState(() => isLoading = true);
    try{
      chip = await currencyService.getChip(widget.userId);
      coin = await currencyService.getCoin(widget.userId);
      diamond = await currencyService.getDiamond(widget.userId);
    } catch (e){
      ErrorHandler.handleError(e, context);
    }
    setState(() => isLoading = false);
  }

  void showFormDialog(BuildContext context, String currencyType, int count) async {
    bool isCurrencyMod = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: UserCurrencyModDialog(userId: widget.userId, currencyType: currencyType, count: count)
        );
      },
    );

    if(isCurrencyMod){
      getCurrency(context);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrency(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(widget.padding),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
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
                          buildProfileDetailRow(widget.lang.chip, chip),
                          buildDivider(),
                          buildProfileDetailRow(widget.lang.coin, coin),
                          buildDivider(),
                          buildProfileDetailRow(widget.lang.diamond, diamond),
                        ],
                      ),
                    ),
        ),
      ],
    );
  }

  ElevatedButton modAdminButton(TextTheme textTheme, String currencyType, int count) {
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

  Widget buildProfileDetailRow(String currencyType, int count) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              currencyType,
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
                    count.toString()??"EMPTY",
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

  Widget buildDivider(){
    return Divider(
      color: widget.theme.colorScheme.outline,
      height: 0.0,
    );
  }
}
