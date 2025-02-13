// 🐦 Flutter imports:
import 'dart:ui';

import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/user_manage_page/user_mod_popup.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../core/service/user/user_manage_service.dart';
import '../../core/theme/_app_colors.dart';
import '../../models/user/user_detail.dart';

class UserProfileWidget extends StatefulWidget {
  const UserProfileWidget({
    super.key,
    required double padding,
    required this.theme,
    required this.textTheme,
    required this.userId,
  }) : _padding = padding;

  final int userId;
  final double _padding;
  final ThemeData theme;
  final TextTheme textTheme;

  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  bool isLoading = true;
  late UserDetail userDetail;
  final UserManageService userManageService = UserManageService();

  Future<void> getUserDetail(BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      UserDetail result = await userManageService.getUser(widget.userId);
      userDetail = result;
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetail(context);
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
                      buildProfileDetailRow(
                          '${lang.fullName}', userDetail.nickname, textTheme),
                      Divider(
                        color: theme.colorScheme.outline,
                        height: 0.0,
                      ),
                      buildProfileDetailRow(
                          lang.email, userDetail.email, textTheme),
                      Divider(
                        color: theme.colorScheme.outline,
                        height: 0.0,
                      ),
                      buildProfileDetailRow(
                          lang.phoneNumber, userDetail.mobile, textTheme),
                      Divider(
                        color: theme.colorScheme.outline,
                        height: 0.0,
                      ),
                      buildProfileDetailRow(
                          lang.status, userDetail.status, textTheme),
                      Divider(
                        color: theme.colorScheme.outline,
                        height: 0.0,
                      ),
                      buildProfileDetailRow(
                          lang.type, userDetail.userType, textTheme),
                      Divider(
                        color: theme.colorScheme.outline,
                        height: 0.0,
                      ),
                      buildProfileDetailRow(
                          lang.loginAt, userDetail.loginAt, textTheme),
                      Divider(
                        color: theme.colorScheme.outline,
                        height: 0.0,
                      ),
                      buildProfileDetailRow(
                          lang.logoutAt, userDetail.logoutAt, textTheme),
                      Divider(
                        color: theme.colorScheme.outline,
                        height: 0.0,
                      ),
                      buildProfileDetailRow(
                          lang.createdAt, userDetail.createdAt, textTheme),
                      Divider(
                        color: theme.colorScheme.outline,
                        height: 0.0,
                      ),
                      buildProfileDetailRow(
                          lang.updatedAt, userDetail.updatedAt, textTheme),
                      Divider(
                        color: theme.colorScheme.outline,
                        height: 0.0,
                      ),
                      buildProfileDetailCheckBoxRow(lang.agreeTerm, userDetail.agreeTerm, textTheme),
                      Divider(
                        color: theme.colorScheme.outline,
                        height: 0.0,
                      ),
                      buildProfileDetailCheckBoxRow(lang.agreePrivacy, userDetail.agreePrivacy, textTheme),
                      Divider(
                        color: theme.colorScheme.outline,
                        height: 0.0,
                      ),
                      buildProfileDetailCheckBoxRow(lang.agreeSensitive, userDetail.agreeSensitive, textTheme),
                      Divider(
                        color: theme.colorScheme.outline,
                        height: 0.0,
                      ),
                      buildProfileDetailCheckBoxRow(lang.agreeMarketing, userDetail.agreeMarketing, textTheme),
                      Divider(
                        color: theme.colorScheme.outline,
                        height: 0.0,
                      ),
                      buildProfileDetailRow(lang.marketingModifiedAt, userDetail.marketingModifiedAt, textTheme),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget buildProfileDetailRow(
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

  Widget buildProfileDetailCheckBoxRow(String label, bool value, TextTheme textTheme) {
    return Padding(
      padding: EdgeInsets.all(10),
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
}
