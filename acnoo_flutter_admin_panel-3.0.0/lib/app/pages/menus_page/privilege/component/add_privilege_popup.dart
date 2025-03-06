// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/menus/privilege_service.dart';
import 'package:acnoo_flutter_admin_panel/app/models/menus/privilege/privilege_add_param.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/menus_page/privilege/component/search_menu_popup.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/service/menus/role_service.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/alert_util.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/menus/menu/menu.dart';
import '../../../../models/menus/privilege/privilege.dart';
import '../../../../widgets/textfield_wrapper/_textfield_wrapper.dart';

class AddPrivilegeDialog extends StatefulWidget {
  const AddPrivilegeDialog({super.key});

  @override
  State<AddPrivilegeDialog> createState() => _AddPrivilegeDialogState();
}

class _AddPrivilegeDialogState extends State<AddPrivilegeDialog> {

  final RoleService roleService = RoleService();
  final PrivilegeService privilegeService = PrivilegeService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController menuController = TextEditingController();
  int? menuId;

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //권한 추가
  Future<void> addPrivilege() async {
    try {
      PrivilegeAddParam privilegeAddParam = PrivilegeAddParam(
          privilegeName: nameController.text,
          privilegeCode: codeController.text,
          menuId: menuId
      );

      Privilege privilege = await privilegeService.addPrivilege(privilegeAddParam);
      AlertUtil.successDialog(
          context: context,
          message: lang.successAddPrivilege,
          buttonText: lang.confirm,
          onPressed: (){
            Navigator.of(context).pop();
            Navigator.of(context).pop(true);
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
    codeController.dispose();
    menuController.dispose();
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
                  Text(lang.addNewPrivilege),
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
                    ///---------------- Text Field section

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

                    TextFieldLabelWrapper(
                      labelText: lang.code,
                      inputField: TextFormField(
                        controller: codeController,
                        decoration: InputDecoration(
                            hintText: lang.hintCode,
                            hintStyle: textTheme.bodySmall),
                        validator: (value) => value?.isEmpty ?? true ? lang.invalidCode : null,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                      ),
                    ),

                    const SizedBox(height: 20),

                    //MENU
                    TextFieldLabelWrapper(
                      labelText: lang.parentMenuId,
                      inputField: TextFormField(
                        readOnly: true,
                        controller: menuController,
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
                            onPressed: () => addPrivilege(),
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

  void showSearchDialog() async {
    Menu? menu = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const SearchMenuDialog();
      },
    );

    if (menu != null) {
      setState(() {
        menuId = menu.id;
        menuController.text = menu.menuName;
      });
    }
  }
}