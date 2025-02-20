import 'package:flutter/material.dart';
import '../../../../../generated/l10n.dart' as l;
import '../../../core/error/error_handler.dart';
import '../../../core/service/admin/admin_manage_service.dart';
import '../../../core/theme/_app_colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/admin/admin.dart';
import '../../../models/admin/admin_mod_param.dart';

class ModAdminDialog extends StatefulWidget {
  const ModAdminDialog({super.key, required this.admin});
  final Admin admin;

  @override
  State<ModAdminDialog> createState() => _ModAdminDialogState();
}

class _ModAdminDialogState extends State<ModAdminDialog> {
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

  //관리자 정보 변경
  Future<void> modAdmin() async {
    try {
      AdminModParam adminModParam = AdminModParam(
          roleId: 1,
          name: nameController.text,
          email: emailController.text,
          password: null,
          mobile: mobileController.text);
      Admin admin = await adminManageService.modAdmin(widget.admin.adminId, adminModParam);
      showSuccessDialog();
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.admin.name;
    emailController.text = widget.admin.email;
    mobileController.text = widget.admin.mobile;
  }

  @override
  void dispose(){
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    super.dispose();
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

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: Text('관리자 변경 성공'),
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