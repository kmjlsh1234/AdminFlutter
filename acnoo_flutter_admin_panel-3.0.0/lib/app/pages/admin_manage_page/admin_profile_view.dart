// 🐦 Flutter imports:
import 'dart:ui';

import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart' as l;
import '../../constants/admin/admin_menu.dart';
import '../../core/error/error_handler.dart';
import '../../core/service/admin/admin_manage_service.dart';
import '../../models/admin/admin_detail.dart';
import '../../widgets/widgets.dart';
import '../common_widget/custom_button.dart';
import 'component/admin_nav_bar.dart';
import 'component/popup/mod_admin_popup.dart';

class AdminProfileView extends StatefulWidget {
  const AdminProfileView({super.key, required this.adminId});
  final int adminId;

  @override
  State<AdminProfileView> createState() => _AdminProfileViewState();
}

class _AdminProfileViewState extends State<AdminProfileView> {
  final AdminManageService adminManageService = AdminManageService();
  AdminMenu currentMenu = AdminMenu.PROFILE;
  late Future<AdminDetail> admin;

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //ADMIN 단일 조회
  Future<AdminDetail> getAdmin() async {
    try {
      return await adminManageService.getAdmin(widget.adminId);
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    admin = getAdmin();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    lang = l.S.of(context);
    theme = Theme.of(context);
    textTheme = Theme.of(context).textTheme;
    final double padding = 16;

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ShadowContainer(
              contentPadding: EdgeInsets.zero,
              customHeader: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AdminNavBar(adminMenu: AdminMenu.PROFILE, adminId: widget.adminId),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 0.3,
                    height: 0,
                    color: theme.colorScheme.outline,
                  )
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsetsDirectional.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                child: FutureBuilderFactory.createFutureBuilder(
                    future: admin,
                    onSuccess: (context, admin) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildProfileDetailRow(lang.name, admin.name, padding),
                                  buildDivider(),
                                  buildProfileDetailRow(lang.role, admin.roleName, padding),
                                  buildDivider(),
                                  buildProfileDetailRow(lang.status, admin.status.value, padding),
                                  buildDivider(),
                                  buildProfileDetailRow(lang.email, admin.email, padding),
                                  buildDivider(),
                                  buildProfileDetailRow(lang.phoneNumber, admin.mobile, padding),
                                  buildDivider(),
                                  buildProfileDetailRow(lang.loginAt, DateUtil.convertDateTimeToString(admin.loginAt), padding),
                                  buildDivider(),
                                  buildProfileDetailRow(lang.createdAt, DateUtil.convertDateTimeToString(admin.createdAt), padding),
                                  buildDivider(),
                                  buildProfileDetailRow(lang.updatedAt, DateUtil.convertDateTimeToString(admin.updatedAt), padding),
                                ],
                              ),
                            ),
                          ),
                          // 수정 버튼
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Container(
                              color: theme.colorScheme.primaryContainer,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomButton(
                                    textTheme: textTheme,
                                    label: lang.modAdmin,
                                    onPressed: () => showModDialog(admin),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildProfileDetailRow(String label, String? value, double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: SelectableText(
              label,
              style: textTheme.bodyLarge,
              maxLines: 1,
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Text(
                  ':',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(width: 8.0),
                Flexible(
                  child: SelectableText(
                    value ?? lang.empty,
                    maxLines: 1,
                    style: textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return Divider(
      color: theme.colorScheme.outline,
      height: 0.0,
    );
  }

  void showModDialog(AdminDetail admin) async {
    bool? isSuccess = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: ModAdminDialog(admin: admin));
      },
    );

    if(isSuccess != null && isSuccess) {
      setState(() {
        this.admin = getAdmin();
      });
      
    }
  }
}
