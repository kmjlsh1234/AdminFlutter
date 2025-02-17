// 🐦 Flutter imports:
// 📦 Package imports:
import 'package:acnoo_flutter_admin_panel/app/constants/shop/item/item_period_type.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/shop/category/category_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/shop/item/item_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/alert_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/compare_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../../core/helpers/field_styles/_dropdown_styles.dart';
import '../../../core/helpers/field_styles/_input_field_styles.dart';
import '../../../core/service/file/file_service.dart';
import '../../../core/static/_static_values.dart';
import '../../../core/theme/_app_colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/shop/category/category.dart';
import '../../../models/shop/item/item.dart';
import '../../../models/shop/item/item_mod_param.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';
import '../../../widgets/textfield_wrapper/_textfield_wrapper.dart';
import '../../common_widget/custom_button.dart';
import '../../common_widget/dotted_borderer_container.dart';

class ItemInfoView extends StatefulWidget {
  const ItemInfoView({super.key, required this.itemId});

  final int itemId;

  @override
  State<ItemInfoView> createState() => _ItemInfoViewState();
}

class _ItemInfoViewState extends State<ItemInfoView> {
  bool isModState = false;

  //Input Controller
  final TextEditingController skuController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController unitSkuController = TextEditingController();
  final TextEditingController numController = TextEditingController();
  final TextEditingController stockQuantityController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController infoController = TextEditingController();
  final TextEditingController expirationController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController periodController = TextEditingController();

  //DropDown Menu
  late CurrencyType currencyType;
  late ItemPeriodType periodType;

  //Service
  final CategoryService categoryService = CategoryService();
  final ItemService itemService = ItemService();
  final FileService fileService = FileService();

  //Future Model
  late Future<List<Category>> categoryList;
  late Future<Item> item;
  late int categoryId;

  //FILE
  final ImagePicker picker = ImagePicker();
  String? thumbnailPath;
  String? imagePath;
  XFile? imageFile;
  XFile? thumbnailFile;

  //카테고리 목록 전부 조회
  Future<List<Category>> getAllCategoryList() async {
    try {
      return await categoryService.getAllCategoryList();
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  //아이템 단일 조회
  Future<Item> getItem() async {
    try {
      Item item = await itemService.getItem(widget.itemId);
      setData(item);
      return item;
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  //아이템 변경
  Future<void> modItem(Item currentItem) async {
    try {
      //TODO: 입력 파라미터 검사
      checkModParameter();

      //TODO: 파일 서버에 파일 전송 후 경로 받기
      String? remoteThumbnailPath;
      String? remoteImagePath;

      if (thumbnailPath != null && (thumbnailPath != currentItem.thumbnail)) {
        remoteThumbnailPath = await fileService.uploadFileTest(thumbnailFile, FileCategory.profile, FileType.image);
      }

      if (imagePath != null && (imagePath != currentItem.image)) {
        remoteImagePath = await fileService.uploadFileTest(imageFile, FileCategory.profile, FileType.image);
      }

      ItemModParam itemModParam = getItemModParam(remoteThumbnailPath, remoteImagePath, currentItem);

      Item item = await itemService.modItem(widget.itemId, itemModParam);
      AlertUtil.viewSuccessDialog(context, '아이템 정보 변경 성공');

      setState(() {
        isModState = false;
        this.item = getItem();
      });

    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  //이미지 로컬에서 가져오기
  Future<void> pickImage(ImageSelectType type) async {
    try {
      XFile? pickFile = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickFile != null) {
          switch (type) {
            case ImageSelectType.thumbnail:
              thumbnailFile = pickFile;
              thumbnailPath = pickFile.path;
              break;
            case ImageSelectType.image:
              imageFile = pickFile;
              imagePath = pickFile.path;
              break;
          }
        }
      });


    } catch (e) {
      ErrorHandler.handleError(ErrorCode.FAIL_TO_CONVERT_FILE, context);
    }
  }

  ItemModParam getItemModParam(String? thumbnail, String? image, Item item) {
    return ItemModParam(
      categoryId: CompareUtil.compareIntValue(item.categoryId, categoryId),
      sku: CompareUtil.compareStringValue(item.sku, skuController.text),
      name: CompareUtil.compareStringValue(item.name, nameController.text),
      unitSku: CompareUtil.compareStringValue(item.unitSku, unitSkuController.text),
      description: CompareUtil.compareStringValue(item.description, descController.text),
      num: CompareUtil.compareIntValue(item.num, int.tryParse(numController.text)),
      stockQuantity: CompareUtil.compareIntValue(item.stockQuantity, int.tryParse(stockQuantityController.text)),
      thumbnail: thumbnail,
      image: image,
      info: CompareUtil.compareStringValue(item.info, infoController.text),
      periodType: CompareUtil.compareStringValue(item.periodType, periodType.value),
      period: CompareUtil.compareIntValue(item.period, int.tryParse(periodController.text)),
      expiration: CompareUtil.compareStringValue(DateUtil.convertDateTimeToLocalDateTime(item.expiration), expirationController.text),
      currencyType: CompareUtil.compareStringValue(item.currencyType, currencyType.value),
      amount: CompareUtil.compareIntValue(item.amount, int.tryParse(amountController.text)),
    );
  }

  //파라미터 검사
  void checkModParameter() {
    if (skuController.text.isEmpty) {
      throw CustomException(ErrorCode.ITEM_SKU_EMPTY);
    }

    if (nameController.text.isEmpty) {
      throw CustomException(ErrorCode.ITEM_NAME_EMPTY);
    }

    if (descController.text.isEmpty) {
      throw CustomException(ErrorCode.ITEM_DESC_EMPTY);
    }

    if (infoController.text.isEmpty) {
      throw CustomException(ErrorCode.ITEM_INFO_EMPTY);
    }

    if (periodType != ItemPeriodType.none && (periodController.text.isEmpty)) {
      throw CustomException(ErrorCode.INVALID_PERIOD_PARAMETER);
    }

    if (periodType == ItemPeriodType.none) {
      periodController.text = '';
    }

    if (amountController.text.isEmpty) {
      throw CustomException(ErrorCode.ITEM_AMOUNT_EMPTY);
    }

    if (categoryId.isNaN) {
      throw CustomException(ErrorCode.ITEM_CATEGORY_EMPTY);
    }

    if (thumbnailPath == null) {
      throw CustomException(ErrorCode.ITEM_THUMBNAIL_EMPTY);
    }

    if (imagePath == null) {
      throw CustomException(ErrorCode.ITEM_IMAGE_EMPTY);
    }
  }

  void setData(Item item) {
    skuController.text = item.sku;
    nameController.text = item.name;
    unitSkuController.text = item.unitSku ?? 'N/A';
    numController.text = item.num.toString();
    stockQuantityController.text = item.stockQuantity?.toString() ?? '';
    descController.text = item.description;
    infoController.text = item.info;
    expirationController.text = DateUtil.convertDateTimeToLocalDateTime(item.expiration) ?? '';
    amountController.text = item.amount.toString();
    periodController.text = item.period?.toString() ?? '';
    categoryId = item.categoryId;
    currencyType = CurrencyType.fromValue(item.currencyType);
    periodType = ItemPeriodType.fromValue(item.periodType);
    thumbnailPath = item.thumbnail;
    imagePath = item.image;
  }

  @override
  void initState() {
    super.initState();
    categoryList = getAllCategoryList();
    item = getItem();
  }

  @override
  void dispose() {
    skuController.dispose();
    nameController.dispose();
    unitSkuController.dispose();
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

    final AcnooDropdownStyle _dropdownStyle = AcnooDropdownStyle(context);
    final AcnooInputFieldStyles _inputFieldStyle =
        AcnooInputFieldStyles(context);
    final ThemeData _theme = Theme.of(context);
    final _textTheme = Theme.of(context).textTheme;
    final _sizeInfo = SizeConfig.getSizeInfo(context);
    final l.S lang = l.S.of(context);

    return FutureBuilderFactory.createFutureBuilder(
        future: item,
        onSuccess: (context, item) {
          return Scaffold(
            body: ListView(
              padding: _sizeInfo.padding,
              children: [
                ShadowContainer(
                  headerText: lang.item,
                  child: ResponsiveGridRow(
                    children: [
                      //SKU
                      ResponsiveGridCol(
                        lg: _lg,
                        md: _md,
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(
                              _sizeInfo.innerSpacing / 2),
                          child: TextFieldLabelWrapper(
                            labelText: lang.sku,
                            inputField: TextFormField(
                              enabled: isModState,
                              controller: skuController,
                              decoration: InputDecoration(
                                hintText: lang.sku,
                                filled: !isModState,
                                fillColor: _theme.colorScheme.tertiaryContainer,
                              ),
                            ),
                          ),
                        ),
                      ),

                      //NAME
                      ResponsiveGridCol(
                        lg: _lg,
                        md: _md,
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(
                              _sizeInfo.innerSpacing / 2),
                          child: TextFieldLabelWrapper(
                            labelText: lang.name,
                            inputField: TextFormField(
                              enabled: isModState,
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: lang.name,
                                filled: !isModState,
                                fillColor: _theme.colorScheme.tertiaryContainer,
                              ),
                            ),
                          ),
                        ),
                      ),

                      //UNIT SKU
                      ResponsiveGridCol(
                        lg: _lg,
                        md: _md,
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(
                              _sizeInfo.innerSpacing / 2),
                          child: TextFieldLabelWrapper(
                            labelText: lang.itemUnitSku,
                            inputField: TextFormField(
                              enabled: isModState,
                              controller: unitSkuController,
                              decoration: InputDecoration(
                                hintText: lang.itemUnitSku,
                                filled: !isModState,
                                fillColor: _theme.colorScheme.tertiaryContainer,
                              ),
                            ),
                          ),
                        ),
                      ),

                      //CATEGORY
                      ResponsiveGridCol(
                        lg: _lg,
                        md: _md,
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                          child: FutureBuilderFactory.createFutureBuilder(
                              future: categoryList,
                              onSuccess: (context, categoryList) {
                                return TextFieldLabelWrapper(
                                  labelText: lang.category,
                                  inputField: DropdownButtonFormField2(
                                    value: categoryId,
                                    menuItemStyleData:
                                    _dropdownStyle.menuItemStyle,
                                    buttonStyleData: _dropdownStyle.buttonStyle,
                                    iconStyleData: _dropdownStyle.iconStyle,
                                    dropdownStyleData:
                                    _dropdownStyle.dropdownStyle,
                                    hint: Text(lang.select),
                                    decoration: InputDecoration(
                                      filled: !isModState,
                                      fillColor: isModState
                                          ? _theme.colorScheme.tertiaryContainer
                                          : Colors.grey.shade300,
                                    ),
                                    items: List.generate(
                                      categoryList.length,
                                          (index) => DropdownMenuItem(
                                        enabled: isModState,
                                        value: categoryList[index].id,
                                        child: Text(categoryList[index].name),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      if (isModState) {
                                        categoryId = value!;
                                      }
                                    },
                                  ),
                                );
                              }),
                        ),
                      ),

                      // NUM
                      ResponsiveGridCol(
                        lg: _lg,
                        md: _md,
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(
                              _sizeInfo.innerSpacing / 2),
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return TextFieldLabelWrapper(
                                labelText: lang.num,
                                inputField: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: numController,
                                  enabled: isModState,
                                  decoration: InputDecoration(
                                    hintText: lang.num,
                                    filled: !isModState,
                                    fillColor:
                                        _theme.colorScheme.tertiaryContainer,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // STOCK QUANTITY
                      ResponsiveGridCol(
                        lg: _lg,
                        md: _md,
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(
                              _sizeInfo.innerSpacing / 2),
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return TextFieldLabelWrapper(
                                labelText: lang.stockQuantity,
                                inputField: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  enabled: isModState,
                                  controller: stockQuantityController,
                                  decoration: InputDecoration(
                                    hintText: lang.stockQuantity,
                                    filled: !isModState,
                                    fillColor:
                                        _theme.colorScheme.tertiaryContainer,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // DESCRIPTION
                      ResponsiveGridCol(
                        lg: _lg,
                        md: _md,
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(
                              _sizeInfo.innerSpacing / 2),
                          child: TextFieldLabelWrapper(
                            labelText: lang.description,
                            inputField: TextFormField(
                              maxLines: 2,
                              enabled: isModState,
                              controller: descController,
                              decoration: InputDecoration(
                                hintText: lang.description,
                                filled: !isModState,
                                fillColor: _theme.colorScheme.tertiaryContainer,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // INFO
                      ResponsiveGridCol(
                        lg: _lg,
                        md: _md,
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(
                              _sizeInfo.innerSpacing / 2),
                          child: TextFieldLabelWrapper(
                            labelText: lang.info,
                            inputField: TextFormField(
                              maxLines: 2,
                              enabled: isModState,
                              controller: infoController,
                              decoration: InputDecoration(
                                hintText: lang.info,
                                filled: !isModState,
                                fillColor: _theme.colorScheme.tertiaryContainer,
                              ),
                            ),
                          ),
                        ),
                      ),

                      //EXPIRATION
                      ResponsiveGridCol(
                        lg: _lg,
                        md: _md,
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(
                              _sizeInfo.innerSpacing / 2),
                          child: TextFieldLabelWrapper(
                            labelText: lang.expiration,
                            inputField: TextFormField(
                              controller: expirationController,
                              keyboardType: TextInputType.visiblePassword,
                              readOnly: true,
                              selectionControls: EmptyTextSelectionControls(),
                              decoration: InputDecoration(
                                labelStyle: _textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                filled: !isModState,
                                fillColor: isModState
                                    ? _theme.colorScheme.tertiaryContainer
                                    : Colors.grey.shade300,
                                hintText: 'yyyy-MM-ddTHH:mm:ss',
                                //'mm/dd/yyyy',
                                suffixIcon:
                                    const Icon(IconlyLight.calendar, size: 20),
                              ),
                              onTap: () async {
                                final _result = await showDatePicker(
                                  context: context,
                                  firstDate: AppDateConfig.appFirstDate,
                                  lastDate: AppDateConfig.appLastDate,
                                  initialDate: DateTime.now(),
                                  builder: (context, child) => Theme(
                                    data: _theme.copyWith(
                                      datePickerTheme: DatePickerThemeData(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  ),
                                );
                                if (_result != null) {
                                  expirationController.text = DateFormat(
                                    AppDateConfig.localDateTimeFormat,
                                  ).format(_result);
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      // CURRENCY TYPE
                      ResponsiveGridCol(
                        lg: _lg,
                        md: _md,
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(
                              _sizeInfo.innerSpacing / 2),
                          child: TextFieldLabelWrapper(
                            labelText: lang.type,
                            inputField: DropdownButtonFormField<CurrencyType>(
                              dropdownColor:
                                  _theme.colorScheme.primaryContainer,
                              value: currencyType,
                              decoration: InputDecoration(
                                filled: !isModState,
                                fillColor: isModState
                                    ? _theme.colorScheme.tertiaryContainer
                                    : Colors.grey.shade300,
                              ),
                              hint: Text(
                                lang.type,
                                //'Currency Type',
                                style: _textTheme.bodySmall,
                              ),
                              items: CurrencyType.values.map((type) {
                                return DropdownMenuItem<CurrencyType>(
                                  value: type,
                                  enabled: isModState,
                                  child: Text(type.value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  if (isModState) {
                                    currencyType = value!;
                                  }
                                });
                              },
                              validator: (value) => value == null
                                  ? lang.pleaseSelectAPosition
                                  : null,
                            ),
                          ),
                        ),
                      ),

                      // AMOUNT
                      ResponsiveGridCol(
                        lg: _lg,
                        md: _md,
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(
                              _sizeInfo.innerSpacing / 2),
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return TextFieldLabelWrapper(
                                labelText: lang.amount,
                                inputField: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  enabled: isModState,
                                  controller: amountController,
                                  decoration: InputDecoration(
                                      hintText: lang.amount,
                                      filled: !isModState,
                                      fillColor:
                                          _theme.colorScheme.tertiaryContainer),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // EMPTY
                      ResponsiveGridCol(
                        lg: _lg,
                        md: _md,
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(
                              _sizeInfo.innerSpacing / 2),
                        ),
                      ),

                      // PERIOD TYPE
                      ResponsiveGridCol(
                        lg: _lg,
                        md: _md,
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(
                              _sizeInfo.innerSpacing / 2),
                          child: TextFieldLabelWrapper(
                            labelText: lang.periodType,
                            inputField: DropdownButtonFormField<ItemPeriodType>(
                              dropdownColor:
                                  _theme.colorScheme.primaryContainer,
                              value: periodType,
                              decoration: InputDecoration(
                                filled: !isModState,
                                fillColor: isModState
                                    ? _theme.colorScheme.tertiaryContainer
                                    : Colors.grey.shade300,
                              ),
                              hint: Text(
                                lang.type,
                                //'Currency Type',
                                style: _textTheme.bodySmall,
                              ),
                              items: ItemPeriodType.values.map((type) {
                                return DropdownMenuItem<ItemPeriodType>(
                                  enabled: isModState,
                                  value: type,
                                  child: Text(type.value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (isModState) {
                                  setState(() {
                                    periodType = value!;
                                  });
                                }
                              },
                              validator: (value) => value == null
                                  ? lang.pleaseSelectAPosition
                                  : null,
                            ),
                          ),
                        ),
                      ),

                      periodType != ItemPeriodType.none
                          ?
                          // PERIOD
                          ResponsiveGridCol(
                              lg: _lg,
                              md: _md,
                              child: Padding(
                                padding: EdgeInsetsDirectional.all(
                                    _sizeInfo.innerSpacing / 2),
                                child: StatefulBuilder(
                                  builder: (context, setState) {
                                    return TextFieldLabelWrapper(
                                      labelText: lang.period,
                                      inputField: TextFormField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        enabled: isModState,
                                        controller: periodController,
                                        decoration: InputDecoration(
                                            hintText: lang.period,
                                            filled: !isModState,
                                            fillColor: _theme
                                                .colorScheme.tertiaryContainer),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : // EMPTY
                          ResponsiveGridCol(
                              lg: _lg,
                              md: _md,
                              child: Padding(
                                padding: EdgeInsetsDirectional.all(
                                    _sizeInfo.innerSpacing / 2),
                              ),
                            ),

                      //EMPTY
                      ResponsiveGridCol(
                        lg: _lg,
                        md: _md,
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(
                              _sizeInfo.innerSpacing / 2),
                        ),
                      ),

                      ResponsiveGridCol(
                        lg: _lg,
                        md: _md,
                        child: Padding(
                            padding: EdgeInsetsDirectional.all(
                                _sizeInfo.innerSpacing / 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFieldLabelWrapper(
                                  labelText: lang.thumbnail,
                                  inputField: DottedBorderContainer(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (isModState) {
                                          pickImage(ImageSelectType.thumbnail);
                                        }
                                      },
                                      child: thumbnailPath == null
                                          ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.camera_alt_outlined,
                                                  color: _theme.colorScheme.onTertiary,
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
                                const SizedBox(width: 100),
                                TextFieldLabelWrapper(
                                  labelText: lang.image,
                                  inputField: DottedBorderContainer(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (isModState) {
                                          pickImage(ImageSelectType.image);
                                        }
                                      },
                                      child: imagePath == null
                                          ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.camera_alt_outlined,
                                                  color: _theme.colorScheme.onTertiary,
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
                              ],
                            )),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: _sizeInfo.innerSpacing), // 간격 추가
                Padding(
                  padding: EdgeInsets.all(_sizeInfo.innerSpacing),
                  child: Align(
                    alignment: Alignment.centerLeft, // 버튼을 가운데 정렬
                    child: SizedBox(
                        width: 1000,
                        child: Row(
                          children: [
                            CustomButton(
                                textTheme: _textTheme,
                                label: lang.modItem,
                                onPressed: () => {
                                      if (isModState)
                                        {
                                          modItem(item),
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
                                          _theme.colorScheme.primaryContainer,
                                      textStyle: _textTheme.bodySmall?.copyWith(
                                          color: AcnooAppColors.kError),
                                      side: const BorderSide(
                                          color: AcnooAppColors.kError)),
                                  onPressed: () {
                                    setState(() {
                                      isModState = false;
                                      setData(item);
                                    });

                                  },
                                  label: Text(
                                    lang.cancel,
                                    //'Cancel',
                                    style: _textTheme.bodySmall?.copyWith(
                                        color: AcnooAppColors.kError),
                                  ),
                                ))
                          ],
                        )),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
