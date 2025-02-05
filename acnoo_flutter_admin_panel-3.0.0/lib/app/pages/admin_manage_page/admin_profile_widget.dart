// 🐦 Flutter imports:
import 'dart:ui';

import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/admin/admin_manage_service.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../core/theme/_app_colors.dart';
import '../../models/admin/admin.dart';
import 'admin_mod_popup.dart';

class AdminProfileWidget extends StatefulWidget {
  const AdminProfileWidget({
    super.key,
    required double padding,
    required this.theme,
    required this.textTheme,
    required this.adminId,
  }) : _padding = padding;

  final int adminId;
  final double _padding;
  final ThemeData theme;
  final TextTheme textTheme;

  @override
  State<AdminProfileWidget> createState() => _AdminProfileWidgetState();
}

class _AdminProfileWidgetState extends State<AdminProfileWidget> {
  bool isLoading = true;
  late Admin admin;
  final AdminManageService adminManageService = AdminManageService();

  Future<void> getAdmin(BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      Admin result = await adminManageService.getAdmin(widget.adminId);
      admin = result;
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    setState(() {
      isLoading = false;
    });
  }

  void showFormDialog(BuildContext context) async {
    bool isUserMod = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: AdminModDialog(admin: admin));
      },
    );

    if(isUserMod){
      getAdmin(context);
    }
  }

  @override
  void initState() {
    super.initState();
    getAdmin(context);
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(widget._padding),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : admin == null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          lang.Error, // 데이터 없을 때 메시지
                          style: textTheme.bodyLarge,
                        ),
                      ),
                    )
                  : Container(
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
                          _buildProfileDetailRow(
                              '${lang.fullName}', admin.name, textTheme),
                          Divider(
                            color: theme.colorScheme.outline,
                            height: 0.0,
                          ),
                          _buildProfileDetailRow(
                              lang.email, admin.email, textTheme),
                          Divider(
                            color: theme.colorScheme.outline,
                            height: 0.0,
                          ),
                          _buildProfileDetailRow(
                              lang.phoneNumber, admin.mobile, textTheme),
                          Divider(
                            color: theme.colorScheme.outline,
                            height: 0.0,
                          ),
                          _buildProfileDetailRow(
                              lang.loginAt, admin.loginAt, textTheme),
                          Divider(
                            color: theme.colorScheme.outline,
                            height: 0.0,
                          ),
                          _buildProfileDetailRow(
                              lang.createdAt, admin.createdAt, textTheme),
                          Divider(
                            color: theme.colorScheme.outline,
                            height: 0.0,
                          ),
                          _buildProfileDetailRow(lang.updatedAt, admin.updatedAt, textTheme),
                        ],
                      ),
                    ),
        ),
        Padding(
          padding: EdgeInsets.all(widget._padding),
          child: Container(
            color: theme.colorScheme.primaryContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                modAdminButton(textTheme),
              ],
            ),
          )
        )
      ],
    );
  }

  ElevatedButton modAdminButton(TextTheme textTheme) {
    final lang = l.S.of(context);
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: () {
        showFormDialog(context);
      },
      label: Text(
        lang.modAdmin,
        style: textTheme.bodySmall?.copyWith(
          color: AcnooAppColors.kWhiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProfileDetailRow(
      String label, String? value, TextTheme textTheme) {
    return Padding(
      padding: EdgeInsets.all(widget._padding),
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
                    value??"EMPTY",
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
}
