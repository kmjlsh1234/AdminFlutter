// 🐦 Flutter imports:
import 'dart:ui';

import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/admin/admin_manage_service.dart';
import 'package:acnoo_flutter_admin_panel/app/models/user/user_detail.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../core/service/user/user_manage_service.dart';
import '../../../models/admin/admin.dart';
import '../../common_widget/custom_button.dart';
import '../../tables_page/_basic_table_view.dart';

class UserProfileWidget extends StatefulWidget {
  const UserProfileWidget({
    super.key,
    required this.padding,
    required this.theme,
    required this.textTheme,
    required this.userId,
  });

  final int userId;
  final double padding;
  final ThemeData theme;
  final TextTheme textTheme;


  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  final UserManageService userManageService = UserManageService();
  late UserDetail user;
  bool isLoading = true;

  //User 단일 조회
  Future<void> getUser(BuildContext context) async {
    try {
      setState(() => isLoading = true);
      UserDetail user = await userManageService.getUser(widget.userId);
      this.user = user;
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getUser(context);
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(widget.padding),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                      decoration: BoxDecoration(
                        color: widget.theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: widget.theme.colorScheme.outline,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildProfileDetailRow(lang.fullName, user.nickname),
                          buildDivider(),
                          buildProfileDetailRow(lang.email, user.email),
                          buildDivider(),
                          buildProfileDetailRow(lang.phoneNumber, user.mobile),
                          buildDivider(),
                          buildProfileDetailRow(lang.status, user.status),
                          buildDivider(),
                          buildProfileDetailRow(lang.type, user.userType),
                          buildDivider(),
                          buildProfileDetailRow(lang.loginAt, user.loginAt),
                          buildDivider(),
                          buildProfileDetailRow(lang.logoutAt, user.logoutAt),
                          buildDivider(),
                          buildProfileDetailRow(lang.createdAt, user.createdAt),
                          buildDivider(),
                          buildProfileDetailRow(lang.updatedAt, user.updatedAt),
                          buildDivider(),
                          buildProfileDetailCheckBoxRow(lang.agreeTerm, user.agreeTerm),
                          buildDivider(),
                          buildProfileDetailCheckBoxRow(lang.agreePrivacy, user.agreePrivacy),
                          buildDivider(),
                          buildProfileDetailCheckBoxRow(lang.agreeSensitive, user.agreeSensitive),
                          buildDivider(),
                          buildProfileDetailCheckBoxRow(lang.agreeMarketing, user.agreeMarketing),
                          buildDivider(),
                          buildProfileDetailRow(lang.marketingModifiedAt, user.marketingModifiedAt),
                        ],
                      ),
                    ),
        )
      ],
    );
  }

  Widget buildProfileDetailRow(String label, String? value) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: widget.textTheme.bodyLarge,
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
                  style: widget.textTheme.bodyMedium,
                ),
                const SizedBox(width: 8.0),
                Flexible(
                  child: Text(
                    value??"EMPTY",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: widget.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileDetailCheckBoxRow(String label, bool value) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: widget.textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),

          Expanded(
              flex: 3,
              child: Row(
                  children: [
                    Checkbox(
                      value: value, onChanged: (bool? value) {  },
                    ),
                  ]
              )
          ),
        ],
      ),
    );
  }

  Widget buildDivider(){
    return Divider(
      color: widget.theme.colorScheme.outline,
      height: 0.0,
    );
  }
}
