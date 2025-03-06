// 🐦 Flutter imports:
// 📦 Package imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/shop/product/product_option_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/product/product_option/product_option_mod_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/product/product_option/product_option_simple.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../../../generated/l10n.dart' as l;
import '../../../../constants/shop/product/product_option_type.dart';
import '../../../../core/error/error_code.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/alert_util.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/shop/product/product_option/product_option_model.dart';
import '../../../../widgets/shadow_container/_shadow_container.dart';
import '../../../../widgets/textfield_wrapper/_textfield_wrapper.dart';
import '../../../common_widget/custom_button.dart';

class ProductOptionWidget extends StatefulWidget {
  const ProductOptionWidget({super.key, required this.productId});
  final int productId;

  @override
  State<ProductOptionWidget> createState() => _ProductOptionWidgetState();
}

class _ProductOptionWidgetState extends State<ProductOptionWidget> {

  //State Manage
  bool isModState = false;

  //Service
  final ProductOptionService productOptionService = ProductOptionService();

  //Future Model
  late Future<List<ProductOptionModel>> optionList;

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //상품 옵션 리스트 조회
  Future<List<ProductOptionModel>> getProductOptionList() async {
    try {
      List<ProductOptionSimple> list = await productOptionService.getProductOptionList(widget.productId);
      return list.map((option) => ProductOptionModel(
        nameController: TextEditingController(text: option.name),
        quantityController: TextEditingController(text: option.quantity.toString()),
        type: option.type,
      )).toList();
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  //상품 옵션 변경
  Future<void> modProductOption() async {
    try{
      List<ProductOptionModel> list = await optionList;
      List<ProductOptionSimple> productOptions = [];
      for(ProductOptionModel model in list){
        checkModOptionParameter(model);
        productOptions.add(
            ProductOptionSimple(
            name: model.nameController.text,
            type: model.type,
            quantity: int.parse(model.quantityController.text)
            )
        );
      }
      ProductOptionModParam productOptionModParam = ProductOptionModParam(productOptions);
      await productOptionService.modProductOptions(widget.productId, productOptionModParam);
      AlertUtil.successDialog(
          context: context,
          message: lang.modProductOption,
          buttonText: lang.confirm,
          onPressed: () {
            setState(() {
              isModState = false;
              GoRouter.of(context).pop();
              optionList = getProductOptionList();
            });
          }
      );
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  //상품 옵션 변경 파라미터 검사
  void checkModOptionParameter(ProductOptionModel model){
    if(model.nameController.text.isEmpty){
      throw CustomException(ErrorCode.PRODUCT_ORIGIN_PRICE_EMPTY);
    }

    if(model.quantityController.text.isEmpty){
      throw CustomException(ErrorCode.PRODUCT_ORIGIN_PRICE_EMPTY);
    }
  }

  void disposeOptionList() async {
    final list = await optionList;
    for (ProductOptionModel model in list) {
      model.nameController.dispose();
      model.quantityController.dispose();
    }
  }

  @override
  void initState() {
    super.initState();
    optionList = getProductOptionList();
  }

  @override
  void dispose() {
    disposeOptionList();
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

    return Column(
      children: [
        FutureBuilderFactory.createFutureBuilder(
            future: optionList,
            onSuccess: (context, optionList) {
              return ShadowContainer(
                  headerText: lang.productOption,
                  child: ResponsiveGridRow(children: [
                    ...optionList.map((option) {
                      return ResponsiveGridCol(
                        lg: _lg,
                        md: _md,
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  //color: _theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: theme.colorScheme.primary),

                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //NAME
                                    TextFieldLabelWrapper(
                                      labelText: lang.name,
                                      inputField: TextFormField(
                                        controller: option.nameController,
                                        enabled: isModState,
                                        decoration: InputDecoration(
                                          hintText: lang.hintName,
                                          filled: !isModState,
                                          fillColor: theme.colorScheme.tertiaryContainer,
                                        ),
                                        validator: (value) => value?.isEmpty ?? true ? lang.invalidName : null,
                                        autovalidateMode: AutovalidateMode.onUnfocus,
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    //TYPE
                                    TextFieldLabelWrapper(
                                      labelText: lang.type,
                                      inputField: DropdownButtonFormField<ProductOptionType>(
                                        dropdownColor: theme.colorScheme.primaryContainer,
                                        value: option.type,
                                        hint: Text(
                                          lang.type,
                                          style: textTheme.bodySmall,
                                        ),
                                        decoration: InputDecoration(
                                          filled: !isModState,
                                          fillColor: isModState
                                              ? theme.colorScheme.tertiaryContainer
                                              : Colors.grey.shade300,
                                        ),
                                        items: ProductOptionType.values.map((type) {
                                          return DropdownMenuItem<ProductOptionType>(
                                            enabled: isModState,
                                            value: type,
                                            child: Text(type.value),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            if (isModState) {
                                              option.type = value!;
                                            }
                                          });
                                        },
                                        validator: (value) =>
                                        value == null ? lang.pleaseSelectAPosition : null,
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    //QUANTITY
                                    TextFieldLabelWrapper(
                                      labelText: lang.quantity,
                                      inputField: TextFormField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        controller: option.quantityController,
                                        enabled: isModState,
                                        decoration: InputDecoration(
                                          hintText: lang.hintQuantity,
                                          filled: !isModState,
                                          fillColor: theme.colorScheme.tertiaryContainer,
                                        ),
                                        validator: (value) => value?.isEmpty ?? true ? lang.invalidQuantity : null,
                                        autovalidateMode: AutovalidateMode.onUnfocus,
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
                                          if(isModState){
                                            option.nameController.dispose();
                                            option.quantityController.dispose();
                                            optionList.remove(option);
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
                                    buildProductOptionField(optionList);
                                  }
                                });
                              },
                              label: Text(
                                lang.addNewProductOption,
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
                  ]));
            }
        ),

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
                        label: lang.modProductOption,
                        onPressed: () => {
                          if (isModState)
                            {
                              modProductOption(),
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
                              optionList = getProductOptionList();
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
  }

  void buildProductOptionField(List<ProductOptionModel> optionList) {
    TextEditingController optionNameController = TextEditingController();
    TextEditingController optionQuantityController = TextEditingController();
    ProductOptionType type = ProductOptionType.DIAMOND;
    optionList.add(
        ProductOptionModel(
            nameController: optionNameController,
            quantityController: optionQuantityController,
            type: type
        )
    );
  }
}
