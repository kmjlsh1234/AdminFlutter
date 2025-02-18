// 🐦 Flutter imports:
import 'dart:ui';

import 'package:acnoo_flutter_admin_panel/app/pages/admin_manage_page/widget/admin_mod_popup.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/admin_manage_page/widget/admin_nav_tab_bar.dart';
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
  late Admin admin;
  bool isLoading = true;

  //ADMIN 단일 조회
  Future<void> getAdmin() async {
    try {
      setState(() => isLoading = true);
      Admin admin = await adminManageService.getAdmin(widget.adminId);
      this.admin = admin;
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    setState(() => isLoading = false);
  }

  void showModDialog(BuildContext context) async {
    bool isUserMod = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AdminModDialog(admin: admin));
      },
    );

    if (isUserMod) {
      getAdmin();
    }
  }

  @override
  void initState() {
    super.initState();
    getAdmin();
  }

  @override
  void dispose(){
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final l.S lang = l.S.of(context);
    final double padding = 16;

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Padding(
                  padding: EdgeInsets.all(padding),
                  child: ShadowContainer(
                    contentPadding: EdgeInsets.zero,
                    customHeader: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: AdminNavTabBar(onTabSelected: (value) {
                                setState(() {
                                  currentMenu = AdminMenu.values.firstWhere(
                                    (menu) => menu.value == value,
                                    orElse: () => AdminMenu.profile,
                                  );
                                });
                              }),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(padding),
                                child: isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: theme
                                              .colorScheme.primaryContainer,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          border: Border.all(
                                            color: theme.colorScheme.outline,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            buildProfileDetailRow(lang.fullName, admin.name, padding, textTheme),
                                            buildDivider(theme),
                                            buildProfileDetailRow(lang.email, admin.email, padding, textTheme),
                                            buildDivider(theme),
                                            buildProfileDetailRow(lang.phoneNumber, admin.mobile, padding, textTheme),
                                            buildDivider(theme),
                                            buildProfileDetailRow(lang.loginAt, admin.loginAt.toString(), padding, textTheme),
                                            buildDivider(theme),
                                            buildProfileDetailRow(
                                                lang.createdAt, admin.createdAt.toString(), padding, textTheme),
                                            buildDivider(theme),
                                            buildProfileDetailRow(
                                                lang.updatedAt, admin.updatedAt.toString(), padding, textTheme),
                                          ],
                                        ),
                                      ),
                              ),
                              Padding(
                                  padding: EdgeInsets.all(padding),
                                  child: Container(
                                    color: theme.colorScheme.primaryContainer,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomButton(
                                            textTheme: textTheme,
                                            label: lang.modAdmin,
                                            onPressed: () =>
                                                showModDialog(context)),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget buildProfileDetailRow(String label, String? value, double padding, TextTheme textTheme) {
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
