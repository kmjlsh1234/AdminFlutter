// 🐦 Flutter imports:
// 📦 Package imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/alert_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/compare_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/shop/bundle/component/bundle_currency_widget.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/shop/bundle/component/bundle_item_widget.dart';
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
import '../../../core/service/shop/bundle/bundle_service.dart';
import '../../../core/static/_static_values.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/shop/bundle/bundle/bundle.dart';
import '../../../models/shop/bundle/bundle/bundle_mod_param.dart';
import '../../../models/shop/bundle/bundle_currency/bundle_currency_model.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';
import '../../../widgets/textfield_wrapper/_textfield_wrapper.dart';
import '../../common_widget/custom_button.dart';
import '../../common_widget/dotted_borderer_container.dart';

class BundleInfoView extends StatefulWidget {
  const BundleInfoView({super.key, required this.bundleId});
  final int bundleId;

  @override
  State<BundleInfoView> createState() => _BundleInfoViewState();
}

class _BundleInfoViewState extends State<BundleInfoView> {

  //State Manage
  bool isModState = false;

  //Input Controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController skuController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController infoController = TextEditingController();
  final TextEditingController countPerPersonController = TextEditingController();
  final TextEditingController saleStartDateController = TextEditingController();
  final TextEditingController saleEndDateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController originAmountController = TextEditingController();
  final TextEditingController stockQuantityController = TextEditingController();

  //DropDown Menu
  late CurrencyType currencyType;

  //Service
  final BundleService bundleService = BundleService();
  final FileService fileService = FileService();

  //Future Model
  late Future<Bundle> bundle;
  
  //File
  final ImagePicker picker = ImagePicker();
  String? thumbnailPath;
  String? imagePath;
  XFile? imageFile;
  XFile? thumbnailFile;


  //번들 단일 조회
  Future<Bundle> getBundle() async {
    try {
      Bundle bundle = await bundleService.getBundle(widget.bundleId);
      setData(bundle);
      return bundle;
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }
  
  //번들 정보 변경
  Future<void> modBundle(Bundle currentBundle) async {
    try {
      //TODO: 입력 파라미터 검사
      checkModParameter();

      //TODO: 파일 서버에 파일 전송 후 경로 받기
      String remoteThumbnailPath = currentBundle.thumbnail;
      String remoteImagePath = currentBundle.image;

      if (thumbnailPath != null && (thumbnailPath != currentBundle.thumbnail)) {
        remoteThumbnailPath = await fileService.uploadFileTest(thumbnailFile, FileCategory.profile, FileType.image);
      }

      if (imagePath != null && (imagePath != currentBundle.image)) {
        remoteImagePath = await fileService.uploadFileTest(imageFile, FileCategory.profile, FileType.image);
      }

      //TODO: ADMIN서버에 번들 변경
      BundleModParam bundleModParam = getBundleModParam(currentBundle, remoteThumbnailPath, remoteImagePath);
      Bundle bundle = await bundleService.modBundle(widget.bundleId, bundleModParam);
      AlertUtil.viewSuccessDialog(context, '번들 변경 성공');
      setState(() {
        isModState = false;
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

  BundleModParam getBundleModParam(Bundle bundle, String thumbnail, String image) {

    return BundleModParam(
        name: CompareUtil.compareStringValue(bundle.name, nameController.text),
        sku: CompareUtil.compareStringValue(bundle.sku, skuController.text),
        description: CompareUtil.compareStringValue(bundle.description, descController.text),
        thumbnail: CompareUtil.compareStringValue(bundle.thumbnail, thumbnail),
        image: CompareUtil.compareStringValue(bundle.image, image),
        info: CompareUtil.compareStringValue(bundle.info, infoController.text),
        countPerPerson: CompareUtil.compareIntValue(bundle.countPerPerson, int.tryParse(countPerPersonController.text)),
        saleStartDate: CompareUtil.compareStringValue(DateUtil.convertDateTimeToLocalDateTime(bundle.saleStartDate), saleStartDateController.text),
        saleEndDate: CompareUtil.compareStringValue(DateUtil.convertDateTimeToLocalDateTime(bundle.saleEndDate), saleEndDateController.text),
        currencyType: CompareUtil.compareStringValue(bundle.currencyType, currencyType.value),
        amount: CompareUtil.compareIntValue(bundle.amount, int.tryParse(amountController.text)),
        originAmount: CompareUtil.compareIntValue(bundle.originAmount, int.tryParse(originAmountController.text)),
        stockQuantity: CompareUtil.compareIntValue(bundle.stockQuantity, int.tryParse(stockQuantityController.text)),
    );
  }

  //상품 변경 파라미터 검사
  void checkModParameter() {
    if (nameController.text.isEmpty) {
      throw CustomException(ErrorCode.PRODUCT_NAME_EMPTY);
    }

    if (skuController.text.isEmpty) {
      throw CustomException(ErrorCode.PRODUCT_NAME_EMPTY);
    }

    if (descController.text.isEmpty) {
      throw CustomException(ErrorCode.PRODUCT_DESC_EMPTY);
    }

    if (infoController.text.isEmpty) {
      throw CustomException(ErrorCode.PRODUCT_INFO_EMPTY);
    }

    if (amountController.text.isEmpty) {
      throw CustomException(ErrorCode.PRODUCT_ORIGIN_PRICE_EMPTY);
    }

    if (originAmountController.text.isEmpty) {
      throw CustomException(ErrorCode.PRODUCT_ORIGIN_PRICE_EMPTY);
    }

    if (thumbnailPath == null) {
      throw CustomException(ErrorCode.PRODUCT_THUMBNAIL_EMPTY);
    }

    if (imagePath == null) {
      throw CustomException(ErrorCode.PRODUCT_IMAGE_EMPTY);
    }
  }

  void setData(Bundle bundle) {
    nameController.text = bundle.name;
    skuController.text = bundle.sku;
    descController.text = bundle.description;
    infoController.text = bundle.info;
    countPerPersonController.text = bundle.countPerPerson?.toString() ?? '';
    saleStartDateController.text = DateUtil.convertDateTimeToLocalDateTime(bundle.saleStartDate) ?? '';
    saleEndDateController.text = DateUtil.convertDateTimeToLocalDateTime(bundle.saleEndDate) ?? '';
    amountController.text = bundle.amount.toString();
    originAmountController.text = bundle.originAmount.toString();
    stockQuantityController.text = bundle.stockQuantity?.toString() ?? '';
    currencyType = CurrencyType.fromValue(bundle.currencyType);
    thumbnailPath = bundle.thumbnail;
    imagePath = bundle.image;
  }

  @override
  void initState() {
    super.initState();
    bundle = getBundle();
  }

  @override
  void dispose() {
    nameController.dispose();
    skuController.dispose();
    descController.dispose();
    infoController.dispose();
    countPerPersonController.dispose();
    saleStartDateController.dispose();
    saleEndDateController.dispose();
    amountController.dispose();
    originAmountController.dispose();
    stockQuantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const _lg = 4;
    const _md = 6;

    final AcnooDropdownStyle _dropdownStyle = AcnooDropdownStyle(context);
    final AcnooInputFieldStyles _inputFieldStyle = AcnooInputFieldStyles(context);
    final ThemeData _theme = Theme.of(context);
    final _textTheme = Theme.of(context).textTheme;
    final _sizeInfo = SizeConfig.getSizeInfo(context);
    final l.S lang = l.S.of(context);

    return FutureBuilderFactory.createFutureBuilder(
        future: bundle,
        onSuccess: (context, bundle){
          return Scaffold(
            body: ListView(
              padding: _sizeInfo.padding,
              children: [
                // Input Example
                ShadowContainer(
                  headerText: lang.bundle,
                  child: ResponsiveGridRow(
                    children: [

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

                      // COUNT PER PERSON
                      ResponsiveGridCol(
                        lg: _lg,
                        md: _md,
                        child: Padding(
                          padding:
                          EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return TextFieldLabelWrapper(
                                labelText: lang.countPerPerson,
                                inputField: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: countPerPersonController,
                                  decoration:
                                  InputDecoration(hintText: lang.countPerPerson),
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

                      //SALE START DATE
                      ResponsiveGridCol(
                        lg: _lg,
                        md: _md,
                        child: Padding(
                          padding:
                          EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                          child: TextFieldLabelWrapper(
                            labelText: lang.startDate,
                            inputField: TextFormField(
                              controller: saleStartDateController,
                              keyboardType: TextInputType.visiblePassword,
                              readOnly: true,
                              selectionControls: EmptyTextSelectionControls(),
                              decoration: InputDecoration(
                                hintText: 'mm/dd/yyyy',
                                suffixIcon:
                                const Icon(IconlyLight.calendar, size: 20),
                                suffixIconConstraints:
                                _inputFieldStyle.iconConstraints,
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
                                  saleStartDateController.text = DateFormat(
                                      AppDateConfig.localDateTimeFormat)
                                      .format(_result);
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      //SALE END DATE
                      ResponsiveGridCol(
                        lg: _lg,
                        md: _md,
                        child: Padding(
                          padding:
                          EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                          child: TextFieldLabelWrapper(
                            labelText: lang.endDate,
                            inputField: TextFormField(
                              controller: saleEndDateController,
                              keyboardType: TextInputType.visiblePassword,
                              readOnly: true,
                              selectionControls: EmptyTextSelectionControls(),
                              decoration: InputDecoration(
                                hintText: 'mm/dd/yyyy',
                                suffixIcon:
                                const Icon(IconlyLight.calendar, size: 20),
                                suffixIconConstraints:
                                _inputFieldStyle.iconConstraints,
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
                                  saleEndDateController.text = DateFormat(
                                      AppDateConfig.localDateTimeFormat)
                                      .format(_result);
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      //CURRENCY TYPE
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
                                  decoration:
                                  InputDecoration(hintText: lang.amount),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // ORIGIN AMOUNT
                      ResponsiveGridCol(
                        lg: _lg,
                        md: _md,
                        child: Padding(
                          padding:
                          EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return TextFieldLabelWrapper(
                                labelText: lang.originAmount,
                                inputField: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: originAmountController,
                                  decoration:
                                  InputDecoration(hintText: lang.originAmount),
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

                SizedBox(height: _sizeInfo.innerSpacing), //간격 추가

                Padding(
                  padding: EdgeInsets.all(_sizeInfo.innerSpacing),
                  child: Align(
                    alignment: Alignment.centerLeft, // 버튼을 가운데 정렬
                    child: SizedBox(
                      width: 200, // 버튼 너비를 200px로 제한 (원하는 크기로 조정 가능)
                      child: CustomButton(
                        textTheme: _textTheme,
                        label: lang.modProduct,
                        onPressed: () {
                          if (isModState) {
                            modBundle(bundle);
                          } else {
                            setState(() {
                              isModState = true;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: _sizeInfo.innerSpacing),

                BundleCurrencyWidget(bundleId: widget.bundleId),

                SizedBox(height: _sizeInfo.innerSpacing),

                BundleItemWidget(bundleId: widget.bundleId),
              ],
            ),
          );
        });

  }

  void buildBundleCurrencyField(List<BundleCurrencyModel> bundleCurrencyList) {
    CurrencyType currencyType = CurrencyType.diamond;
    TextEditingController countController = TextEditingController();
    bundleCurrencyList.add(
        BundleCurrencyModel(
            currencyType: currencyType,
            countController: countController
        )
    );
  }
}
