// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/service/shop/category/category_service.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/alert_util.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/shop/category/category.dart';
import '../../../../models/shop/category/category_add_param.dart';
import '../../../../widgets/textfield_wrapper/_textfield_wrapper.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {

  //Input Controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  //Service Layer
  final CategoryService categoryService = CategoryService();

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //카테고리 추가
  Future<void> addCategory() async {
    try {
      CategoryAddParam categoryAddParam = CategoryAddParam(
          name: nameController.text,
          description: descController.text
      );

      Category category = await categoryService.addCategory(categoryAddParam);

      AlertUtil.successDialog(
          context: context,
          message: lang.successAddCategory,
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
  void initState() {
    super.initState();
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
                  Text(lang.addNewCategory),
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
                            onPressed: () => addCategory(),
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