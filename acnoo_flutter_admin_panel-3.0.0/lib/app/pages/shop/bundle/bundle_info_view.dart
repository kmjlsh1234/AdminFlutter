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
import '../../../core/helpers/field_styles/_input_field_styles.dart';
import '../../../core/service/file/file_service.dart';
import '../../../core/service/shop/bundle/bundle_service.dart';
import '../../../core/static/_static_values.dart';
import '../../../core/theme/_app_colors.dart';
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

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

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
        remoteThumbnailPath = await fileService.uploadFileTest(thumbnailFile, FileCategory.PROFILE, FileType.IMAGE);
      }

      if (imagePath != null && (imagePath != currentBundle.image)) {
        remoteImagePath = await fileService.uploadFileTest(imageFile, FileCategory.PROFILE, FileType.IMAGE);
      }

      //TODO: ADMIN서버에 번들 변경
      BundleModParam bundleModParam = getBundleModParam(currentBundle, remoteThumbnailPath, remoteImagePath);
      Bundle bundle = await bundleService.modBundle(widget.bundleId, bundleModParam);
      AlertUtil.successDialog(
          context: context,
          message: lang.successModBundle,
          buttonText: lang.confirm,
          onPressed: () {
            setState(() {
              GoRouter.of(context).pop();
              this.bundle = getBundle();
              isModState = false;
            });
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
            case ImageSelectType.THUMBNAIL:
              thumbnailFile = pickFile;
              thumbnailPath = pickFile.path;
              break;
            case ImageSelectType.IMAGE:
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
        saleStartDate: CompareUtil.compareStringValue(DateUtil.convertDateTimeToString(bundle.saleStartDate), saleStartDateController.text),
        saleEndDate: CompareUtil.compareStringValue(DateUtil.convertDateTimeToString(bundle.saleEndDate), saleEndDateController.text),
        currencyType: (bundle.currencyType == currencyType) ? null : currencyType,
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
    saleStartDateController.text = DateUtil.convertDateTimeToString(bundle.saleStartDate);
    saleEndDateController.text = DateUtil.convertDateTimeToString(bundle.saleEndDate);
    amountController.text = bundle.amount.toString();
    originAmountController.text = bundle.originAmount.toString();
    stockQuantityController.text = bundle.stockQuantity?.toString() ?? '';
    currencyType = bundle.currencyType;
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

    final AcnooInputFieldStyles _inputFieldStyle = AcnooInputFieldStyles(context);
    theme = Theme.of(context);
    textTheme = Theme.of(context).textTheme;
    final _sizeInfo = SizeConfig.getSizeInfo(context);
    lang = l.S.of(context);

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
                              enabled: isModState,
                              controller: nameController,
                              decoration: InputDecoration(
                                  filled: !isModState,
                                  fillColor: theme.colorScheme.tertiaryContainer,
                                  hintText: lang.hintName
                              ),
                              validator: (value) => value?.isEmpty ?? true ? lang.invalidName : null,
                              autovalidateMode: AutovalidateMode.onUnfocus,
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
                              enabled: isModState,
                              controller: skuController,
                              decoration: InputDecoration(
                                  filled: !isModState,
                                  fillColor: theme.colorScheme.tertiaryContainer,
                                  hintText: lang.hintSku
                              ),
                              validator: (value) => value?.isEmpty ?? true ? lang.invalidSku : null,
                              autovalidateMode: AutovalidateMode.onUnfocus,
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
                              enabled: isModState,
                              maxLines: 2,
                              controller: descController,
                              decoration: InputDecoration(
                                  filled: !isModState,
                                  fillColor: theme.colorScheme.tertiaryContainer,
                                hintText: lang.hintDescription
                              ),
                              validator: (value) => value?.isEmpty ?? true ? lang.invalidDescription : null,
                              autovalidateMode: AutovalidateMode.onUnfocus,
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
                              enabled: isModState,
                              maxLines: 2,
                              controller: infoController,
                              decoration: InputDecoration(
                                filled: !isModState,
                                fillColor: theme.colorScheme.tertiaryContainer,
                                hintText: lang.hintInfo,
                              ),
                              validator: (value) => value?.isEmpty ?? true ? lang.invalidInfo : null,
                              autovalidateMode: AutovalidateMode.onUnfocus,
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
                                  enabled: isModState,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: countPerPersonController,
                                  decoration:
                                  InputDecoration(
                                      filled: !isModState,
                                      fillColor: theme.colorScheme.tertiaryContainer,
                                      hintText: lang.hintCountPerPerson
                                  ),
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
                              enabled: isModState,
                              controller: saleStartDateController,
                              keyboardType: TextInputType.visiblePassword,
                              readOnly: true,
                              selectionControls: EmptyTextSelectionControls(),
                              decoration: InputDecoration(
                                filled: !isModState,
                                fillColor: theme.colorScheme.tertiaryContainer,
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

                                if (_result != null) {
                                  saleStartDateController.text = DateFormat(
                                      DateUtil.localDateTimeFormat)
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
                              enabled: isModState,
                              controller: saleEndDateController,
                              keyboardType: TextInputType.visiblePassword,
                              readOnly: true,
                              selectionControls: EmptyTextSelectionControls(),
                              decoration: InputDecoration(
                                filled: !isModState,
                                fillColor: theme.colorScheme.tertiaryContainer,
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

                                if (_result != null) {
                                  saleEndDateController.text = DateFormat(
                                      DateUtil.localDateTimeFormat)
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
                              dropdownColor: theme.colorScheme.primaryContainer,
                              value: currencyType,
                              decoration: InputDecoration(
                                filled: !isModState,
                                fillColor: theme.colorScheme.tertiaryContainer,
                              ),
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
                                  enabled: isModState,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: amountController,
                                  decoration:
                                  InputDecoration(
                                      filled: !isModState,
                                      fillColor: theme.colorScheme.tertiaryContainer,
                                      hintText: lang.hintAmount
                                  ),
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
                                  enabled: isModState,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: originAmountController,
                                  decoration:
                                  InputDecoration(
                                      filled: !isModState,
                                      fillColor: theme.colorScheme.tertiaryContainer,
                                      hintText: lang.hintOriginAmount
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
                          padding:
                          EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return TextFieldLabelWrapper(
                                labelText: lang.stockQuantity,
                                inputField: TextFormField(
                                  enabled: isModState,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: stockQuantityController,
                                  decoration:
                                  InputDecoration(
                                      filled: !isModState,
                                      fillColor: theme.colorScheme.tertiaryContainer,
                                      hintText: lang.hintStockQuantity
                                  ),
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
                                      onTap: () {
                                        if(isModState){
                                          pickImage(ImageSelectType.IMAGE);
                                        }
                                      },
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

                                const SizedBox(width: 100),

                                TextFieldLabelWrapper(
                                  labelText: lang.image,
                                  inputField: DottedBorderContainer(
                                    child: GestureDetector(
                                      onTap: () {
                                        if(isModState){
                                          pickImage(ImageSelectType.IMAGE);
                                        }
                                      },
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
                        width: 1000,
                        child: Row(
                          children: [
                            CustomButton(
                                textTheme: textTheme,
                                label: lang.modBundle,
                                onPressed: () => {
                                  if (isModState)
                                    {
                                      modBundle(bundle),
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
                                      setData(bundle);
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
    CurrencyType currencyType = CurrencyType.DIAMOND;
    TextEditingController countController = TextEditingController();
    bundleCurrencyList.add(
        BundleCurrencyModel(
            currencyType: currencyType,
            countController: countController
        )
    );
  }
}
