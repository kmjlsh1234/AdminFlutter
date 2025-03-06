// 🐦 Flutter imports:
// 📦 Package imports:
import 'package:acnoo_flutter_admin_panel/app/constants/shop/item/item_period_type.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/shop/item/item_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/alert_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/shop/item/component/search_category_popup.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/shop/item/component/search_item_unit_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../../generated/l10n.dart' as l;
// 🌎 Project imports:
import '../../../constants/file/file_category.dart';
import '../../../constants/file/file_type.dart';
import '../../../constants/shop/item/currency_type.dart';
import '../../../constants/shop/item/image_select_type.dart';
import '../../../core/error/error_code.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/service/file/file_service.dart';
import '../../../core/static/_static_values.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/shop/category/category.dart';
import '../../../models/shop/item/item.dart';
import '../../../models/shop/item/item_add_param.dart';
import '../../../models/shop/item_unit/item_unit.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';
import '../../../widgets/textfield_wrapper/_textfield_wrapper.dart';
import '../../common_widget/custom_button.dart';
import '../../common_widget/dotted_borderer_container.dart';

class ItemAddView extends StatefulWidget {
  const ItemAddView({super.key});

  @override
  State<ItemAddView> createState() => _ItemAddViewState();
}

class _ItemAddViewState extends State<ItemAddView> {

  //Input Controller
  final TextEditingController skuController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController unitSkuController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController numController = TextEditingController();
  final TextEditingController stockQuantityController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController infoController = TextEditingController();
  final TextEditingController expirationController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController periodController = TextEditingController();

  //Service
  final ItemService itemService = ItemService();
  final FileService fileService = FileService();

  //Future Model
  late Future<List<Category>> categoryList;

  //DropDown
  CurrencyType currencyType = CurrencyType.DIAMOND;
  ItemPeriodType periodType = ItemPeriodType.NONE;

  //File
  final ImagePicker picker = ImagePicker();
  String? thumbnailPath;
  String? imagePath;
  XFile? imageFile;
  XFile? thumbnailFile;

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //아이템 추가
  Future<void> addItem() async {
    try {
      //TODO: 입력 파라미터 검사
      checkAddParameter();

      //TODO: 파일 서버에 파일 전송 후 경로 받기
      String thumbnailPath = await fileService.uploadFileTest(thumbnailFile, FileCategory.PROFILE, FileType.IMAGE);
      String imagePath = await fileService.uploadFileTest(imageFile, FileCategory.PROFILE, FileType.IMAGE);

      //TODO: ADMIN서버에 아이템 추가
      Item item = await itemService.addItem(getItemAddParam(thumbnailPath, imagePath));
      AlertUtil.successDialog(
          context: context,
          message: lang.successAddItem,
          buttonText: lang.confirm,
          onPressed: () {
            GoRouter.of(context).pop();
            GoRouter.of(context).go('/shops/items/item-list');
          }
      );
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  //이미지 로컬에서 가져오기
  Future<void> pickImage(ImageSelectType type) async {
    try {
      XFile? pickFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickFile != null) {
        setState(() {
          switch (type) {
            case ImageSelectType.THUMBNAIL:
              thumbnailFile = pickFile;
              thumbnailPath = pickFile.path;
              break;
            case ImageSelectType.IMAGE:
              imageFile = pickFile;
              imagePath = pickFile.path;
              break;
          }
        });
      }
    } catch (e) {
      ErrorHandler.handleError(ErrorCode.FAIL_TO_CONVERT_FILE, context);
    }
  }

  ItemAddParam getItemAddParam(String thumbnailPath, String imagePath) {
    int? categoryId = categoryController.text.isNotEmpty ? int.parse(categoryController.text) : null;
    String? unitSku = unitSkuController.text.isNotEmpty ? unitSkuController.text : null;
    String? expiration = expirationController.text.isNotEmpty ? DateUtil.convertToLocalDateTime(expirationController.text) : null;
    int? num = numController.text.isNotEmpty ? int.parse(numController.text) : 1;
    int? stockQuantity = stockQuantityController.text.isNotEmpty ? int.parse(stockQuantityController.text) : null;
    int? amount = amountController.text.isNotEmpty ? int.parse(amountController.text) : 0;
    int? period = periodController.text.isNotEmpty ? int.parse(periodController.text) : null;

    return ItemAddParam(
        categoryId: categoryId!,
        sku: skuController.text,
        unitSku: unitSku,
        name: nameController.text,
        description: descController.text,
        num: num,
        stockQuantity: stockQuantity,
        thumbnail: thumbnailPath,
        image: imagePath,
        info: infoController.text,
        periodType: periodType,
        period: period,
        expiration: expiration,
        currencyType: currencyType,
        amount: amount
    );
  }

  //파라미터 검사
  void checkAddParameter() {
    if (skuController.text.isEmpty) {
      throw CustomException(ErrorCode.ITEM_SKU_EMPTY);
    }

    if (nameController.text.isEmpty) {
      throw CustomException(ErrorCode.ITEM_NAME_EMPTY);
    }

    if (categoryController.text.isEmpty) {
      throw CustomException(ErrorCode.ITEM_CATEGORY_EMPTY);
    }

    if (descController.text.isEmpty) {
      throw CustomException(ErrorCode.ITEM_DESC_EMPTY);
    }

    if (infoController.text.isEmpty) {
      throw CustomException(ErrorCode.ITEM_INFO_EMPTY);
    }

    if (periodType == ItemPeriodType.DAY || periodType == ItemPeriodType.MONTH) {
      if(periodController.text.isEmpty){
        throw CustomException(ErrorCode.INVALID_PERIOD_PARAMETER);
      }
    }

    if(periodType == ItemPeriodType.EXPIRATION && expirationController.text.isEmpty){
      throw CustomException(ErrorCode.INVALID_PERIOD_PARAMETER);
    }

    if (periodType == ItemPeriodType.NONE) {
      periodController.clear();
      expirationController.clear();
    }

    if (thumbnailPath == null) {
      throw CustomException(ErrorCode.ITEM_THUMBNAIL_EMPTY);
    }

    if (imagePath == null) {
      throw CustomException(ErrorCode.ITEM_IMAGE_EMPTY);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    skuController.dispose();
    nameController.dispose();
    unitSkuController.dispose();
    categoryController.dispose();
    numController.dispose();
    stockQuantityController.dispose();
    descController.dispose();
    infoController.dispose();
    expirationController.dispose();
    amountController.dispose();
    periodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const _lg = 4;
    const _md = 6;

    lang = l.S.of(context);
    theme = Theme.of(context);
    textTheme = theme.textTheme;
    SizeInfo sizeInfo = SizeConfig.getSizeInfo(context);

    return Scaffold(
      body: ListView(
        padding: sizeInfo.padding,
        children: [
          // Input Example
          ShadowContainer(
            headerText: lang.item,
            child: ResponsiveGridRow(
              children: [
                //SKU
                buildTextField(
                    sizeInfo: sizeInfo,
                    labelText: lang.sku,
                    invalidText: lang.invalidSku,
                    hintText: lang.hintSku,
                    controller: skuController
                ),

                //NAME
                buildTextField(
                    sizeInfo: sizeInfo,
                    labelText: lang.name,
                    invalidText: lang.invalidName,
                    hintText: lang.hintName,
                    controller: nameController
                ),

                //UNIT SKU
                buildSearchField(
                    sizeInfo: sizeInfo,
                    labelText: lang.itemUnitSku,
                    controller: unitSkuController,
                    callBack: () => showUnitSearchDialog(context)
                ),

                //CATEGORY
                buildSearchField(
                    sizeInfo: sizeInfo,
                    labelText: lang.categoryId,
                    controller: categoryController,
                    callBack: () => showCategorySearchDialog(context)
                ),

                // NUM
                buildDigitField(
                    sizeInfo: sizeInfo,
                    labelText: lang.num,
                    hintText: lang.hintNum,
                    controller: numController
                ),

                // STOCK QUANTITY
                buildDigitField(
                    sizeInfo: sizeInfo,
                    labelText: lang.stockQuantity,
                    hintText: lang.hintStockQuantity,
                    controller: stockQuantityController
                ),

                // DESCRIPTION
                buildTextField(
                    sizeInfo: sizeInfo,
                    labelText: lang.description,
                    hintText: lang.hintDescription,
                    invalidText: lang.invalidDescription,
                    controller: descController
                ),

                // INFO
                buildTextField(
                    sizeInfo: sizeInfo,
                    labelText: lang.info,
                    hintText: lang.hintInfo,
                    invalidText: lang.invalidInfo,
                    controller: infoController
                ),

                // EMPTY
                buildEmptyField(sizeInfo: sizeInfo),

                // CURRENCY TYPE
                ResponsiveGridCol(
                  lg: _lg,
                  md: _md,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.all(sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      labelText: lang.type,
                      inputField: DropdownButtonFormField<CurrencyType>(
                        dropdownColor: theme.colorScheme.primaryContainer,
                        value: currencyType,
                        hint: Text(
                          lang.type,
                          //'Currency Type',
                          style: textTheme.bodySmall,
                        ),
                        items: CurrencyType.values.map((type) {
                          return DropdownMenuItem<CurrencyType>(
                            value: type,
                            child: Text(type.value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            currencyType = value!;
                          });
                        },
                        validator: (value) =>
                            value == null ? lang.pleaseSelectAPosition : null,
                      ),
                    ),
                  ),
                ),

                // AMOUNT
                buildDigitField(
                    sizeInfo: sizeInfo,
                    labelText: lang.amount,
                    hintText: lang.amount,
                    controller: amountController
                ),

                // EMPTY
                buildEmptyField(sizeInfo: sizeInfo),

                // PERIOD TYPE
                ResponsiveGridCol(
                  lg: _lg,
                  md: _md,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.all(sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      labelText: lang.periodType,
                      inputField: DropdownButtonFormField<ItemPeriodType>(
                        dropdownColor: theme.colorScheme.primaryContainer,
                        value: periodType,
                        hint: Text(
                          lang.type,
                          //'Currency Type',
                          style: textTheme.bodySmall,
                        ),
                        items: ItemPeriodType.values.map((type) {
                          return DropdownMenuItem<ItemPeriodType>(
                            value: type,
                            child: Text(type.value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            periodType = value!;
                          });
                        },
                        validator: (value) =>
                            value == null ? lang.pleaseSelectAPosition : null,
                      ),
                    ),
                  ),
                ),

                //PERIOD OR EXPIRATION
                selectPeriodField(sizeInfo),

                // EMPTY
                buildEmptyField(sizeInfo: sizeInfo),

                ResponsiveGridCol(
                  lg: _lg,
                  md: _md,
                  child: Padding(
                      padding:
                          EdgeInsetsDirectional.all(sizeInfo.innerSpacing / 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: TextFieldLabelWrapper(
                                labelText: lang.thumbnail,
                                inputField: DottedBorderContainer(
                                  child: GestureDetector(
                                    onTap: () => pickImage(ImageSelectType.THUMBNAIL),
                                    child: thumbnailPath == null
                                        ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.camera_alt_outlined,
                                          color: theme.colorScheme.onTertiary,
                                        ),
                                        Text(lang.uploadImage),
                                      ],
                                    )
                                        : ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          thumbnailPath!,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                ),
                              ),
                          ),

                          const SizedBox(width: 100),

                          Expanded(
                              child: TextFieldLabelWrapper(
                                labelText: lang.image,
                                inputField: DottedBorderContainer(
                                  child: GestureDetector(
                                    onTap: () => pickImage(ImageSelectType.IMAGE),
                                    child: imagePath == null
                                        ? Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.camera_alt_outlined,
                                          color: theme.colorScheme.onTertiary,
                                        ),
                                        Text(lang.uploadImage),
                                      ],
                                    )
                                        : ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          imagePath!,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                ),
                              ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),

          SizedBox(height: sizeInfo.innerSpacing),

          Padding(
            padding: EdgeInsets.all(sizeInfo.innerSpacing),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 200,
                child: CustomButton(
                  textTheme: textTheme,
                  label: lang.addNewItem,
                  onPressed: () => addItem(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ResponsiveGridCol selectPeriodField(SizeInfo sizeInfo) {
    switch(periodType){
      case ItemPeriodType.NONE:
        return buildEmptyField(sizeInfo: sizeInfo);
      case ItemPeriodType.DAY || ItemPeriodType.MONTH:
        return buildDigitField(
            sizeInfo: sizeInfo,
            labelText: lang.period,
            hintText: lang.hintPeriod,
            controller: periodController
        );
      case ItemPeriodType.EXPIRATION:
        return buildDateField(
            sizeInfo: sizeInfo,
            labelText: lang.expiration,
            controller: expirationController
        );
    }
  }

  ResponsiveGridCol buildSearchField({required SizeInfo sizeInfo, required String labelText, required TextEditingController controller, required VoidCallback callBack}){
    return ResponsiveGridCol(
      lg: 4,
      md: 6,
      child: Padding(
        padding: EdgeInsetsDirectional.all(sizeInfo.innerSpacing / 2),
        child: TextFieldLabelWrapper(
          labelText: labelText,
          inputField: TextFormField(
            readOnly: true,
            controller: controller,
            decoration: InputDecoration(
              hintText: lang.search,
              filled: true,
              fillColor: theme.colorScheme.tertiaryContainer,
              suffixIcon: IconButton(
                icon: Icon(
                    Icons.search,
                    color: theme.colorScheme.primary
                ),
                onPressed: () {
                  callBack();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  ResponsiveGridCol buildTextField({required SizeInfo sizeInfo, required String labelText, required String invalidText, required String hintText,  required TextEditingController controller}){
    return ResponsiveGridCol(
      lg: 4,
      md: 6,
      child: Padding(
        padding: EdgeInsetsDirectional.all(sizeInfo.innerSpacing / 2),
        child: TextFieldLabelWrapper(
          labelText: labelText,
          inputField: TextFormField(
            controller: controller,
            decoration: InputDecoration(hintText: hintText),
            validator: (value) => value?.isEmpty ?? true ? invalidText : null,
            autovalidateMode: AutovalidateMode.onUnfocus,
          ),
        ),
      ),
    );
  }

  ResponsiveGridCol buildDigitField({required SizeInfo sizeInfo, required String labelText, required String hintText,  required TextEditingController controller}){
    return ResponsiveGridCol(
      lg: 4,
      md: 6,
      child: Padding(
        padding:
        EdgeInsetsDirectional.all(sizeInfo.innerSpacing / 2),
        child: StatefulBuilder(
          builder: (context, setState) {
            return TextFieldLabelWrapper(
              labelText: labelText,
              inputField: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: controller,
                decoration: InputDecoration(hintText: hintText),
              ),
            );
          },
        ),
      ),
    );
  }

  ResponsiveGridCol buildDateField({required SizeInfo sizeInfo, required String labelText, required TextEditingController controller}){
    return ResponsiveGridCol(
      lg: 4,
      md: 6,
      child: Padding(
        padding: EdgeInsetsDirectional.all(sizeInfo.innerSpacing / 2),
        child: TextFieldLabelWrapper(
          labelText: labelText,
          inputField: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  readOnly: true,
                  selectionControls: EmptyTextSelectionControls(),
                  decoration: InputDecoration(
                    hintText: lang.search,
                    suffixIcon: const Icon(IconlyLight.calendar, size: 20),
                  ),
                  onTap: () async {
                    final result = await showDatePicker(
                      context: context,
                      firstDate: AppDateConfig.appFirstDate,
                      lastDate: AppDateConfig.appLastDate,
                      initialDate: DateTime.now(),
                      builder: (context, child) => Theme(
                        data: theme.copyWith(
                          datePickerTheme: DatePickerThemeData(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        child: child!,
                      ),
                    );
                    if (result != null) {
                      controller.text = DateFormat(DateUtil.dateTimeFormat).format(result);
                    }
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 20),
                onPressed: () {
                  expirationController.clear();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  ResponsiveGridCol buildEmptyField({required SizeInfo sizeInfo}){
    return ResponsiveGridCol(
      lg: 4,
      md: 6,
      child: Padding(
        padding:
        EdgeInsetsDirectional.all(sizeInfo.innerSpacing / 2),
      ),
    );
  }


  void showUnitSearchDialog(BuildContext context) async {
    ItemUnit? itemUnit = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const SearchItemUnitDialog();
      },
    );

    if (itemUnit != null) {
      setState(() {
        unitSkuController.text = itemUnit.sku;
      });
    }
  }

  void showCategorySearchDialog(BuildContext context) async {
    Category? category = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const SearchCategoryDialog();
      },
    );

    if (category != null) {
      setState(() {
        categoryController.text = category.id.toString();
      });
    }
  }
}
