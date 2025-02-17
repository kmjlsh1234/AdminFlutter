// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/constants/app_version/publish_status.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/app_version/app_version_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:acnoo_flutter_admin_panel/app/models/app_version/app_version_mod_param.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../constants/app_version/app_version_type.dart';
import '../../../core/static/_static_values.dart';
import '../../../core/theme/_app_colors.dart';
import '../../../core/utils/alert_util.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/app_version/app_version.dart';

class ModAppVersionDialog extends StatefulWidget {
  const ModAppVersionDialog({super.key, required this.version});
  final AppVersion version;

  @override
  State<ModAppVersionDialog> createState() => _ModAppVersionDialogState();
}

class _ModAppVersionDialogState extends State<ModAppVersionDialog> {

  //Input Controller
  final TextEditingController publishDateController = TextEditingController();

  //Layer
  final AppVersionService appVersionService = AppVersionService();

  //DropDown && CheckBox
  late AppVersionType versionType;
  late PublishStatus publishStatus;

  //앱버전 변경
  Future<void> modAppVersion() async {
    try {
      AppVersionModParam appVersionModParam = AppVersionModParam(publishDateController.text, publishStatus.value);
      AppVersion version = await appVersionService.modAppVersion(widget.version.id, appVersionModParam);
      AlertUtil.popupSuccessDialog(context, '앱 버전 정보 변경 성공');
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  @override
  void initState() {
    super.initState();
    publishDateController.text = DateUtil.convertDateTimeToLocalDateTime(widget.version.publishAt) ?? '';
    publishStatus = PublishStatus.fromValue(widget.version.publishStatus);
  }

  @override
  void dispose() {
    publishDateController.dispose();
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Text('Start Date', style: textTheme.bodyMedium),
                              Text(lang.publishAt, style: textTheme.bodyMedium),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: publishDateController,
                                keyboardType: TextInputType.visiblePassword,
                                readOnly: true,
                                selectionControls: EmptyTextSelectionControls(),
                                decoration: InputDecoration(
                                  labelText: l.S.of(context).startDate,
                                  labelStyle: textTheme.bodySmall?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  hintText: 'yyyy-MM-ddTHH:mm:ss',//'mm/dd/yyyy',
                                  suffixIcon:
                                  const Icon(IconlyLight.calendar, size: 20),
                                ),
                                onTap: () async {
                                  final _result = await showDatePicker(
                                    context: context,
                                    firstDate: AppDateConfig.appFirstDate,
                                    lastDate: AppDateConfig.appLastDate,
                                    initialDate: DateTime.now(),
                                    builder: (context, child) => Theme(
                                      data: theme.copyWith(
                                        datePickerTheme: DatePickerThemeData(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                      ),
                                      child: child!,
                                    ),
                                  );
                                  if (_result != null) {
                                    publishDateController.text = DateFormat(
                                      AppDateConfig.localDateTimeFormat,
                                    ).format(_result);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: _sizeInfo.innerSpacing),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildCheckbox(PublishStatus.publish),
                          const SizedBox(width: 10),
                          _buildCheckbox(PublishStatus.notPublish),
                        ],
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
                            onPressed: () => modAppVersion(),
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

  Widget _buildCheckbox(PublishStatus status) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: publishStatus == status,
          onChanged: (bool? newValue) {
            if (newValue == true) {
              setState(() {
                publishStatus = status;
              });
            } else if (publishStatus == status) {
              setState(() {
                publishStatus = status;
              });
            }
          },
        ),
        const SizedBox(width: 4.0),
        Text(status.value),
      ],
    );
  }
}