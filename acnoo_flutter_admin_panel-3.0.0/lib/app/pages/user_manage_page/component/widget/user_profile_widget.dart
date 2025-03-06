// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:acnoo_flutter_admin_panel/app/models/user/user_detail.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/service/user/user_manage_service.dart';

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

  //Service
  final UserManageService userManageService = UserManageService();

  //Future Model
  late Future<UserDetail> user;

  //User 단일 조회
  Future<UserDetail> getUser() async {
    try {
      return await userManageService.getUser(widget.userId);
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    user = getUser();
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(widget.padding),
          child: FutureBuilderFactory.createFutureBuilder(
              future: user,
              onSuccess: (context, user) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(widget.padding),
                      child: Container(
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
                              buildProfileDetailRow(lang.status, user.status.value),
                              buildDivider(),
                              buildProfileDetailRow(lang.type, user.loginType.value),
                              buildDivider(),
                              buildProfileDetailRow(lang.initAt, DateUtil.convertDateTimeToString(user.initAt)),
                              buildDivider(),
                              buildProfileDetailRow(lang.loginAt, DateUtil.convertDateTimeToString(user.loginAt)),
                              buildDivider(),
                              buildProfileDetailRow(lang.logoutAt, DateUtil.convertDateTimeToString(user.logoutAt)),
                              buildDivider(),
                              buildProfileDetailRow(lang.createdAt, DateUtil.convertDateTimeToString(user.createdAt)),
                              buildDivider(),
                              buildProfileDetailRow(lang.updatedAt, DateUtil.convertDateTimeToString(user.updatedAt)),
                              buildDivider(),
                              buildProfileDetailCheckBoxRow(lang.agreeTerm, user.agreeTerm),
                              buildDivider(),
                              buildProfileDetailCheckBoxRow(lang.agreePrivacy, user.agreePrivacy),
                              buildDivider(),
                              buildProfileDetailCheckBoxRow(lang.agreeSensitive, user.agreeSensitive),
                              buildDivider(),
                              buildProfileDetailCheckBoxRow(lang.agreeMarketing, user.agreeMarketing),
                              buildDivider(),
                              buildProfileDetailRow(lang.marketingModifiedAt, DateUtil.convertDateTimeToString(user.marketingModifiedAt)),
                            ],
                          )
                      ),
                    )
                  ],
                );
              }
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
                    value ?? "N/A",
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
              child: Row(children: [
                Checkbox(
                  value: value,
                  onChanged: (bool? value) {},
                ),
              ])),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return Divider(
      color: widget.theme.colorScheme.outline,
      height: 0.0,
    );
  }
}
