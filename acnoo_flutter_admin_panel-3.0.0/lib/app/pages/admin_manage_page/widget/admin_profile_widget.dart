// 🐦 Flutter imports:
import 'dart:ui';

import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/admin/admin_manage_service.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../models/admin/admin.dart';
import '../../common_widget/custom_button.dart';
import 'admin_mod_popup.dart';

class AdminProfileWidget extends StatefulWidget {
  const AdminProfileWidget({
    super.key,
    required this.padding,
    required this.theme,
    required this.textTheme,
    required this.adminId,
  });

  final int adminId;
  final double padding;
  final ThemeData theme;
  final TextTheme textTheme;

  @override
  State<AdminProfileWidget> createState() => _AdminProfileWidgetState();
}

class _AdminProfileWidgetState extends State<AdminProfileWidget> {
  final AdminManageService adminManageService = AdminManageService();
  late Admin admin;
  bool isLoading = true;

  //ADMIN 단일 조회
  Future<void> getAdmin(BuildContext context) async {
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
                          buildProfileDetailRow(lang.fullName, admin.name),
                          buildDivider(),
                          buildProfileDetailRow(lang.email, admin.email),
                          buildDivider(),
                          buildProfileDetailRow(lang.phoneNumber, admin.mobile),
                          buildDivider(),
                          buildProfileDetailRow(lang.loginAt, admin.loginAt.toString()),
                          buildDivider(),
                          buildProfileDetailRow(lang.createdAt, admin.createdAt.toString()),
                          buildDivider(),
                          buildProfileDetailRow(lang.updatedAt, admin.updatedAt.toString()),
                        ],
                      ),
                    ),
        ),
        Padding(
          padding: EdgeInsets.all(widget.padding),
          child: Container(
            color: widget.theme.colorScheme.primaryContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomButton(
                    textTheme: widget.textTheme,
                    label: lang.modAdmin,
                    onPressed: () => showModDialog(context)
                ),
              ],
            ),
          )
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

  Widget buildDivider(){
    return Divider(
      color: widget.theme.colorScheme.outline,
      height: 0.0,
    );
  }
}
