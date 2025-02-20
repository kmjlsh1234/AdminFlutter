// 🐦 Flutter imports:
import 'dart:ui';

import 'package:acnoo_flutter_admin_panel/app/pages/admin_manage_page/widget/admin_nav_bar.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/admin_manage_page/widget/mod_admin_popup.dart';
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart' as l;
import '../../constants/admin/admin_menu.dart';
import '../../core/error/error_handler.dart';
import '../../core/service/admin/admin_manage_service.dart';
import '../../models/admin/admin.dart';
import '../../widgets/widgets.dart';
import '../common_widget/custom_button.dart';

class AdminProfileView extends StatefulWidget {
  const AdminProfileView({super.key, required this.adminId});
  final int adminId;

  @override
  State<AdminProfileView> createState() => _AdminProfileViewState();
}

class _AdminProfileViewState extends State<AdminProfileView> {

  final AdminManageService adminManageService = AdminManageService();
  AdminMenu currentMenu = AdminMenu.profile;
  late Future<Admin> admin;

  //ADMIN 단일 조회
  Future<Admin> getAdmin() async {
    try {
      return await adminManageService.getAdmin(widget.adminId);
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  void showModDialog(BuildContext context, Admin admin) async {
    bool isUserMod = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: ModAdminDialog(admin: admin));
      },
    );

    if (isUserMod) {
      setState(() {
        this.admin = getAdmin();
      });
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
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final l.S lang = l.S.of(context);
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
                        child: AdminNavBar(
                          onTabSelected: (value) {
                            setState(() {
                              currentMenu = AdminMenu.values.firstWhere(
                                    (menu) => menu.value == value,
                                orElse: () => AdminMenu.profile,
                              );
                            });
                          },
                          adminMenu: AdminMenu.profile,
                        ),
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
                child: FutureBuilder<Admin>(
                  future: admin,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final admin = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 프로필 정보
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
                                  buildProfileDetailRow(lang.fullName, admin.name, padding, textTheme),
                                  buildDivider(theme),
                                  buildProfileDetailRow(lang.email, admin.email, padding, textTheme),
                                  buildDivider(theme),
                                  buildProfileDetailRow(lang.phoneNumber, admin.mobile, padding, textTheme),
                                  buildDivider(theme),
                                  buildProfileDetailRow(lang.loginAt, admin.loginAt.toString(), padding, textTheme),
                                  buildDivider(theme),
                                  buildProfileDetailRow(lang.createdAt, admin.createdAt.toString(), padding, textTheme),
                                  buildDivider(theme),
                                  buildProfileDetailRow(lang.updatedAt, admin.updatedAt.toString(), padding, textTheme),
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
                                    onPressed: () => showModDialog(context, admin),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildProfileDetailRow(
      String label, String? value, double padding, TextTheme textTheme) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
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
                  child: Text(
                    value ?? "EMPTY",
                    overflow: TextOverflow.ellipsis,
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

  Widget buildDivider(ThemeData theme) {
    return Divider(
      color: theme.colorScheme.outline,
      height: 0.0,
    );
  }
}
