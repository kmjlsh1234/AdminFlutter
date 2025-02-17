// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../constants/file/file_category.dart';
import '../../../../constants/file/file_type.dart';
import '../../../../constants/shop/item_unit/item_unit_type.dart';
import '../../../../core/error/error_code.dart';
import '../../../../core/service/file/file_service.dart';
import '../../../../core/service/shop/item_unit/item_unit_service.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/alert_util.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/shop/item_unit/item_unit.dart';
import '../../../../models/shop/item_unit/item_unit_add_param.dart';
import '../../../common_widget/dotted_borderer_container.dart';

class AddItemUnitDialog extends StatefulWidget {
  const AddItemUnitDialog({super.key});

  @override
  State<AddItemUnitDialog> createState() => _AddItemUnitDialogState();
}

class _AddItemUnitDialogState extends State<AddItemUnitDialog> {

  final TextEditingController skuController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController attributeController = TextEditingController();
  final ItemUnitService itemUnitService = ItemUnitService();
  final FileService fileService = FileService();
  final ImagePicker picker = ImagePicker();

  ItemUnitType selectType = ItemUnitType.consumable;

  XFile? selectFile;
  String? imagePath;

  //이미지 로컬에서 가져오기
  Future<void> pickImage() async {
    try{
      XFile? pickFile = await picker.pickImage(source: ImageSource.gallery);

      if(pickFile == null){
        throw CustomException(ErrorCode.FAIL_TO_CONVERT_FILE);
      }

      setState(() {
        selectFile = pickFile;
        imagePath = pickFile.path;
      });
    } catch (e){
      ErrorHandler.handleError(e, context);
    }
  }

  //아이템 유닛 추가
  Future<void> addItemUnit() async {
    try{
      if(selectFile == null){
        throw CustomException(ErrorCode.FAIL_TO_CONVERT_FILE);
      }

      Uint8List? bytes = await selectFile?.readAsBytes();
      MultipartFile multipartFile = MultipartFile.fromBytes(bytes!, filename: selectFile!.name);
      FormData formData = FormData.fromMap({"file": multipartFile});
      String remotePath = await fileService.uploadFile(FileCategory.profile, FileType.image, formData);

      ItemUnitAddParam itemUnitAddParam = ItemUnitAddParam(
          sku: skuController.text,
          name:  nameController.text,
          image: remotePath,
          description: descController.text,
          attributes: attributeController.text,
          type: selectType.value
      );

      ItemUnit itemUnit = await itemUnitService.addItemUnit(itemUnitAddParam);
      AlertUtil.popupSuccessDialog(context, '아이템 유닛 추가 성공');
    } catch(e){
      ErrorHandler.handleError(ErrorCode.FAIL_TO_CONVERT_FILE, context);
    }
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    skuController.dispose();
    nameController.dispose();
    descController.dispose();
    attributeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _sizeInfo = SizeConfig.getSizeInfo(context);
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
                    onPressed: () => Navigator.of(context).pop(false),
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
                        onTap: () => pickImage(),
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
                    DropdownButtonFormField<ItemUnitType>(
                      dropdownColor: theme.colorScheme.primaryContainer,
                      value: selectType,
                      hint: Text(
                        lang.type,
                        //'Select Type',
                        style: textTheme.bodySmall,
                      ),
                      items: ItemUnitType.values.map((type) {
                        return DropdownMenuItem<ItemUnitType>(
                          value: type,
                          child: Text(type.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectType = value??ItemUnitType.consumable;
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
                            onPressed: () => Navigator.of(context).pop(false),
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
                            onPressed: () => addItemUnit(),
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
