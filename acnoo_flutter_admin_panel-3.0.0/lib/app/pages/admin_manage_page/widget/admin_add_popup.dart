// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/admin/admin_manage_service.dart';
import 'package:acnoo_flutter_admin_panel/app/models/admin/admin_add_param.dart';
import 'package:flutter/material.dart';
// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../core/theme/_app_colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/admin/admin.dart';

class AddAdminDialog extends StatefulWidget {
  const AddAdminDialog({super.key});

  @override
  State<AddAdminDialog> createState() => _AddAdminDialogState();
}

class _AddAdminDialogState extends State<AddAdminDialog> {
  String? selectRole;
  List<String> get roles => [
        //'Manager',
        l.S.current.manager,
        //'Developer',
        l.S.current.developer,
        //'Designer',
        l.S.current.designer,
        //'Tester'
        l.S.current.tester,
      ];

  final AdminManageService adminManageService = AdminManageService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  //Admin 추가
  Future<void> addAdmin() async {
    try {
      AdminAddParam adminAddParam = AdminAddParam(
          //TODO : 나중에 ROLE 작업 시 변경하기
          roleId: 1,
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          mobile: mobileController.text
      );
      Admin admin = await adminManageService.addAdmin(adminAddParam);
      showSuccessDialog(context);
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    mobileController.dispose();
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
                    onPressed: () => Navigator.pop(context),
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
                    Text(lang.email, style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          //hintText: 'Enter Your Email',
                          hintText: lang.enterYourEmail,
                          hintStyle: textTheme.bodySmall),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value?.isEmpty ?? true
                          //? 'Please enter your email'
                          ? lang.pleaseEnterYourEmail
                          : null,
                    ),
                    const SizedBox(height: 20),
                    Text(lang.password, style: textTheme.bodySmall),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          //hintText: 'Enter Your Password',
                          hintText: lang.enterYourPassword,
                          hintStyle: textTheme.bodySmall),
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) => value?.isEmpty ?? true
                          //? 'Please enter your email'
                          ? lang.pleaseEnterYourPassword
                          : null,
                    ),
                    const SizedBox(height: 20),
                    Text(lang.phoneNumber, style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: mobileController,
                      decoration: InputDecoration(
                          // hintText: 'Enter Your Phone Number',
                          hintText: lang.enterYourPhoneNumber,
                          hintStyle: textTheme.bodySmall),
                      keyboardType: TextInputType.phone,
                      validator: (value) => value?.isEmpty ?? true
                          //? 'Please enter your phone number'
                          ? lang.pleaseEnterYourPhoneNumber
                          : null,
                    ),
                    const SizedBox(height: 20),
                    Text(lang.position, style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      dropdownColor: theme.colorScheme.primaryContainer,
                      value: selectRole,
                      hint: Text(
                        lang.selectPosition,
                        //'Select Position',
                        style: textTheme.bodySmall,
                      ),
                      items: roles.map((position) {
                        return DropdownMenuItem<String>(
                          value: position,
                          child: Text(position),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectRole = value;
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

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: Text('관리자 추가 성공'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(true);
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}