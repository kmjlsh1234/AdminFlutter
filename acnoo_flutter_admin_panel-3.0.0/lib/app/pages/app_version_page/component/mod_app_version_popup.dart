// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/constants/app_version/publish_status.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/app_version/app_version_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:acnoo_flutter_admin_panel/app/models/app_version/app_version_mod_param.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../core/static/_static_values.dart';
import '../../../core/theme/_app_colors.dart';
import '../../../core/utils/alert_util.dart';
import '../../../core/utils/compare_util.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/app_version/app_version.dart';
import '../../../widgets/textfield_wrapper/_textfield_wrapper.dart';

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
  late PublishStatus publishStatus;

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //앱버전 변경
  Future<void> modAppVersion() async {
    try {
      AppVersion version = await appVersionService.modAppVersion(widget.version.id, getAppVersionModParam());
      AlertUtil.successDialog(
          context: context,
          message: lang.successModVersion,
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

  AppVersionModParam getAppVersionModParam(){
    String originTime = DateUtil.convertDateTimeToString(widget.version.publishAt);
    String? publishAt = CompareUtil.compareStringValue(originTime, publishDateController.text);

    if (publishAt != null && publishAt.isNotEmpty) {
      publishAt = DateUtil.convertToLocalDateTime(publishAt);
    }

    return AppVersionModParam(
        publishAt: publishAt,
        publishStatus: (widget.version.publishStatus == publishStatus) ? null : publishStatus
    );
  }
  
  @override
  void initState() {
    super.initState();
    publishDateController.text = DateUtil.convertDateTimeToString(widget.version.publishAt);
    publishStatus = widget.version.publishStatus;

  }

  @override
  void dispose() {
    publishDateController.dispose();
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
                  Text(lang.modVersion),
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
                    
                    //PUBLISH AT
                    TextFieldLabelWrapper(
                      labelText: lang.publishAt,
                      inputField: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: publishDateController,
                              readOnly: true,
                              selectionControls: EmptyTextSelectionControls(),
                              decoration: InputDecoration(
                                hintText: lang.search,
                                suffixIcon: const Icon(IconlyLight.calendar, size: 20), // 달력 아이콘
                              ),
                              onTap: () async {
                                final result = await showDatePicker(
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
                                if (result != null) {
                                  publishDateController.text = DateFormat(DateUtil.dateTimeFormat).format(result);
                                }
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh, size: 20),
                            onPressed: () {
                              publishDateController.clear();
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildCheckbox(PublishStatus.PUBLISH),
                          const SizedBox(width: 10),
                          _buildCheckbox(PublishStatus.NOT_PUBLISH),
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