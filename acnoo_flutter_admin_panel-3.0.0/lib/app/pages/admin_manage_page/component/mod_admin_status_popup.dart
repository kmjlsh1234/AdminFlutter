import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:acnoo_flutter_admin_panel/app/models/admin/admin_mod_status_param.dart';
import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart' as l;
import '../../../constants/admin/admin_status.dart';
import '../../../core/error/error_code.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/service/admin/admin_manage_service.dart';
import '../../../core/theme/_app_colors.dart';
import '../../../core/utils/alert_util.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/admin/admin.dart';

class ModAdminStatusDialog extends StatefulWidget {
  const ModAdminStatusDialog({super.key, required this.admin});
  final Admin admin;

  @override
  State<ModAdminStatusDialog> createState() => _ModAdminStatusDialogState();
}

class _ModAdminStatusDialogState extends State<ModAdminStatusDialog> {

  final AdminManageService adminManageService = AdminManageService();
  late AdminStatus adminStatus;

  //관리자 상태 변경
  Future<void> modAdminStatus() async {
    try {
      AdminModStatusParam adminModStatusParam = AdminModStatusParam(status: adminStatus.value);
      bool isSuccess = await adminManageService.modAdminStatus(widget.admin.adminId, adminModStatusParam);
      if(isSuccess){
        AlertUtil.popupSuccessDialog(context, '관리자 상태 변경 성공');
      } else{
        throw CustomException(ErrorCode.UNKNOWN_ERROR);
      }
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  @override
  void initState() {
    super.initState();
    adminStatus = AdminStatus.fromValue(widget.admin.status);
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
                    Text(lang.status, style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<AdminStatus>(
                      dropdownColor: theme.colorScheme.primaryContainer,
                      value: adminStatus,
                      hint: Text(
                        lang.selectYouStatus,
                        style: textTheme.bodySmall,
                      ),
                      items: AdminStatus.values.map((status) {
                        return DropdownMenuItem<AdminStatus>(
                          value: status,
                          child: Text(status.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          adminStatus = value!;
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
                            onPressed: () => modAdminStatus(),
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