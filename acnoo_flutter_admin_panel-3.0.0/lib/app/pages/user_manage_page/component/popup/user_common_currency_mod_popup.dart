import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/currency/currency_service.dart';
import 'package:acnoo_flutter_admin_panel/app/models/currency/base_currency_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../generated/l10n.dart' as l;
import '../../../../constants/shop/item/currency_type.dart';
import '../../../../core/error/error_code.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/alert_util.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/currency/currency_mod_param.dart';
import '../../../../widgets/textfield_wrapper/_textfield_wrapper.dart';

class UserCommonCurrencyModDialog extends StatefulWidget {
  const UserCommonCurrencyModDialog({super.key, required this.userId, required this.type, required this.amount});
  final int userId;
  final CurrencyType type;
  final int amount;


  @override
  State<UserCommonCurrencyModDialog> createState() => _UserCommonCurrencyModDialogState();
}

class _UserCommonCurrencyModDialogState extends State<UserCommonCurrencyModDialog> {


  final TextEditingController currencyController = TextEditingController();
  final CurrencyService currencyService = CurrencyService();

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //재화 정보 변경
  Future<void> modCurrency() async {
    try {
      if(currencyController.text.isEmpty){
        throw CustomException(ErrorCode.UNKNOWN_ERROR);
      }

      if(widget.amount == int.tryParse(currencyController.text)){
        throw CustomException(ErrorCode.UNKNOWN_ERROR);
      }

      CurrencyModParam currencyModParam = CurrencyModParam(amount: int.parse(currencyController.text));
      switch(widget.type){
        case CurrencyType.CHIP:
          await currencyService.modChip(widget.userId, currencyModParam);
          break;
        case CurrencyType.COIN:
          await currencyService.modCoin(widget.userId, currencyModParam);
          break;
        default:
          break;
      }
      AlertUtil.successDialog(
          context: context,
          message: lang.successModUserCurrency,
          buttonText: lang.confirm,
          onPressed: (){
            GoRouter.of(context).pop();
            GoRouter.of(context).pop(true);
          }
      );

    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  @override
  void initState() {
    super.initState();
    currencyController.text = widget.amount.toString();
  }

  @override
  Widget build(BuildContext context) {
    lang = l.S.of(context);
    theme = Theme.of(context);
    textTheme = Theme.of(context).textTheme;
    final _sizeInfo = SizeConfig.getSizeInfo(context);

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///---------------- header section
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(lang.modUserCurrency),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: const Icon(
                      Icons.close,
                      color: AcnooAppColors.kError,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 0.1,
              color: theme.colorScheme.outline,
              height: 0,
            ),

            ///---------------- header section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 606,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///---------------- Text Field section
                    ///
                    TextFieldLabelWrapper(
                      labelText: widget.type.value,
                      inputField: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: currencyController,
                        decoration: InputDecoration(hintText: lang.hintCount),
                        validator: (value) => value?.isEmpty ?? true ? lang.invalidCount : null,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                      ),
                    ),

                    const SizedBox(height: 24),

                    ///---------------- Submit Button section
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: _sizeInfo.innerSpacing),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: _sizeInfo.innerSpacing),
                                backgroundColor:
                                theme.colorScheme.primaryContainer,
                                textStyle: textTheme.bodySmall
                                    ?.copyWith(color: AcnooAppColors.kError),
                                side: const BorderSide(
                                    color: AcnooAppColors.kError)),
                            onPressed: () => GoRouter.of(context).pop(false),
                            label: Text(
                              lang.cancel,
                              style: textTheme.bodySmall?.copyWith(color: AcnooAppColors.kError),
                            ),
                          ),
                          SizedBox(width: _sizeInfo.innerSpacing),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: _sizeInfo.innerSpacing),
                            ),
                            onPressed: () => modCurrency(),
                            //label: const Text('Save'),
                            label: Text(lang.save),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}