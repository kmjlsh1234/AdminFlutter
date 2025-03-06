import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/currency/currency_service.dart';
import 'package:acnoo_flutter_admin_panel/app/models/currency/diamond_mod_param.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../generated/l10n.dart' as l;
import '../../../../core/error/error_code.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/alert_util.dart';
import '../../../../core/utils/compare_util.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/currency/diamonds.dart';
import '../../../../widgets/textfield_wrapper/_textfield_wrapper.dart';

class UserDiamondModDialog extends StatefulWidget {
  const UserDiamondModDialog({super.key, required this.userId, required this.diamond});
  final int userId;
  final Diamonds diamond;

  @override
  State<UserDiamondModDialog> createState() => _UserDiamondModDialogState();
}

class _UserDiamondModDialogState extends State<UserDiamondModDialog> {
  final TextEditingController freeAmountController = TextEditingController();
  final TextEditingController androidAmountController = TextEditingController();
  final TextEditingController iosAmountController = TextEditingController();
  final TextEditingController paidAmountController = TextEditingController();

  final CurrencyService currencyService = CurrencyService();

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //재화 정보 변경
  Future<void> modDiamond() async {
    try {
      checkModParameter();
      await currencyService.modDiamond(widget.userId, getDiamondModParam());
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

  void checkModParameter(){
    if(freeAmountController.text.isEmpty || androidAmountController.text.isEmpty || iosAmountController.text.isEmpty || paidAmountController.text.isEmpty){
      throw CustomException(ErrorCode.UNKNOWN_ERROR);
    }
  }

  DiamondModParam getDiamondModParam() {
    return DiamondModParam(
        freeAmount: CompareUtil.compareIntValue(widget.diamond.freeAmount, int.tryParse(freeAmountController.text)),
        androidAmount: CompareUtil.compareIntValue(widget.diamond.androidAmount, int.tryParse(androidAmountController.text)),
        iosAmount: CompareUtil.compareIntValue(widget.diamond.iosAmount, int.tryParse(iosAmountController.text)),
        paidAmount: CompareUtil.compareIntValue(widget.diamond.paidAmount, int.tryParse(paidAmountController.text)),
    );
  }

  @override
  void initState() {
    super.initState();
    freeAmountController.text = widget.diamond.freeAmount.toString();
    androidAmountController.text = widget.diamond.androidAmount.toString();
    iosAmountController.text = widget.diamond.iosAmount.toString();
    paidAmountController.text = widget.diamond.paidAmount.toString();
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
                    onPressed: () => GoRouter.of(context).pop(false),
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

                    //FREE AMOUNT
                    TextFieldLabelWrapper(
                      labelText: lang.freeAmount,
                      inputField: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: freeAmountController,
                        decoration: InputDecoration(hintText: lang.hintCount),
                        validator: (value) => value?.isEmpty ?? true ? lang.invalidCount : null,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                      ),
                    ),

                    const SizedBox(height: 20),

                    //ANDROID AMOUNT
                    TextFieldLabelWrapper(
                      labelText: lang.androidAmount,
                      inputField: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: androidAmountController,
                        decoration: InputDecoration(hintText: lang.hintCount),
                        validator: (value) => value?.isEmpty ?? true ? lang.invalidCount : null,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                      ),
                    ),

                    const SizedBox(height: 20),

                    //IOS AMOUNT
                    TextFieldLabelWrapper(
                      labelText: lang.iosAmount,
                      inputField: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: iosAmountController,
                        decoration: InputDecoration(hintText: lang.hintCount),
                        validator: (value) => value?.isEmpty ?? true ? lang.invalidCount : null,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                      ),
                    ),

                    const SizedBox(height: 20),

                    //PAID AMOUNT
                    TextFieldLabelWrapper(
                      labelText: lang.paidAmount,
                      inputField: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: paidAmountController,
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
                            onPressed: () => modDiamond(),
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