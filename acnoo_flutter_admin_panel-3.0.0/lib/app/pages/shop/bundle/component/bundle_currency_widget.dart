// 🐦 Flutter imports:
// 📦 Package imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/shop/bundle/bundle_currency_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/bundle/bundle_currency/bundle_currency_mod_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/bundle/bundle_currency/bundle_currency_simple.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../../../generated/l10n.dart' as l;
import '../../../../constants/shop/item/currency_type.dart';
import '../../../../core/error/error_code.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/shop/bundle/bundle_currency/bundle_currency_model.dart';
import '../../../../widgets/shadow_container/_shadow_container.dart';
import '../../../../widgets/textfield_wrapper/_textfield_wrapper.dart';
import '../../../common_widget/custom_button.dart';

class BundleCurrencyWidget extends StatefulWidget {
  const BundleCurrencyWidget({super.key, required this.bundleId});

  final int bundleId;

  @override
  State<BundleCurrencyWidget> createState() => _BundleCurrencyWidgetState();
}

class _BundleCurrencyWidgetState extends State<BundleCurrencyWidget> {

  //State Manage
  bool isModState = false;

  //Service
  final BundleCurrencyService bundleCurrencyService = BundleCurrencyService();

  //Future Model
  late Future<List<BundleCurrencyModel>> bundleCurrencyList;

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //번들 재화 목록 조회
  Future<List<BundleCurrencyModel>> getBundleCurrencyList() async {
    try {
      List<BundleCurrencySimple> list = await bundleCurrencyService.getBundleCurrencyList(widget.bundleId);
      return list
          .map((currency) => BundleCurrencyModel(
              currencyType: currency.currencyType,
              countController: TextEditingController(text: currency.count.toString())))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  //번들 재화 변경
  Future<void> modBundleCurrency() async {
    try {
      List<BundleCurrencyModel> list = await bundleCurrencyList;
      List<BundleCurrencySimple> bundleCurrencies = [];
      for (BundleCurrencyModel model in list) {
        checkModParameter(model);
        bundleCurrencies.add(BundleCurrencySimple(
            currencyType: model.currencyType,
            count: int.parse(model.countController.text)));
      }
      BundleCurrencyModParam bundleCurrencyModParam =
          BundleCurrencyModParam(bundleCurrencies: bundleCurrencies);
      await bundleCurrencyService.modBundleCurrency(widget.bundleId, bundleCurrencyModParam);
      showSuccessDialog(context);
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  void checkModParameter(BundleCurrencyModel model) {
    if (model.countController.text.isEmpty) {
      throw CustomException(ErrorCode.PRODUCT_ORIGIN_PRICE_EMPTY);
    }
  }

  @override
  void initState() {
    super.initState();
    bundleCurrencyList = getBundleCurrencyList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    const _lg = 4;
    const _md = 6;
    lang = l.S.of(context);
    theme = Theme.of(context);
    textTheme = Theme.of(context).textTheme;
    final _sizeInfo = SizeConfig.getSizeInfo(context);

    return FutureBuilderFactory.createFutureBuilder(
        future: bundleCurrencyList,
        onSuccess: (context, bundleCurrencyList){
          return Column(
            children: [
              ShadowContainer(
              headerText: lang.bundleCurrency,
              child: ResponsiveGridRow(children: [
                ...bundleCurrencyList.map((currency) {
                  return ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsetsDirectional.all(
                          _sizeInfo.innerSpacing / 2),
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              //color: _theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: theme.colorScheme.primary),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                TextFieldLabelWrapper(
                                  labelText: lang.type,
                                  inputField:
                                  DropdownButtonFormField<CurrencyType>(
                                    dropdownColor:
                                    theme.colorScheme.primaryContainer,
                                    value: currency.currencyType,
                                    hint: Text(
                                      lang.type,
                                      style: textTheme.bodySmall,
                                    ),
                                    items: CurrencyType.values.map((type) {
                                      return DropdownMenuItem<CurrencyType>(
                                        enabled: isModState,
                                        value: type,
                                        child: Text(type.value),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        if (isModState) {
                                          currency.currencyType = value!;
                                        }
                                      });
                                    },
                                    validator: (value) => value == null
                                        ? lang.pleaseSelectAPosition
                                        : null,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                TextFieldLabelWrapper(
                                  labelText: lang.amount,
                                  inputField: TextFormField(
                                    controller: currency.countController,
                                    enabled: isModState,
                                    decoration: InputDecoration(
                                      hintText: lang.quantity,
                                      filled: !isModState,
                                      fillColor: theme
                                          .colorScheme.tertiaryContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: isModState,
                            child: Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    if (isModState) {
                                      currency.countController.dispose();
                                      bundleCurrencyList.remove(currency);
                                    }
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
                ResponsiveGridCol(
                  lg: _lg,
                  md: _md,
                  child: Padding(
                      padding: EdgeInsetsDirectional.all(
                          _sizeInfo.innerSpacing / 2),
                      child: Visibility(
                        visible: isModState,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding:
                            const EdgeInsets.fromLTRB(14, 8, 14, 8),
                          ),
                          onPressed: () {
                            setState(() {
                              if (isModState) {
                                buildBundleCurrencyField(bundleCurrencyList);
                              }
                            });
                          },
                          label: Text(
                            lang.addNewBundleCurrency,
                            maxLines: 1,
                            style: textTheme.bodySmall?.copyWith(
                              color: AcnooAppColors.kWhiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          iconAlignment: IconAlignment.start,
                          icon: const Icon(
                            Icons.add_circle_outline_outlined,
                            color: AcnooAppColors.kWhiteColor,
                            size: 20.0,
                          ),
                        ),
                      )),
                )
              ])),
              SizedBox(height: _sizeInfo.innerSpacing),
              Padding(
                padding: EdgeInsets.all(_sizeInfo.innerSpacing),
                child: Align(
                  alignment: Alignment.centerLeft, // 버튼을 가운데 정렬
                  child: SizedBox(
                      width: 1000,
                      child: Row(
                        children: [
                          CustomButton(
                              textTheme: textTheme,
                              label: lang.modBundleItem,
                              onPressed: () => {
                                if (isModState)
                                  {
                                    modBundleCurrency(),
                                  }
                                else
                                  {
                                    setState(() {
                                      isModState = true;
                                    }),
                                  }
                              }),
                          const SizedBox(width: 50),
                          Visibility(
                              visible: isModState,
                              child: OutlinedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: _sizeInfo.innerSpacing),
                                    backgroundColor:
                                    theme.colorScheme.primaryContainer,
                                    textStyle: textTheme.bodySmall?.copyWith(
                                        color: AcnooAppColors.kError),
                                    side: const BorderSide(
                                        color: AcnooAppColors.kError)),
                                onPressed: () {
                                  setState(() {
                                    isModState = false;
                                    this.bundleCurrencyList = getBundleCurrencyList();
                                  });
                                },
                                label: Text(
                                  lang.cancel,
                                  style: textTheme.bodySmall?.copyWith(
                                      color: AcnooAppColors.kError),
                                ),
                              ))
                        ],
                      )),
                ),
              ),
            ],
          );
        });
  }

  void buildBundleCurrencyField(List<BundleCurrencyModel> bundleCurrencyList) {
    CurrencyType currencyType = CurrencyType.DIAMOND;
    TextEditingController countController = TextEditingController();
    bundleCurrencyList.add(BundleCurrencyModel(
        currencyType: currencyType, countController: countController));
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: Text('번들 변경 성공'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                isModState = false;
                isModState = false;
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
