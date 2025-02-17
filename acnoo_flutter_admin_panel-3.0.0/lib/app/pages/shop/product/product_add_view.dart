// 🐦 Flutter imports:
// 📦 Package imports:
import 'package:acnoo_flutter_admin_panel/app/constants/shop/product/product_type.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/shop/product/product_option_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../../generated/l10n.dart' as l;
// 🌎 Project imports:
import '../../../constants/file/file_category.dart';
import '../../../constants/file/file_type.dart';
import '../../../constants/shop/item/image_select_type.dart';
import '../../../core/error/error_code.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/helpers/field_styles/_dropdown_styles.dart';
import '../../../core/helpers/field_styles/_input_field_styles.dart';
import '../../../core/service/file/file_service.dart';
import '../../../core/service/shop/product/product_service.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/shop/product/product/product.dart';
import '../../../models/shop/product/product/product_add_param.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';
import '../../../widgets/textfield_wrapper/_textfield_wrapper.dart';
import '../../common_widget/custom_button.dart';
import '../../common_widget/dotted_borderer_container.dart';

class ProductAddView extends StatefulWidget {
  const ProductAddView({super.key});

  @override
  State<ProductAddView> createState() => _ProductAddViewState();
}

class _ProductAddViewState extends State<ProductAddView> {

  //Input Controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController infoController = TextEditingController();
  final TextEditingController stockQuantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController originPriceController = TextEditingController();

  //DropDown Menu
  ProductType productType = ProductType.currency;

  //Service
  final ProductService productService = ProductService();
  final ProductOptionService productOptionService = ProductOptionService();
  final FileService fileService = FileService();

  //File
  final ImagePicker picker = ImagePicker();
  String? thumbnailPath;
  String? imagePath;
  XFile? imageFile;
  XFile? thumbnailFile;

  //상품 추가
  Future<void> addProduct() async {
    try {
      //TODO: 입력 파라미터 검사
      checkAddParameter();

      //TODO: 파일 서버에 파일 전송 후 경로 받기
      String thumbnailPath = await uploadFile(thumbnailFile!);
      String imagePath = await uploadFile(imageFile!);

      //TODO: ADMIN서버에 상품 추가
      Product product = await productService.addProduct(getProductAddParam(thumbnailPath, imagePath));
      showSuccessDialog(context);
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  //파일 업로드
  Future<String> uploadFile(XFile file) async {
    Uint8List? bytes = await file.readAsBytes();
    MultipartFile multipartFile = MultipartFile.fromBytes(bytes, filename: file.name);
    FormData formData = FormData.fromMap({"file": multipartFile});
    String remotePath = await fileService.uploadFile(
        FileCategory.profile, FileType.image, formData);
    return remotePath;
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

  ProductAddParam getProductAddParam(String thumbnail, String image) {
    int? stockQuantity = stockQuantityController.text.isNotEmpty ? int.parse(stockQuantityController.text) : null;
    return ProductAddParam(
        name: nameController.text,
        description: descController.text,
        thumbnail: thumbnail,
        image: image,
        info: infoController.text,
        type: productType.value,
        stockQuantity: stockQuantity,
        price: int.parse(priceController.text),
        originPrice: int.parse(originPriceController.text)
    );
  }

  //파라미터 검사
  void checkAddParameter() {
    if (nameController.text.isEmpty) {
      throw CustomException(ErrorCode.PRODUCT_NAME_EMPTY);
    }

    if (descController.text.isEmpty) {
      throw CustomException(ErrorCode.PRODUCT_DESC_EMPTY);
    }

    if (infoController.text.isEmpty) {
      throw CustomException(ErrorCode.PRODUCT_INFO_EMPTY);
    }

    if (priceController.text.isEmpty) {
      throw CustomException(ErrorCode.PRODUCT_PRICE_EMPTY);
    }

    if (originPriceController.text.isEmpty) {
      throw CustomException(ErrorCode.PRODUCT_ORIGIN_PRICE_EMPTY);
    }

    if (thumbnailPath == null) {
      throw CustomException(ErrorCode.PRODUCT_THUMBNAIL_EMPTY);
    }

    if (imagePath == null) {
      throw CustomException(ErrorCode.PRODUCT_IMAGE_EMPTY);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    infoController.dispose();
    stockQuantityController.dispose();
    priceController.dispose();
    originPriceController.dispose();
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

    return Scaffold(
      body: ListView(
        padding: _sizeInfo.padding,
        children: [
          // Input Example
          ShadowContainer(
            headerText: lang.product,
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

                //PRICE
                ResponsiveGridCol(
                  lg: _lg,
                  md: _md,
                  child: Padding(
                    padding:
                    EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return TextFieldLabelWrapper(
                          labelText: lang.price,
                          inputField: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: priceController,
                            decoration: InputDecoration(hintText: lang.price),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                //ORIGIN PRICE
                ResponsiveGridCol(
                  lg: _lg,
                  md: _md,
                  child: Padding(
                    padding:
                    EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return TextFieldLabelWrapper(
                          labelText: lang.originPrice,
                          inputField: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: originPriceController,
                            decoration: InputDecoration(hintText: lang.originPrice),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                //PRODUCT TYPE
                ResponsiveGridCol(
                  lg: _lg,
                  md: _md,
                  child: Padding(
                    padding:
                    EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      labelText: lang.type,
                      inputField: DropdownButtonFormField<ProductType>(
                        dropdownColor: _theme.colorScheme.primaryContainer,
                        value: productType,
                        hint: Text(
                          lang.type,
                          style: _textTheme.bodySmall,
                        ),
                        items: ProductType.values.map((type) {
                          return DropdownMenuItem<ProductType>(
                            value: type,
                            child: Text(type.value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            productType = value!;
                          });
                        },
                        validator: (value) =>
                        value == null ? lang.pleaseSelectAPosition : null,
                      ),
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

                // EMPTY
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
                  onPressed: () => addProduct(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: Text('아이템 추가 성공'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
