// 🐦 Flutter imports:
// 📦 Package imports:
import 'package:acnoo_flutter_admin_panel/app/constants/shop/product/product_type.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../../generated/l10n.dart' as l;
// 🌎 Project imports:
import '../../../constants/file/file_category.dart';
import '../../../constants/file/file_type.dart';
import '../../../constants/shop/item/image_select_type.dart';
import '../../../constants/shop/product/product_option_type.dart';
import '../../../core/error/error_code.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/service/file/file_service.dart';
import '../../../core/service/shop/product/product_service.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/shop/product/product/product.dart';
import '../../../models/shop/product/product/product_mod_param.dart';
import '../../../models/shop/product/product_option/product_option_model.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';
import '../../../widgets/textfield_wrapper/_textfield_wrapper.dart';
import '../../common_widget/custom_button.dart';
import '../../common_widget/dotted_borderer_container.dart';
import 'component/product_option_widget.dart';

class ProductInfoView extends StatefulWidget {
  const ProductInfoView({super.key, required this.productId});
  final int productId;

  @override
  State<ProductInfoView> createState() => _ProductInfoViewState();
}

class _ProductInfoViewState extends State<ProductInfoView> {

  //State Manage
  bool isModState = false;

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
  final FileService fileService = FileService();

  //Future Model
  late Future<Product> product;

  //File
  final ImagePicker picker = ImagePicker();
  String? thumbnailPath;
  String? imagePath;
  XFile? imageFile;
  XFile? thumbnailFile;


  //상품 단일 조회
  Future<Product> getProduct() async {
    try {
      return productService.getProduct(widget.productId);
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  //상품 정보 추가 OR 변경
  Future<void> modProduct(Product currentProduct) async {
    try {
      //TODO: 입력 파라미터 검사
      checkModParameter();

      //TODO: 파일 서버에 파일 전송 후 경로 받기
      String? remoteThumbnailPath;
      String? remoteImagePath;

      if (thumbnailPath != null && (thumbnailPath != currentProduct.thumbnail)) {
        remoteThumbnailPath = await fileService.uploadFileTest(thumbnailFile, FileCategory.profile, FileType.image);
      }

      if (imagePath != null && (imagePath != currentProduct.image)) {
        remoteImagePath = await fileService.uploadFileTest(imageFile, FileCategory.profile, FileType.image);
      }

      //TODO: ADMIN서버에 상품 추가
      ProductModParam productModParam = getProductModParam(remoteThumbnailPath, remoteImagePath);
      Product product = await productService.modProduct(widget.productId, productModParam);
      showSuccessDialog(context);
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

  ProductModParam getProductModParam(String? thumbnail, String? image) {
    return ProductModParam(
        name: nameController.text,
        description: descController.text,
        thumbnail: thumbnail,
        image: image,
        info: infoController.text,
        type: productType.value,
        stockQuantity: int.tryParse(stockQuantityController.text),
        price: int.parse(priceController.text),
        originPrice: int.parse(originPriceController.text)
    );
  }

  //상품 변경 파라미터 검사
  void checkModParameter() {
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

  void setData(Product product) {
    nameController.text = product.name;
    descController.text = product.description;
    infoController.text = product.info;
    stockQuantityController.text = product.stockQuantity?.toString() ?? '';
    priceController.text = product.price.toString();
    originPriceController.text = product.originPrice.toString();
    productType = ProductType.fromValue(product.type);
    thumbnailPath = product.thumbnail;
    imagePath = product.image;
  }

  @override
  void initState() {
    super.initState();
    product = getProduct();
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

    final ThemeData _theme = Theme.of(context);
    final _textTheme = Theme.of(context).textTheme;
    final _sizeInfo = SizeConfig.getSizeInfo(context);
    final l.S lang = l.S.of(context);

    return FutureBuilder<Product>(
        future: product,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final product = snapshot.data!;
          setData(product);

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

                      //PRICE
                      ResponsiveGridCol(
                        lg: _lg,
                        md: _md,
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(
                              _sizeInfo.innerSpacing / 2),
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return TextFieldLabelWrapper(
                                labelText: lang.price,
                                inputField: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  enabled: isModState,
                                  controller: priceController,
                                  decoration: InputDecoration(
                                    hintText: lang.price,
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

                      //ORIGIN PRICE
                      ResponsiveGridCol(
                        lg: _lg,
                        md: _md,
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(
                              _sizeInfo.innerSpacing / 2),
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return TextFieldLabelWrapper(
                                labelText: lang.originPrice,
                                inputField: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  enabled: isModState,
                                  controller: originPriceController,
                                  decoration: InputDecoration(
                                    hintText: lang.originPrice,
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

                      //PRODUCT TYPE
                      ResponsiveGridCol(
                        lg: _lg,
                        md: _md,
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(
                              _sizeInfo.innerSpacing / 2),
                          child: TextFieldLabelWrapper(
                            labelText: lang.type,
                            inputField: DropdownButtonFormField<ProductType>(
                              dropdownColor:
                                  _theme.colorScheme.primaryContainer,
                              value: productType,
                              hint: Text(
                                lang.type,
                                style: _textTheme.bodySmall,
                              ),
                              decoration: InputDecoration(
                                filled: !isModState,
                                fillColor: isModState
                                    ? _theme.colorScheme.tertiaryContainer
                                    : Colors.grey.shade300,
                              ),
                              items: ProductType.values.map((type) {
                                return DropdownMenuItem<ProductType>(
                                  enabled: isModState,
                                  value: type,
                                  child: Text(type.value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  if (isModState) {
                                    productType = value!;
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

                      // EMPTY
                      ResponsiveGridCol(
                        lg: _lg,
                        md: _md,
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(
                              _sizeInfo.innerSpacing / 2),
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
                            modProduct(product);
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

                ProductOptionWidget(productId: widget.productId),
              ],
            ),
          );
        });
  }

  void buildProductOptionField(List<ProductOptionModel> optionList) {
    TextEditingController optionNameController = TextEditingController();
    TextEditingController optionQuantityController = TextEditingController();
    ProductOptionType type = ProductOptionType.diamond;
    optionList.add(
        ProductOptionModel(
            nameController: optionNameController,
            quantityController: optionQuantityController,
            type: type
        )
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: Text('상품 변경 성공'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
