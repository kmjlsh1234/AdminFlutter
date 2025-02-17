// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/item_unit/item_unit_mod_param.dart';
import 'package:flutter/material.dart';
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
import '../../../../core/utils/compare_util.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/shop/item_unit/item_unit.dart';
import '../../../common_widget/dotted_borderer_container.dart';

class ModItemUnitDialog extends StatefulWidget {
  const ModItemUnitDialog({super.key, required this.itemUnit});
  final ItemUnit itemUnit;

  @override
  State<ModItemUnitDialog> createState() => _ModItemUnitDialogState();
}

class _ModItemUnitDialogState extends State<ModItemUnitDialog> {

  //Input Controller
  final TextEditingController skuController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController attributeController = TextEditingController();

  //Service
  final ItemUnitService itemUnitService = ItemUnitService();
  final FileService fileService = FileService();

  //DropDown
  ItemUnitType unitType = ItemUnitType.consumable;

  //File
  final ImagePicker picker = ImagePicker();
  XFile? selectFile;
  String? imagePath;

  //아이템 유닛 변경
  Future<void> modItemUnit() async {
    try{
      if(imagePath == null){
        throw CustomException(ErrorCode.FILE_NOT_SELECTED);
      }
      
      String? remoteImagePath;
      if(imagePath != widget.itemUnit.image){
        remoteImagePath = await fileService.uploadFileTest(selectFile, FileCategory.profile, FileType.image);
      }

      ItemUnit itemUnit = await itemUnitService.modItemUnit(widget.itemUnit.id, getItemUnitModParam(remoteImagePath));
      AlertUtil.popupSuccessDialog(context, '아이템 유닛 정보 변경 성공');
    } catch(e){
      ErrorHandler.handleError(e, context);
    }
  }

  ItemUnitModParam getItemUnitModParam(String? image){

    return ItemUnitModParam(
        sku: CompareUtil.compareStringValue(widget.itemUnit.sku, skuController.text),
        name: CompareUtil.compareStringValue(widget.itemUnit.name, nameController.text),
        image: CompareUtil.compareStringValue(widget.itemUnit.image, image),
        description: CompareUtil.compareStringValue(widget.itemUnit.description, descController.text),
        attributes: CompareUtil.compareStringValue(widget.itemUnit.attributes, attributeController.text),
        type: CompareUtil.compareStringValue(widget.itemUnit.type, unitType.value)
    );
  }

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

  @override
  void initState(){
    super.initState();
    skuController.text = widget.itemUnit.sku;
    nameController.text = widget.itemUnit.name;
    descController.text = widget.itemUnit.description;
    attributeController.text = widget.itemUnit.attributes;
    imagePath = widget.itemUnit.image;
    unitType = ItemUnitType.fromValue(widget.itemUnit.type);
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
                      value: unitType,
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
                          unitType = value??ItemUnitType.consumable;
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
                            onPressed: () => modItemUnit(),
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
