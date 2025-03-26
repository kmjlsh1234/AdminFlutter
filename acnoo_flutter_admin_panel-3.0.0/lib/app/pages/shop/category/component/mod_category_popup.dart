// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/alert_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/compare_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/service/shop/category/category_service.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/shop/category/category.dart';
import '../../../../models/shop/category/category_mod_param.dart';
import '../../../../widgets/textfield_wrapper/_textfield_wrapper.dart';

class ModCategoryDialog extends StatefulWidget {
  const ModCategoryDialog({super.key, required this.category});
  final Category category;

  @override
  State<ModCategoryDialog> createState() => _ModCategoryDialogState();
}

class _ModCategoryDialogState extends State<ModCategoryDialog> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final CategoryService categoryService = CategoryService();

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //카테고리 변경
  Future<void> modCategory(BuildContext context) async {
    try {
      CategoryModParam categoryModParam = CategoryModParam(
        name: CompareUtil.compareStringValue(widget.category.name, nameController.text),
        description: CompareUtil.compareStringValue(widget.category.description, descController.text)
      );

      Category category = await categoryService.modCategory(widget.category.id, categoryModParam);
      AlertUtil.successDialog(
          context: context,
          message: lang.successModCategory,
          buttonText: lang.confirm,
          onPressed: (){
            GoRouter.of(context).pop();
            GoRouter.of(context).pop(true);
          }
      );
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }
  
  @override
  void initState(){
    super.initState();
    nameController.text = widget.category.name;
    descController.text = widget.category.description;
  }

  @override
  void dispose(){
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _sizeInfo = SizeConfig.getSizeInfo(context);
    lang = l.S.of(context);
    theme = Theme.of(context);
    textTheme = Theme.of(context).textTheme;

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
                  Text(lang.modCategory),
                  IconButton(
                    onPressed: () => GoRouter.of(context).pop(false),
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
                    ///---------------- Text Field section

                    // NAME
                    TextFieldLabelWrapper(
                      labelText: lang.name,
                      inputField: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                            hintText: lang.hintName,
                            hintStyle: textTheme.bodySmall
                        ),
                        validator: (value) => value?.isEmpty ?? true ? lang.invalidName : null,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // DESCRIPTION
                    TextFieldLabelWrapper(
                      labelText: lang.description,
                      inputField: TextFormField(
                        controller: descController,
                        decoration: InputDecoration(
                            hintText: lang.hintDescription,
                            hintStyle: textTheme.bodySmall),
                        maxLines: 3,
                        validator: (value) => value?.isEmpty ?? true ? lang.invalidDescription : null,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                      ),
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
                            onPressed: () => GoRouter.of(context).pop(false),
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
                            onPressed: () => modCategory(context),
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

