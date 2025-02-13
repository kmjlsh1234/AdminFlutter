// 🐦 Flutter imports:
import 'dart:io';

import 'package:acnoo_flutter_admin_panel/app/core/constants/file/file_category.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../core/constants/file/file_type.dart';
import '../../../core/constants/shop/item_unit/item_unit_type.dart';
import '../../../core/error/error_code.dart';
import '../../../core/service/file/file_service.dart';
import '../../../core/service/shop/item_unit/item_unit_service.dart';
import '../../../core/theme/_app_colors.dart';
import '../../../models/shop/item_unit/item_unit.dart';
import '../../../models/shop/item_unit/item_unit_add_param.dart';

class AddItemUnitDialog extends StatefulWidget {
  const AddItemUnitDialog({super.key});

  @override
  State<AddItemUnitDialog> createState() => _AddItemUnitDialogState();
}

class _AddItemUnitDialogState extends State<AddItemUnitDialog> {
  final ImagePicker picker = ImagePicker();
  final FileService fileService = FileService();
  final ItemUnitService itemUnitService = ItemUnitService();
  final TextEditingController skuController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController attributeController = TextEditingController();

  String selectType = ItemUnitType.CONSUMABLE.type;

  List<String> get _types => ItemUnitType.values.map((e) => e.type).toList();
  String? imagePath;
  XFile? selectFile;

  //이미지 로컬에서 가져오기
  Future<void> pickImage(BuildContext context) async {
    try{
      XFile? pickFile = await picker.pickImage(source: ImageSource.gallery);
      if(pickFile!= null){
        setState(() {
          selectFile = pickFile;
          imagePath = pickFile.path;
        });
      }
    } catch (e){
      ErrorHandler.handleError(ErrorCode.FAIL_TO_CONVERT_FILE, context);
    }
  }

  //아이템 유닛 추가
  Future<void> addItemUnit(BuildContext context) async {
    try{
      if(selectFile == null){
        throw CustomException(ErrorCode.FAIL_TO_CONVERT_FILE);
      }
      Uint8List? bytes = await selectFile?.readAsBytes();
      MultipartFile multipartFile = MultipartFile.fromBytes(bytes!, filename: selectFile!.name);
      FormData formData = FormData.fromMap({"file": multipartFile});
      String remotePath = await fileService.uploadFile(FileCategory.PROFILE, FileType.IMAGE, formData);

      ItemUnitAddParam itemUnitAddParam = ItemUnitAddParam(
        skuController.text,
        nameController.text,
        remotePath,
        descController.text,
        attributeController.text,
        selectType
      );

      ItemUnit itemUnit = await itemUnitService.addItemUnit(itemUnitAddParam);
      showAddItemUnitSuccessDialog(context);

    } catch(e){
      ErrorHandler.handleError(ErrorCode.FAIL_TO_CONVERT_FILE, context);
    }
  }

  void showAddItemUnitSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: Text('아이템 유닛 추가 성공'),
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
    return AlertDialog(
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
                    Text(lang.image, style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    DottedBorderContainer(
                      child: GestureDetector(
                        onTap: () => pickImage(context),
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
                    const SizedBox(height: 16),

                    ///---------------- Text Field section
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
                    Text(lang.attributes, style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: attributeController,
                      decoration: InputDecoration(
                        //hintText: 'Write Something',
                          hintText: lang.writeSomething,
                          hintStyle: textTheme.bodySmall),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    Text(lang.type, style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      dropdownColor: theme.colorScheme.primaryContainer,
                      value: selectType,
                      hint: Text(
                        lang.type,
                        //'Select Type',
                        style: textTheme.bodySmall,
                      ),
                      items: _types.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectType = value??ItemUnitType.CONSUMABLE.type;
                        });
                      },
                      validator: (value) =>
                          value == null ? lang.pleaseSelectAPosition : null,
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
                            onPressed: () => addItemUnit(context),
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
