// 🐦 Flutter imports:
// 📦 Package imports:
import 'package:acnoo_flutter_admin_panel/app/constants/shop/item/item_period_type.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/shop/category/category_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/shop/item/item_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/alert_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/shop/item/component/search_item_unit_popup.dart';
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
  final TextEditingController numController = TextEditingController();
  final TextEditingController stockQuantityController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController infoController = TextEditingController();
  final TextEditingController expirationController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController periodController = TextEditingController();

  //Service
  final CategoryService categoryService = CategoryService();
  final ItemService itemService = ItemService();
  final FileService fileService = FileService();

  //Future Model
  late Future<List<Category>> categoryList;

  //DropDown
  CurrencyType currencyType = CurrencyType.diamond;
  ItemPeriodType periodType = ItemPeriodType.none;
  late int categoryId;

  //File
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

  //아이템 추가
  Future<void> addItem() async {
    try {
      //TODO: 입력 파라미터 검사
      checkAddParameter();

      //TODO: 파일 서버에 파일 전송 후 경로 받기
      String thumbnailPath = await fileService.uploadFileTest(thumbnailFile, FileCategory.profile, FileType.image);
      String imagePath = await fileService.uploadFileTest(imageFile, FileCategory.profile, FileType.image);

      //TODO: ADMIN서버에 아이템 추가
      Item item = await itemService.addItem(getItemAddParam(thumbnailPath, imagePath));
      AlertUtil.popupSuccessDialog(context, '아이템 추가 성공');
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
            case ImageSelectType.thumbnail:
              thumbnailFile = pickFile;
              thumbnailPath = pickFile.path;
              break;
            case ImageSelectType.image:
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
    int? num = numController.text.isNotEmpty ? int.parse(numController.text) : null;
    int? stockQuantity = stockQuantityController.text.isNotEmpty ? int.parse(stockQuantityController.text) : null;
    int? period = periodController.text.isNotEmpty ? int.parse(periodController.text) : null;
    String? expiration = expirationController.text.isNotEmpty ? expirationController.text : null;

    return ItemAddParam(
        categoryId: categoryId,
        sku: skuController.text,
        unitSku: unitSkuController.text,
        name: nameController.text,
        description: descController.text,
        num: num,
        stockQuantity: stockQuantity,
        thumbnail: thumbnailPath,
        image: imagePath,
        info: infoController.text,
        periodType: periodType.value,
        period: period,
        expiration: expiration,
        currencyType: currencyType.value,
        amount: int.parse(amountController.text)
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

    if (expirationController.text.isNotEmpty) {
      DateTime selectDate = DateUtil.convertStringToDateTime(expirationController.text);
      if (selectDate.isBefore(DateTime.now())) {
        throw CustomException(ErrorCode.INVALID_EXPIRATION_PARAMETER);
      }
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

  @override
  void initState() {
    super.initState();
    categoryList = getAllCategoryList();
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
    final ThemeData _theme = Theme.of(context);
    final _textTheme = Theme.of(context).textTheme;
    final _sizeInfo = SizeConfig.getSizeInfo(context);
    final l.S lang = l.S.of(context);

    return Scaffold(
      body: ListView(
        padding: _sizeInfo.padding,
        children: [
          // Input Example
          ShadowContainer(
            // headerText: 'Input Example',
            headerText: lang.item,
            child: ResponsiveGridRow(
              children: [
                //SKU
                ResponsiveGridCol(
                  lg: _lg,
                  md: _md,
                  child: Padding(
                    padding:
                    EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      labelText: lang.sku,
                      inputField: TextFormField(
                        controller: skuController,
                        decoration: InputDecoration(hintText: lang.sku),
                      ),
                    ),
                  ),
                ),

                //NAME
                ResponsiveGridCol(
                  lg: _lg,
                  md: _md,
                  child: Padding(
                    padding:
                    EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      labelText: lang.name,
                      inputField: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(hintText: lang.name),
                      ),
                    ),
                  ),
                ),

                //UNIT SKU
                ResponsiveGridCol(
                  lg: _lg,
                  md: _md,
                  child: Padding(
                    padding:
                    EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      labelText: lang.itemUnitSku,
                      inputField: TextFormField(
                        readOnly: true,
                        controller: unitSkuController,
                        decoration: InputDecoration(
                          hintText: lang.itemUnitSku,
                          filled: true,
                          fillColor: _theme
                              .colorScheme.tertiaryContainer,
                          suffixIcon: IconButton(
                            icon: Icon(
                                Icons.search,
                                color: _theme.colorScheme.primary
                            ),
                            onPressed: () {
                              showSearchDialog(context);
                            },
                          ),
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
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: FutureBuilderFactory.createFutureBuilder(
                        future: categoryList,
                        onSuccess: (context, categoryList) {
                          return TextFieldLabelWrapper(
                            labelText: lang.category,
                            inputField: DropdownButtonFormField2(
                              menuItemStyleData: _dropdownStyle.menuItemStyle,
                              buttonStyleData: _dropdownStyle.buttonStyle,
                              iconStyleData: _dropdownStyle.iconStyle,
                              dropdownStyleData: _dropdownStyle.dropdownStyle,
                              hint: Text(lang.select),
                              items: List.generate(
                                categoryList.length,
                                (index) => DropdownMenuItem(
                                  value: categoryList[index].id,
                                  child: Text(categoryList[index].name),
                                ),
                              ),
                              onChanged: (value) {
                                categoryId = value!;
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
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
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
                            decoration: InputDecoration(hintText: lang.num),
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
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return TextFieldLabelWrapper(
                          labelText: lang.stockQuantity,
                          inputField: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: stockQuantityController,
                            decoration:
                                InputDecoration(hintText: lang.stockQuantity),
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
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      labelText: lang.description,
                      inputField: TextFormField(
                        maxLines: 2,
                        controller: descController,
                        decoration: InputDecoration(
                          hintText: lang.description,
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
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      labelText: lang.info,
                      inputField: TextFormField(
                        maxLines: 2,
                        controller: infoController,
                        decoration: InputDecoration(
                          hintText: lang.info,
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
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      labelText: lang.expiration,
                      inputField: TextFormField(
                        controller: expirationController,
                        keyboardType: TextInputType.visiblePassword,
                        readOnly: true,
                        selectionControls: EmptyTextSelectionControls(),
                        decoration: InputDecoration(
                          labelText: l.S.of(context).startDate,
                          labelStyle: _textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          hintText: 'yyyy-MM-ddTHH:mm:ss',//'mm/dd/yyyy',
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
                                    borderRadius: BorderRadius.circular(4),
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
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      labelText: lang.type,
                      inputField: DropdownButtonFormField<CurrencyType>(
                        dropdownColor: _theme.colorScheme.primaryContainer,
                        value: currencyType,
                        hint: Text(
                          lang.type,
                          //'Currency Type',
                          style: _textTheme.bodySmall,
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
                ResponsiveGridCol(
                  lg: _lg,
                  md: _md,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return TextFieldLabelWrapper(
                          labelText: lang.amount,
                          inputField: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: amountController,
                            decoration: InputDecoration(hintText: lang.amount),
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
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                  ),
                ),

                // PERIOD TYPE
                ResponsiveGridCol(
                  lg: _lg,
                  md: _md,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      labelText: lang.periodType,
                      inputField: DropdownButtonFormField<ItemPeriodType>(
                        dropdownColor: _theme.colorScheme.primaryContainer,
                        value: periodType,
                        hint: Text(
                          lang.type,
                          //'Currency Type',
                          style: _textTheme.bodySmall,
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

                periodType != ItemPeriodType.none ?
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
                                  controller: periodController,
                                  decoration:
                                      InputDecoration(hintText: lang.period),
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
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                  ),
                ),

                ResponsiveGridCol(
                  lg: _lg,
                  md: _md,
                  child: Padding(
                      padding:
                          EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFieldLabelWrapper(
                            labelText: lang.thumbnail,
                            inputField: DottedBorderContainer(
                              child: GestureDetector(
                                onTap: () => pickImage(ImageSelectType.thumbnail),
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
                                onTap: () => pickImage(ImageSelectType.image),
                                child: imagePath == null
                                    ? Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
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
                width: 200, // 버튼 너비를 200px로 제한 (원하는 크기로 조정 가능)
                child: CustomButton(
                  textTheme: _textTheme,
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

  void showSearchDialog(BuildContext context) async {
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
}
