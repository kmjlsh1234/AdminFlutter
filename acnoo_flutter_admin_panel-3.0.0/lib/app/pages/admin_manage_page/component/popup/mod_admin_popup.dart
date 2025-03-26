import 'package:acnoo_flutter_admin_panel/app/core/utils/compare_util.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/admin_manage_page/component/popup/search_role_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../generated/l10n.dart' as l;
import '../../../../core/error/error_handler.dart';
import '../../../../core/service/admin/admin_manage_service.dart';
import '../../../../core/service/menus/role_service.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/alert_util.dart';
import '../../../../core/utils/regex_util.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/admin/admin.dart';
import '../../../../models/admin/admin_detail.dart';
import '../../../../models/admin/admin_mod_param.dart';
import '../../../../models/menus/role/role.dart';
import '../../../../widgets/textfield_wrapper/_textfield_wrapper.dart';

class ModAdminDialog extends StatefulWidget {
  const ModAdminDialog({super.key, required this.admin});
  final AdminDetail admin;

  @override
  State<ModAdminDialog> createState() => _ModAdminDialogState();
}

class _ModAdminDialogState extends State<ModAdminDialog> {

  //Input Controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  //Service
  final AdminManageService adminManageService = AdminManageService();
  final RoleService roleService = RoleService();

  //Future Model
  late Future<List<Role>> roleList;
  late int? roleId;

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //관리자 정보 변경
  Future<void> modAdmin() async {
    try {
      AdminModParam adminModParam = getAdminModParam();
      Admin admin = await adminManageService.modAdmin(widget.admin.adminId, adminModParam);
      AlertUtil.successDialog(
          context: context,
          message: lang.successModAdmin,
          buttonText: lang.confirm,
          onPressed: ()  {
            GoRouter.of(context).pop();
            GoRouter.of(context).pop(true);
          });
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  //역할 목록 조회
  Future<List<Role>> getRoleList() async {
    try{
      return await roleService.getTotalRoleList();
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  AdminModParam getAdminModParam() {
    return AdminModParam(
        roleId: CompareUtil.compareIntValue(widget.admin.roleId, roleId),
        name: CompareUtil.compareStringValue(widget.admin.name, nameController.text),
        email: CompareUtil.compareStringValue(widget.admin.email, emailController.text),
        password: null,
        mobile: CompareUtil.compareStringValue(widget.admin.mobile, mobileController.text),
    );
  }

  @override
  void initState() {
    super.initState();
    roleList = getRoleList();

    nameController.text = widget.admin.name;
    emailController.text = widget.admin.email;
    mobileController.text = widget.admin.mobile;

    if(widget.admin.roleName != null){
      roleController.text = widget.admin.roleName!;
      roleId = widget.admin.roleId;
    }
  }

  @override
  void dispose(){
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    roleController.dispose();
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
                  Text(lang.modAdmin),
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

                    // EMAIL
                    TextFieldLabelWrapper(
                      labelText: lang.email,
                      inputField: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText: lang.hintEmail,
                            hintStyle: textTheme.bodySmall
                        ),
                        validator: ((value) {
                          if(value != null && RegexUtil.emailRegex.hasMatch(value)){
                            return null;
                          }else{
                            return lang.invalidEmail;
                          }
                        }),
                        autovalidateMode: AutovalidateMode.onUnfocus,
                      ),
                    ),

                    const SizedBox(height: 20),

                    //MOBILE
                    TextFieldLabelWrapper(
                      labelText: lang.mobile,
                      inputField: TextFormField(
                        controller: mobileController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                            hintText: lang.hintMobile,
                            hintStyle: textTheme.bodySmall
                        ),
                        validator: ((value) {
                          if(value != null){
                            if(RegexUtil.mobileRegex.hasMatch(value)){
                              return null;
                            }
                          }
                          return lang.invalidMobile;
                        }),
                        autovalidateMode: AutovalidateMode.onUnfocus,
                      ),
                    ),

                    const SizedBox(height: 20),

                    //ROLE
                    TextFieldLabelWrapper(
                      labelText: lang.role,
                      inputField: TextFormField(
                        readOnly: true,
                        controller: roleController,
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
                              showSearchDialog(context);
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
                            onPressed: () => modAdmin(),
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
    Role? role = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const SearchRoleDialog();
      },
    );

    if (role != null) {
      setState(() {
        roleId = role.id;
        roleController.text = role.roleName;
      });
    }
  }
}