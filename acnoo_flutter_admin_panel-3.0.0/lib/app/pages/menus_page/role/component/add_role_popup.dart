// 🐦 Flutter imports:
import 'dart:ui';

import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/models/menus/role_privilege/role_privilege.dart';
import 'package:acnoo_flutter_admin_panel/app/models/menus/role_privilege/role_privilege_add_param.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/menus_page/role/component/add_role_privilege_popup.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/service/menus/role_service.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/alert_util.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/menus/role/role.dart';
import '../../../../models/menus/role/role_add_param.dart';
import '../../../../widgets/textfield_wrapper/_textfield_wrapper.dart';

class AddRoleDialog extends StatefulWidget {
  const AddRoleDialog({super.key});

  @override
  State<AddRoleDialog> createState() => _AddRoleDialogState();
}

class _AddRoleDialogState extends State<AddRoleDialog> {

  final RoleService roleService = RoleService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  List<RolePrivilege> rolePrivilegeList = [];

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //역할 추가
  Future<void> addRole() async {
    try {
      List<RolePrivilegeAddParam> rolePrivileges = [];

      for(RolePrivilege rolePrivilege in rolePrivilegeList){
        rolePrivileges.add(
          RolePrivilegeAddParam(
              roleId: null,
              privilegeId: rolePrivilege.privilegeId,
              readAuth: rolePrivilege.readAuth,
              writeAuth: rolePrivilege.writeAuth
          )
        );
      }

      RoleAddParam roleAddParam = RoleAddParam(
          roleName: nameController.text,
          description: descController.text,
          rolePrivileges: rolePrivileges
      );

      Role role = await roleService.addRole(roleAddParam);
      AlertUtil.successDialog(
          context: context,
          message: lang.successAddRole,
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
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _sizeInfo = SizeConfig.getSizeInfo(context);
    lang = l.S.of(context);
    theme = Theme.of(context);
    textTheme = Theme.of(context).textTheme;

    const _buttonPadding = EdgeInsetsDirectional.symmetric(
      horizontal: 16,
      vertical: 8,
    );
    final _buttonTextStyle = theme.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w600,
    );

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
                  Text(lang.addNewRole),
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

                    //DESCRIPTION
                    TextFieldLabelWrapper(
                      labelText: lang.description,
                      inputField: TextFormField(
                        controller: descController,
                        decoration: InputDecoration(
                            hintText: lang.hintDescription,
                            hintStyle: textTheme.bodySmall
                        ),
                        validator: (value) => value?.isEmpty ?? true ? lang.invalidDescription : null,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                      ),
                    ),

                    const SizedBox(height: 20),

                    OutlinedButton(
                      onPressed: () {
                        addRolePrivilegeFormDialog();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AcnooAppColors.kInfo,
                        side: BorderSide(
                          color: AcnooAppColors.kInfo,
                        ),
                        shadowColor: Colors.transparent,
                        padding: _buttonPadding,
                        textStyle: _buttonTextStyle,
                        elevation: 0,
                      ),
                      child: Text(lang.addPrivilege),
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
                            onPressed: () => addRole(),
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

  void addRolePrivilegeFormDialog() async {
    List<RolePrivilege>? list = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: AddRolePrivilegeDialog(rolePrivilegeList: rolePrivilegeList));
      },
    );

    if(list != null){
      rolePrivilegeList = list;
    }
  }
}