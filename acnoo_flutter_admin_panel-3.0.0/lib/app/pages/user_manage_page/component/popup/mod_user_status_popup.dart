import 'package:acnoo_flutter_admin_panel/app/core/utils/size_config.dart';
import 'package:acnoo_flutter_admin_panel/app/models/user/user_mod_status_param.dart';
import 'package:flutter/material.dart';

import '../../../../../../generated/l10n.dart' as l;
import '../../../../constants/user/user_status.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/service/user/user_manage_service.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/alert_util.dart';
import '../../../../models/user/user_profile.dart';

class ModUserStatusDialog extends StatefulWidget {
  const ModUserStatusDialog({super.key, required this.userProfile});
  final UserProfile userProfile;
  @override
  State<ModUserStatusDialog> createState() => _ModUserStatusDialogState();
}

class _ModUserStatusDialogState extends State<ModUserStatusDialog> {

  final UserManageService userManageService = UserManageService();
  late UserStatus userStatus;

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //유저 상태 변경
  Future<void> modUserStatus() async {
    try {
      UserModStatusParam userModStatusParam = UserModStatusParam(userStatus);
      await userManageService.modUserStatus(widget.userProfile.userId, userModStatusParam);
      AlertUtil.successDialog(
          context: context,
          message: lang.successModUserStatus,
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
    userStatus = widget.userProfile.status;
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
                  Text(lang.modUserStatus),
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
                    Text(lang.status, style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<UserStatus>(
                      dropdownColor: theme.colorScheme.primaryContainer,
                      value: userStatus,
                      hint: Text(
                        lang.status,
                        style: textTheme.bodySmall,
                      ),
                      items: UserStatus.values.map((status) {
                        return DropdownMenuItem<UserStatus>(
                          value: status,
                          child: Text(status.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          userStatus = value!;
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
                            onPressed: () => modUserStatus(),
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