// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/alert_util.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/menus_page/privilege/component/search_menu_popup.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/service/menus/privilege_service.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/compare_util.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/menus/menu/menu.dart';
import '../../../../models/menus/privilege/privilege.dart';
import '../../../../models/menus/privilege/privilege_mod_param.dart';

class ModPrivilegeDialog extends StatefulWidget {
  const ModPrivilegeDialog({super.key, required this.privilege});
  final Privilege privilege;

  @override
  State<ModPrivilegeDialog> createState() => _ModPrivilegeDialogState();
}

class _ModPrivilegeDialogState extends State<ModPrivilegeDialog> {

  final PrivilegeService privilegeService = PrivilegeService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController menuController = TextEditingController();

  int? menuId;

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //권한 변경
  Future<void> modPrivilege() async {
    try {
      PrivilegeModParam privilegeModParam = PrivilegeModParam(
        privilegeName: CompareUtil.compareStringValue(widget.privilege.privilegeName, nameController.text),
        privilegeCode: CompareUtil.compareStringValue(widget.privilege.privilegeCode, codeController.text),
        menuId: CompareUtil.compareIntValue(widget.privilege.menuId, menuId)
      );
      Privilege privilege = await privilegeService.modPrivilege(widget.privilege.id, privilegeModParam);
      AlertUtil.successDialog(
          context: context,
          message: lang.successModPrivilege,
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
  void initState(){
    super.initState();
    nameController.text = widget.privilege.privilegeName;
    codeController.text = widget.privilege.privilegeCode;
    menuController.text = widget.privilege.menuName ?? '';
    menuId = widget.privilege.menuId;
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
                  Text(lang.modPrivilege),
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
                    Text(lang.code, style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: codeController,
                      decoration: InputDecoration(
                          hintText: lang.enterYourFullName,
                          hintStyle: textTheme.bodySmall),
                      validator: (value) => value?.isEmpty ?? true
                          ? lang.pleaseEnterYourFullName
                          : null,
                    ),

                    const SizedBox(height: 20),

                    Text(lang.menu, style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      readOnly: true,
                      controller: menuController,
                      decoration: InputDecoration(
                        hintText: lang.menu,
                        filled: true,
                        fillColor: theme.colorScheme.tertiaryContainer,
                        suffixIcon: IconButton(
                          icon: Icon(
                              Icons.search,
                              color: theme.colorScheme.primary
                          ),
                          onPressed: () {
                            showSearchDialog(context);
                          },
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
                            onPressed: () => modPrivilege(),
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

  void showSearchDialog(BuildContext context) async {
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

