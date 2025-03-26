// 🐦 Flutter imports:
// 📦 Package imports:
import 'dart:ui';

import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/bundle/bundle_item/bundle_item_detail.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/bundle/bundle_item/bundle_item_mod_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/bundle/bundle_item/bundle_item_simple.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/shop/bundle/component/bundle_item_info_popup.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/shop/bundle/component/search_item_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../../../generated/l10n.dart' as l;
import '../../../../core/error/error_code.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/service/shop/bundle/bundle_item_service.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/alert_util.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/shop/bundle/bundle_item/bundle_item_model.dart';
import '../../../../models/shop/item/item.dart';
import '../../../../widgets/shadow_container/_shadow_container.dart';
import '../../../../widgets/textfield_wrapper/_textfield_wrapper.dart';
import '../../../common_widget/custom_button.dart';

class BundleItemWidget extends StatefulWidget {
  const BundleItemWidget({super.key, required this.bundleId});

  final int bundleId;

  @override
  State<BundleItemWidget> createState() => _BundleItemWidgetState();
}

class _BundleItemWidgetState extends State<BundleItemWidget> {
  //State Manage
  bool isModState = false;

  //Service
  final BundleItemService bundleItemService = BundleItemService();

  //Future Model
  late Future<List<BundleItemModel>> bundleItemList;

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //번들 아이템 목록 조회
  Future<List<BundleItemModel>> getBundleItemList() async {
    try {
      List<BundleItemDetail> list = await bundleItemService.getBundleItemList(widget.bundleId);

      return list.map((item) => BundleItemModel(
              item: item.item,
              nameController: TextEditingController(text: item.item.name),
              countController: TextEditingController(text: item.count.toString())))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  //번들 아이템 변경
  Future<void> modBundleItem() async {
    try {
      List<BundleItemModel> list = await bundleItemList;
      List<BundleItemSimple> bundleItems = [];
      for (BundleItemModel model in list) {
        checkModParameter(model);
        bundleItems.add(BundleItemSimple(
            bundleId: widget.bundleId,
            itemId: model.item!.id,
            count: int.parse(model.countController.text)));
      }
      BundleItemModParam bundleItemModParam =
          BundleItemModParam(bundleItems: bundleItems);
      await bundleItemService.modBundleItem(widget.bundleId, bundleItemModParam);
      AlertUtil.successDialog(
          context: context,
          message: lang.successModBundleItem,
          buttonText: lang.confirm,
          onPressed: () {
            GoRouter.of(context).pop();
            setState(() {
              isModState = false;
              bundleItemList = getBundleItemList();
            });
          }
      );
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  void checkModParameter(BundleItemModel model) {
    if (model.countController.text.isEmpty) {
      throw CustomException(ErrorCode.FAIL_TO_CONVERT_FILE);
    }
  }

  @override
  void initState() {
    super.initState();
    bundleItemList = getBundleItemList();
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
        future: bundleItemList,
        onSuccess: (context, bundleItemList) {
          return Column(
            children: [
              ShadowContainer(
              headerText: lang.bundleItem,
              child: ResponsiveGridRow(children: [
                ...bundleItemList.map((model) {
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
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: theme.colorScheme.primary),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextFieldLabelWrapper(
                                  labelText: lang.name,
                                  inputField: TextFormField(
                                    readOnly: true,
                                    controller: model.nameController,
                                    decoration: InputDecoration(
                                      hintText: lang.hintName,
                                      filled: true,
                                      fillColor: theme.colorScheme.tertiaryContainer,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                            Icons.search,
                                            color: theme.colorScheme.primary
                                        ),
                                        onPressed: () {
                                          showSearchDialog(context, model);
                                        },
                                      ),
                                    ),
                                    validator: (value) => value?.isEmpty ?? true ? lang.invalidName : null,
                                    autovalidateMode: AutovalidateMode.onUnfocus,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFieldLabelWrapper(
                                  labelText: lang.count,
                                  inputField: TextFormField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    controller: model.countController,
                                    enabled: isModState,
                                    decoration: InputDecoration(
                                      hintText: lang.hintCount,
                                      filled: !isModState,
                                      fillColor: theme.colorScheme.tertiaryContainer,
                                    ),
                                    validator: (value) => value?.isEmpty ?? true ? lang.invalidCount : null,
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
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.info_outline,
                                        color: theme.colorScheme.primary),
                                    onPressed: () {
                                      if (model.item != null) {
                                        showInfoFormDialog(model.item!);
                                      }
                                    },
                                  ),

                                  // 닫기 버튼
                                  IconButton(
                                    icon: Icon(Icons.close,
                                        color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        if (isModState) {
                                          model.countController.dispose();
                                          bundleItemList.remove(model);
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                                buildBundleItemField(bundleItemList);
                              }
                            });
                          },
                          label: Text(
                            lang.addNewBundleItem,
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
                                    modBundleItem(),
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
                                    this.bundleItemList = getBundleItemList();
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

  void buildBundleItemField(List<BundleItemModel> bundleItemList) {
    TextEditingController countController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    bundleItemList.add(BundleItemModel(
        item: null,
        nameController: nameController,
        countController: countController));
  }

  void showSearchDialog(BuildContext context, BundleItemModel model) async {
    Item? item = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const SearchItemDialog();
      },
    );

    if (item != null) {
      setState(() {
        model.item = item;
        model.nameController.text = item.name;
      });
    }
  }

  void showInfoFormDialog(Item item) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: BundleItemInfoDialog(item: item)
        );
      },
    );
  }
}
