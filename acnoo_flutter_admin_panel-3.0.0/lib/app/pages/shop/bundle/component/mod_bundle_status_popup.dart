import 'package:acnoo_flutter_admin_panel/app/core/service/shop/bundle/bundle_service.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/bundle/bundle/bundle_mod_status_param.dart';
import 'package:flutter/material.dart';

import '../../../../../../generated/l10n.dart' as l;
import '../../../../constants/shop/bundle/bundle_status.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/shop/bundle/bundle/bundle.dart';

class ModBundleStatusDialog extends StatefulWidget {
  const ModBundleStatusDialog({super.key, required this.bundle});
  final Bundle bundle;

  @override
  State<ModBundleStatusDialog> createState() => _ModBundleStatusDialogState();
}

class _ModBundleStatusDialogState extends State<ModBundleStatusDialog> {

  final BundleService bundleService = BundleService();
  late BundleStatus bundleStatus;

  //번들 상태 변경
  Future<void> modBundleStatus() async {
    try {
      BundleModStatusParam bundleModStatusParam = BundleModStatusParam(status: bundleStatus.value);
      await bundleService.modBundleStatus(widget.bundle.id, bundleModStatusParam);
      showSuccessDialog(context);
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  @override
  void initState() {
    super.initState();
    bundleStatus = BundleStatus.fromValue(widget.bundle.status);
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
                    DropdownButtonFormField<BundleStatus>(
                      dropdownColor: theme.colorScheme.primaryContainer,
                      value: bundleStatus,
                      hint: Text(
                        lang.selectYouStatus,
                        style: textTheme.bodySmall,
                      ),
                      items: BundleStatus.values.map((status) {
                        return DropdownMenuItem<BundleStatus>(
                          value: status,
                          child: Text(status.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          bundleStatus = value!;
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
                            onPressed: () => modBundleStatus(),
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

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: Text('번들 상태 변경 성공'),
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