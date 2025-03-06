// 🐦 Flutter imports:
import 'dart:ui';

import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/menus/role_privilege_service.dart';
import 'package:acnoo_flutter_admin_panel/app/models/menus/role_privilege/role_privilege.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/menus_page/role/component/mod_role_privilege_popup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/service/menus/role_service.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/alert_util.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/menus/role/role.dart';
import '../../../../models/menus/role/role_mod_param.dart';
import '../../../../models/menus/role_privilege/role_privilege_mod_param.dart';

class ModRoleDialog extends StatefulWidget {
  const ModRoleDialog({super.key, required this.role});
  final Role role;

  @override
  State<ModRoleDialog> createState() => _ModRoleDialogState();
}

class _ModRoleDialogState extends State<ModRoleDialog> {

  //Input Controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  //Service Layer
  final RolePrivilegeService rolePrivilegeService = RolePrivilegeService();
  final RoleService roleService = RoleService();

  late Future<List<RolePrivilege>> originList;
  List<RolePrivilege>? modList;

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  Future<List<RolePrivilege>> getRolePrivilegeListByRoleId() async {
    try{
      return await rolePrivilegeService.getPrivilegeListByRoleId(widget.role.id);
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  //역할 변경
  Future<void> modRole() async {
    try {
      List<RolePrivilegeModParam> rolePrivileges = [];
      if(modList != null){
        for(RolePrivilege rolePrivilege in modList!){
          rolePrivileges.add(
              RolePrivilegeModParam(
                  roleId: widget.role.id,
                  privilegeId: rolePrivilege.privilegeId,
                  readAuth: rolePrivilege.readAuth,
                  writeAuth: rolePrivilege.writeAuth
              )
          );
        }
      } else{
        List<RolePrivilege> list = await originList;
        for(RolePrivilege rolePrivilege in list){
          rolePrivileges.add(
              RolePrivilegeModParam(
                  roleId: widget.role.id,
                  privilegeId: rolePrivilege.privilegeId,
                  readAuth: rolePrivilege.readAuth,
                  writeAuth: rolePrivilege.writeAuth
              )
          );
        }
      }
      RoleModParam roleModParam = RoleModParam(
          roleName: nameController.text,
          description: descController.text,
          rolePrivileges: rolePrivileges
      );

      Role role = await roleService.modRole(widget.role.id, roleModParam);
      AlertUtil.successDialog(
          context: context,
          message: lang.successModRole,
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
    nameController.text = widget.role.roleName;
    descController.text = widget.role.description;
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
                  Text(lang.modeRole),
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

                    //DESCRIPTION
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

                    OutlinedButton(
                      onPressed: () {
                        showModRolePrivilegeFormDialog(context);
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
                      child: Text(lang.modRolePrivilege),
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
                            onPressed: () => modRole(),
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

  void showModRolePrivilegeFormDialog(BuildContext context) async {
    List<RolePrivilege> list;
    if(modList != null){
      list = modList!;
    } else{
      list = await getRolePrivilegeListByRoleId();
    }

    List<RolePrivilege>? resultList = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: ModRolePrivilegeDialog(roleId: widget.role.id, rolePrivilegeList: list));
      },
    );

    if(resultList != null){
      modList = resultList;
    }
  }
}