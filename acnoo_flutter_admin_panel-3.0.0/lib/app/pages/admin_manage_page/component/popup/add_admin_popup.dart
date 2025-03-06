// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/admin/admin_manage_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/regex_util.dart';
import 'package:acnoo_flutter_admin_panel/app/models/admin/admin_add_param.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/admin_manage_page/component/popup/search_role_popup.dart';
import 'package:acnoo_flutter_admin_panel/app/widgets/textfield_wrapper/_textfield_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../../../../generated/l10n.dart' as l;
import '../../../../core/error/custom_exception.dart';
import '../../../../core/error/error_code.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/alert_util.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/admin/admin.dart';
import '../../../../models/menus/role/role.dart';

class AddAdminDialog extends StatefulWidget {
  const AddAdminDialog({super.key});

  @override
  State<AddAdminDialog> createState() => _AddAdminDialogState();
}

class _AddAdminDialogState extends State<AddAdminDialog> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  final AdminManageService adminManageService = AdminManageService();
  int? roleId;

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //Admin 추가
  Future<void> addAdmin() async {
    try {
      checkAddParameter();

      AdminAddParam adminAddParam = AdminAddParam(
          roleId: roleId,
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          mobile: mobileController.text
      );
      Admin admin = await adminManageService.addAdmin(adminAddParam);
      AlertUtil.successDialog(
          context: context,
          message: lang.successAddAdmin,
          buttonText: lang.confirm,
          onPressed: ()  {
            GoRouter.of(context).pop();
            GoRouter.of(context).pop(true);
          });
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  void checkAddParameter() {
    //TODO : 빈값 체크
    if(nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty || mobileController.text.isEmpty) {
      throw CustomException(ErrorCode.UNKNOWN_ERROR);
    }

    //TODO : email 형식 검사
    if(!RegexUtil.emailRegex.hasMatch(emailController.text)){
      throw CustomException(ErrorCode.EMAIL_REGEX_VALIDATION);
    }

    //TODO : password 길이가 2~14 사이인지 검사
    if(passwordController.text.length < 2 || passwordController.text.length > 14){
      throw CustomException(ErrorCode.INVALID_PASSWORD_LENGTH);
    }

    //TODO : password에 특수문자 들어가는지 검사
    if(!RegexUtil.specialCharRegex.hasMatch(passwordController.text)){
      throw CustomException(ErrorCode.PASSWORD_REGEX_VALIDATION);
    }

    //TODO : 전화번호 형식 검사
    if( !RegexUtil.mobileRegex.hasMatch(mobileController.text)){
      throw CustomException(ErrorCode.MOBILE_REGEX_VALIDATION);
    }
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    mobileController.dispose();
    roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    lang = l.S.of(context);
    theme = Theme.of(context);
    textTheme = Theme.of(context).textTheme;
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
                  Text(lang.addNewAdmin),
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

                    // PASSWORD
                    TextFieldLabelWrapper(
                      labelText: lang.password,
                      inputField: TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                            hintText: lang.hintPassword,
                            hintStyle: textTheme.bodySmall
                        ),
                        validator: ((value) {
                          if(value != null){
                            if(!RegexUtil.specialCharRegex.hasMatch(value)){
                              return lang.invalidPasswordRegex;
                            }
                            if(value.length <2 || value.length > 14){
                              return lang.invalidPasswordLength;
                            }
                            return null;
                          }else{
                            return lang.invalidPasswordLength;
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
                              style: textTheme.bodySmall
                                  ?.copyWith(color: AcnooAppColors.kError),
                            ),
                          ),
                          SizedBox(width: _sizeInfo.innerSpacing),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: _sizeInfo.innerSpacing),
                            ),
                            onPressed: () => addAdmin(),
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