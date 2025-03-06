// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/constants/menus/menu/menu_visibility.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/alert_util.dart';
import 'package:acnoo_flutter_admin_panel/app/models/menus/menu/menu_add_param.dart';
import 'package:acnoo_flutter_admin_panel/app/providers/menu/menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import '../../../../../../generated/l10n.dart' as l;
import '../../../../core/error/custom_exception.dart';
import '../../../../core/error/error_code.dart';
import '../../../../core/service/menus/menu_service.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/menus/menu/menu.dart';
import '../../../../widgets/textfield_wrapper/_textfield_wrapper.dart';
import '../../privilege/component/search_menu_popup.dart';

class AddMenuDialog extends StatefulWidget {
  const AddMenuDialog({super.key});


  @override
  State<AddMenuDialog> createState() => _AddMenuDialogState();
}

class _AddMenuDialogState extends State<AddMenuDialog> {

  //Input Controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController parentController = TextEditingController();
  final TextEditingController imageController = TextEditingController(text: 'assets/images/sidebar_icons/');
  final TextEditingController pathController = TextEditingController();
  final TextEditingController sortOrderController = TextEditingController();

  //Service
  final MenuService menuService = MenuService();

  MenuVisibility menuVisibility = MenuVisibility.VISIBLE;

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;
  late MenuProvider menuProvider;
  //메뉴 추가
  Future<void> addMenu() async {
    try {
      checkAddParameter();
      Menu menu = await menuService.addMenu(getMenuAddParam());
      menuProvider.fetchMenus();
      AlertUtil.successDialog(
          context: context,
          message: lang.successAddMenu,
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

  void checkAddParameter() {
    if(nameController.text.isEmpty) {
      throw CustomException(ErrorCode.PARENT_ADMIN_MENU_NOT_EXIST);
    }

    if(imageController.text.isEmpty) {
      throw CustomException(ErrorCode.PARENT_ADMIN_MENU_NOT_EXIST);
    }

    if(sortOrderController.text.isEmpty){
      throw CustomException(ErrorCode.PARENT_ADMIN_MENU_NOT_EXIST);
    }
  }

  MenuAddParam getMenuAddParam() {
    return MenuAddParam(
        parentId: int.tryParse(parentController.text),
        menuName: nameController.text,
        sortOrder: int.parse(sortOrderController.text),
        menuPath: pathController.text,
        image: imageController.text,
        visibility: menuVisibility
    );
  }

  @override
  void initState(){
    super.initState();
   }

  @override
  void dispose(){
    nameController.dispose();
    parentController.dispose();
    pathController.dispose();
    imageController.dispose();
    sortOrderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    lang = l.S.of(context);
    theme = Theme.of(context);
    textTheme = Theme.of(context).textTheme;
    menuProvider = Provider.of<MenuProvider>(context);
    final _sizeInfo = SizeConfig.getSizeInfo(context);

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
                  Text(lang.addNewMenu),
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

                    //NAME
                    TextFieldLabelWrapper(
                      labelText: lang.name,
                      inputField: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                            hintText: lang.hintName,
                            hintStyle: textTheme.bodySmall),
                        validator: (value) => value?.isEmpty ?? true ? lang.invalidName : null,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                      ),
                    ),

                    const SizedBox(height: 20),

                    //IMAGE PATH
                    TextFieldLabelWrapper(
                      labelText: lang.imagePath,
                      inputField: TextFormField(
                        controller: imageController,
                        decoration: InputDecoration(
                            hintText: lang.hintImagePath,
                            hintStyle: textTheme.bodySmall),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return lang.invalidImagePath;
                          }
                          if (!value.startsWith('assets/images/sidebar_icons/')) {
                            return lang.invalidImagePath;
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUnfocus,
                      ),
                    ),

                    const SizedBox(height: 20),

                    //PARENT MENU
                    TextFieldLabelWrapper(
                      labelText: lang.parentMenuId,
                      inputField: TextFormField(
                        readOnly: true,
                        controller: parentController,
                        decoration: InputDecoration(
                          hintText: lang.search,
                          filled: true,
                          fillColor: theme.colorScheme.tertiaryContainer,
                          suffixIcon: IconButton(
                            icon: Icon(
                                Icons.search,
                                color: theme.colorScheme.primary
                            ),
                            onPressed: () {
                              showSearchDialog();
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    //SORT ORDER
                    TextFieldLabelWrapper(
                      labelText: lang.sortOrder,
                      inputField: TextFormField(
                        controller: sortOrderController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                            hintText: lang.hintSortOrder,
                            hintStyle: textTheme.bodySmall),
                        validator: (value) => value?.isEmpty ?? true ? lang.invalidSortOrder : null,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                      ),
                    ),

                    const SizedBox(height: 20),

                    //PATH
                    TextFieldLabelWrapper(
                      labelText: lang.path,
                      inputField: TextFormField(
                        controller: pathController,
                        decoration: InputDecoration(
                            hintText: lang.hintPath,
                            hintStyle: textTheme.bodySmall),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return lang.invalidPath;
                          }
                          if (!value.startsWith('/')) {
                            return lang.invalidPath;
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUnfocus,
                      ),
                    ),

                    const SizedBox(height: 20),

                    //Visibility
                    TextFieldLabelWrapper(
                      labelText: lang.visibility,
                      inputField: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildCheckbox(MenuVisibility.VISIBLE),
                          const SizedBox(width: 10),
                          _buildCheckbox(MenuVisibility.INVISIBLE),
                        ],
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
                            onPressed: () => addMenu(),
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

  Widget _buildCheckbox(MenuVisibility visibility) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: menuVisibility == visibility,
          onChanged: (bool? newValue) {
            if (newValue == true) {
              setState(() {
                menuVisibility = visibility;
              });
            }
          },
        ),
        const SizedBox(width: 4.0),
        Text(visibility.value),
      ],
    );
  }

  void showSearchDialog() async {
    Menu? menu = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const SearchMenuDialog();
      },
    );

    if (menu != null) {
      setState(() {
        parentController.text = menu.id.toString();
      });
    }
  }
}

