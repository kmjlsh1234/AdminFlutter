// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/constants/app_version/app_version_type.dart';
import 'package:acnoo_flutter_admin_panel/app/core/constants/app_version/publish_status.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/app_version/app_version_service.dart';
import 'package:acnoo_flutter_admin_panel/app/models/app_version/app_version_add_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/app_version/app_version_mod_param.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../core/static/_static_values.dart';
import '../../core/theme/_app_colors.dart';
import '../../models/app_version/app_version.dart';

class AppVersionModDialog extends StatefulWidget {
  const AppVersionModDialog({super.key, required this.version});
  final AppVersion version;
  @override
  State<AppVersionModDialog> createState() => _AppVersionModDialogState();
}

class _AppVersionModDialogState extends State<AppVersionModDialog> {
  String? selectType;
  String? selectStatus;

  List<String> get _types => AppVersionType.values.map((e) => e.type).toList();
  
  final AppVersionService appVersionService = AppVersionService();
  final TextEditingController publishDateController = TextEditingController();

  //앱버전 변경
  Future<void> modAppVersion(BuildContext context) async {
    try {
      AppVersionModParam appVersionModParam = AppVersionModParam(publishDateController.text, selectStatus);
      AppVersion version = await appVersionService.modAppVersion(widget.version.id, appVersionModParam);
      showModAppVersionSuccessDialog(context);
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  void showModAppVersionSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: Text('앱 버전 변경 성공'),
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

  @override
  void initState() {
    super.initState();
    publishDateController.text = widget.version.publishAt;
    selectStatus = widget.version.publishStatus;
  }
  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 480,
          value: _SizeInfo(
            alertFontSize: 12,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 481,
          end: 576,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 577,
          end: 992,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Text('Start Date', style: textTheme.bodyMedium),
                              Text(lang.publishAt, style: textTheme.bodyMedium),
                              const SizedBox(height: 8),
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
                                      //AppDateConfig.appNumberOnlyDateFormat,
                                      AppDateConfig.localDateTimeFormat,
                                    ).format(_result);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: const _SizeInfo().innerSpacing),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildCheckbox('PUBLISH', 'PUBLISH'),
                          const SizedBox(width: 10),
                          _buildCheckbox('NOT_PUBLISH', 'NOT_PUBLISH'),
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
                            onPressed: () => modAppVersion(context),
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

  Widget _buildCheckbox(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: selectStatus == value,
          onChanged: (bool? newValue) {
            if (newValue == true) {
              setState(() {
                selectStatus = value;
              });
            } else if (selectStatus == value) {
              setState(() {
                selectStatus = value; // Deselect if it's the current selected one
              });
            }
          },
        ),
        const SizedBox(width: 4.0),
        Text(label),
      ],
    );
  }
}

class _SizeInfo {
  final double? alertFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;

  const _SizeInfo({
    this.alertFontSize = 18,
    this.padding = const EdgeInsets.all(24),
    this.innerSpacing = 24,
  });
}