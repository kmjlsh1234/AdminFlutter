// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/constants/file/file_category.dart';
import 'package:acnoo_flutter_admin_panel/app/core/constants/shop/item/image_select_type.dart';
import 'package:acnoo_flutter_admin_panel/app/core/constants/shop/item/item_period_type.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../core/constants/file/file_type.dart';
import '../../../core/constants/shop/item/currency_type.dart';
import '../../../core/constants/shop/item_unit/item_unit_type.dart';
import '../../../core/error/error_code.dart';
import '../../../core/service/file/file_service.dart';
import '../../../core/service/shop/category/category_service.dart';
import '../../../core/service/shop/item/item_service.dart';
import '../../../core/static/_static_values.dart';
import '../../../core/theme/_app_colors.dart';
import '../../../models/shop/category/category.dart';
import '../../../models/shop/item/item.dart';
import '../../../models/shop/item/item_add_param.dart';

class AddItemDialog extends StatefulWidget {
  const AddItemDialog({super.key});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final ImagePicker picker = ImagePicker();
  final FileService fileService = FileService();
  final ItemService itemService = ItemService();
  final CategoryService categoryService = CategoryService();

  final TextEditingController skuController = TextEditingController();
  final TextEditingController unitSkuController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController numController = TextEditingController();
  final TextEditingController stockQuantityController = TextEditingController();
  final TextEditingController infoController = TextEditingController();
  final TextEditingController periodController = TextEditingController();
  final TextEditingController expirationController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  int? categoryId;
  String currencyType = CurrencyType.CHIP.value;
  String periodType = ItemPeriodType.NONE.value;

  late List<Category> categoryList;
  List<String> get _currencyTypes => CurrencyType.values.map((e) => e.value).toList();
  List<String> get _periodTypes => ItemPeriodType.values.map((e) => e.value).toList();
  String? thumbnailPath;
  String? imagePath;
  XFile? imageFile;
  XFile? thumbnailFile;
  bool isLoading = true;

  //이미지 로컬에서 가져오기
  Future<void> pickImage(BuildContext context, ImageSelectType type) async {
    try{
      XFile? pickFile = await picker.pickImage(source: ImageSource.gallery);
      if(pickFile!= null){
        setState(() {
          switch(type){
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
    } catch (e){

      ErrorHandler.handleError(ErrorCode.FAIL_TO_CONVERT_FILE, context);
    }
  }

  //카테고리 목록 전부 조회
  Future<void> getAllCategoryList(BuildContext context) async {
    List<Category> list = [];
    setState(() {
      isLoading = true;
    });
    try{
      list = await categoryService.getAllCategoryList();
    } catch(e) {
      ErrorHandler.handleError(e, context);
    }
    setState(() {
      categoryList = list;
      categoryId = categoryList[0].id;
      isLoading = false;
    });
  }

  //아이템 추가
  Future<void> addItem(BuildContext context) async {
    try{
      String thumbnailPath = await uploadFile(thumbnailFile!);
      String imagePath = await uploadFile(imageFile!);

      ItemAddParam itemAddParam = ItemAddParam(
        categoryId!,
        skuController.text,
        unitSkuController.text,
        nameController.text,
        descController.text,
        int.tryParse(numController.text)??0,
        int.tryParse(stockQuantityController.text)??0,
        thumbnailPath,
        imagePath,
        infoController.text,
        periodType,
        int.tryParse(periodController.text)??0,
        expirationController.text,
        currencyType,
        int.tryParse(amountController.text)??0,
      );

      Item item = await itemService.addItem(itemAddParam);
      showAddItemSuccessDialog(context);

    } catch(e){
      ErrorHandler.handleError(e, context);
    }
  }

  Future<String> uploadFile(XFile file) async{
    Uint8List? bytes = await file.readAsBytes();
    MultipartFile multipartFile = MultipartFile.fromBytes(bytes, filename: file.name);
    FormData formData = FormData.fromMap({"file": multipartFile});
    String remotePath = await fileService.uploadFile(FileCategory.PROFILE, FileType.IMAGE, formData);
    return remotePath;
  }

  void showAddItemSuccessDialog(BuildContext context) {
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
                Navigator.of(context).pop(true);
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getAllCategoryList(context);
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 480,
          value: _SizeInfo(
            alertFontSize: 12,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 481,
          end: 576,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 577,
          end: 992,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;
    TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : AlertDialog(
      contentPadding: EdgeInsets.zero,
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///---------------- header section
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // const Text('Form Dialog'),
                  Text(lang.formDialog),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: AcnooAppColors.kError,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 0.1,
              color: theme.colorScheme.outline,
              height: 0,
            ),

            ///---------------- header section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 606,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///---------------- image section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(lang.thumbnail, style: textTheme.bodySmall),
                            const SizedBox(height: 8),
                            DottedBorderContainer(
                              child: GestureDetector(
                                onTap: () => pickImage(context, ImageSelectType.THUMBNAIL),
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
                                ) : ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      thumbnailPath!,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(lang.image, style: textTheme.bodySmall),
                            const SizedBox(height: 8),
                            DottedBorderContainer(
                              child: GestureDetector(
                                onTap: () => pickImage(context, ImageSelectType.IMAGE),
                                child: imagePath == null
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
                                ) : ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imagePath!,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    ///---------------- Text Field section

                    //---------------------1.SKU---------------------//
                    Text(lang.sku, style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: skuController,
                      decoration: InputDecoration(
                          hintText: lang.enterYourFullName,
                          hintStyle: textTheme.bodySmall),
                      validator: (value) => value?.isEmpty ?? true
                          ? lang.pleaseEnterYourFullName
                          : null,
                    ),

                    const SizedBox(height: 20),

                    //---------------------2.UNIT_SKU---------------------//
                    Text(lang.itemUnitSku, style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: unitSkuController,
                      decoration: InputDecoration(
                          hintText: lang.enterYourFullName,
                          hintStyle: textTheme.bodySmall),
                      validator: (value) => value?.isEmpty ?? true
                          ? lang.pleaseEnterYourFullName
                          : null,
                    ),

                    const SizedBox(height: 20),

                    //---------------------3.NAME---------------------//
                    Text(lang.fullName, style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                          hintText: lang.enterYourFullName,
                          hintStyle: textTheme.bodySmall),
                      validator: (value) => value?.isEmpty ?? true
                          ? lang.pleaseEnterYourFullName
                          : null,
                    ),

                    const SizedBox(height: 20),

                    //---------------------4.DESCRIPTION---------------------//
                    Text(lang.description, style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: descController,
                      decoration: InputDecoration(
                        //hintText: 'Write Something',
                          hintText: lang.writeSomething,
                          hintStyle: textTheme.bodySmall),
                      maxLines: 3,
                    ),

                    const SizedBox(height: 20),

                    //---------------------5.NUM---------------------//
                    Text(lang.num, style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: numController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [ FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          hintText: lang.enterYourFullName,
                          hintStyle: textTheme.bodySmall),
                      validator: (value) => value?.isEmpty ?? true
                          ? lang.pleaseEnterYourFullName
                          : null,
                    ),

                    const SizedBox(height: 20),

                    //---------------------6.STOCK_QUANTITY---------------------//
                    Text(lang.stockQuantity, style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [ FilteringTextInputFormatter.digitsOnly],
                      controller: stockQuantityController,
                      decoration: InputDecoration(
                          hintText: lang.enterYourFullName,
                          hintStyle: textTheme.bodySmall),
                      validator: (value) => value?.isEmpty ?? true
                          ? lang.pleaseEnterYourFullName
                          : null,
                    ),

                    const SizedBox(height: 20),

                    //---------------------7.INFO---------------------//
                    Text(lang.info, style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: infoController,
                      decoration: InputDecoration(
                        //hintText: 'Write Something',
                          hintText: lang.writeSomething,
                          hintStyle: textTheme.bodySmall),
                      maxLines: 3,
                    ),

                    const SizedBox(height: 20),

                    //---------------------8.PERIOD_TYPE---------------------//
                    Text(lang.periodType, style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      dropdownColor: theme.colorScheme.primaryContainer,
                      value: periodType,
                      hint: Text(
                        lang.periodType,
                        //'Select Type',
                        style: textTheme.bodySmall,
                      ),
                      items: _periodTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          periodType = value??ItemUnitType.CONSUMABLE.type;
                        });
                      },
                      validator: (value) =>
                      value == null ? lang.pleaseSelectAPosition : null,
                    ),

                    //---------------------9.PERIOD---------------------//
                    Visibility(
                      visible: periodType != ItemPeriodType.NONE.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(lang.period, style: textTheme.bodySmall),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: periodController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: lang.enterYourFullName,
                                hintStyle: textTheme.bodySmall),
                            validator: (value) => value?.isEmpty ?? true
                                ? lang.pleaseEnterYourFullName
                                : null,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    //---------------------10.EXPIRATION---------------------//
                    Text(lang.expiration, style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: expirationController,
                      keyboardType: TextInputType.visiblePassword,
                      readOnly: true,
                      selectionControls: EmptyTextSelectionControls(),
                      decoration: InputDecoration(
                        labelText: l.S.of(context).startDate,
                        labelStyle: textTheme.bodySmall?.copyWith(
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
                          expirationController.text = DateFormat(
                            //AppDateConfig.appNumberOnlyDateFormat,
                            AppDateConfig.localDateTimeFormat,
                          ).format(_result);
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    //---------------------11.TYPE---------------------//
                    Text(lang.type, style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      dropdownColor: theme.colorScheme.primaryContainer,
                      value: currencyType,
                      hint: Text(
                        lang.type,
                        //'Currency Type',
                        style: textTheme.bodySmall,
                      ),
                      items: _currencyTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          currencyType = value??CurrencyType.CHIP.value;
                        });
                      },
                      validator: (value) =>
                          value == null ? lang.pleaseSelectAPosition : null,
                    ),

                    const SizedBox(height: 20),

                    //---------------------12.Category---------------------//
                    Text(lang.category, style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      dropdownColor: theme.colorScheme.primaryContainer,
                      value: categoryId??0,
                      hint: Text(
                        lang.category,
                        style: textTheme.bodySmall,
                      ),
                      items: categoryList.map((category) {
                        return DropdownMenuItem<int>(
                          value: category.id??0,
                          child: Text(category.name??'NONE'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          categoryId = value??0;
                        });
                      },
                      validator: (value) =>
                      value == null ? lang.pleaseSelectAPosition : null,
                    ),

                    const SizedBox(height: 20),

                    //---------------------13.AMOUNT---------------------//
                    Text(lang.amount, style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [ FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          hintText: lang.enterYourFullName,
                          hintStyle: textTheme.bodySmall),
                      validator: (value) => value?.isEmpty ?? true
                          ? lang.pleaseEnterYourFullName
                          : null,
                    ),
                    const SizedBox(height: 24),

                    ///---------------- Submit Button section
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: _sizeInfo.innerSpacing),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: _sizeInfo.innerSpacing),
                                backgroundColor:
                                    theme.colorScheme.primaryContainer,
                                textStyle: textTheme.bodySmall
                                    ?.copyWith(color: AcnooAppColors.kError),
                                side: const BorderSide(
                                    color: AcnooAppColors.kError)),
                            onPressed: () => Navigator.pop(context),
                            label: Text(
                              lang.cancel,
                              //'Cancel',
                              style: textTheme.bodySmall
                                  ?.copyWith(color: AcnooAppColors.kError),
                            ),
                          ),
                          SizedBox(width: _sizeInfo.innerSpacing),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: _sizeInfo.innerSpacing),
                            ),
                            onPressed: () => addItem(context),
                            //label: const Text('Save'),
                            label: Text(lang.save),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SizeInfo {
  final double? alertFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  const _SizeInfo({
    this.alertFontSize = 18,
    this.padding = const EdgeInsets.all(24),
    this.innerSpacing = 24,
  });
}

// -------------------Dotted Border

class DottedBorderContainer extends StatelessWidget {
  final Widget child;

  const DottedBorderContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter:
          DottedBorderPainter(color: Theme.of(context).colorScheme.outline),
      child: Container(
        padding: const EdgeInsets.all(4),
        height: 120,
        width: 120,
        child: Center(child: child),
      ),
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  final Color color;

  DottedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const radius = Radius.circular(5.0);
    const rect = Rect.fromLTWH(0, 0, 120, 120);
    final rrect = RRect.fromRectAndRadius(rect, radius);

    final path = Path()..addRRect(rrect);

    const dashWidth = 4.0;
    const dashSpace = 4.0;

    double distance = 0.0;
    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      while (distance < pathMetric.length) {
        final start = distance;
        final end = distance + dashWidth;

        final lineSegment = pathMetric.extractPath(start, end);
        canvas.drawPath(lineSegment, paint);

        distance += dashWidth + dashSpace;
      }
      distance = 0.0; // Reset distance for the next segment
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
