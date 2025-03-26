import 'package:acnoo_flutter_admin_panel/app/constants/admin/admin_status.dart';
import 'package:acnoo_flutter_admin_panel/app/constants/common/action_menu.dart';
import 'package:acnoo_flutter_admin_panel/app/core/theme/_app_colors.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:acnoo_flutter_admin_panel/app/models/admin/admin.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart' as l;

class AdminTable extends StatelessWidget {
  final List<Admin> adminList;
  final void Function(Admin) editAction;
  final l.S lang;
  final ThemeData theme;
  final TextTheme textTheme;
  final BuildContext parentContext;

  const AdminTable({
    super.key,
    required this.adminList,
    required this.editAction,
    required this.lang,
    required this.theme,
    required this.textTheme,
    required this.parentContext
  });

  @override
  Widget build(BuildContext context) {

    return Theme(
      data: ThemeData(
          dividerColor: theme.colorScheme.outline,
          dividerTheme: DividerThemeData(
            color: theme.colorScheme.outline,
          )
      ),
      child: DataTable(
        checkboxHorizontalMargin: 16,
        headingTextStyle: textTheme.titleMedium,
        dataTextStyle: textTheme.bodySmall,
        headingRowColor: WidgetStateProperty.all(theme.colorScheme.surface),
        showBottomBorder: true,
        columns: buildTableColumn(),
        rows: adminList.map((admin) => buildDataRow(admin)).toList(),
      ),
    );
  }

  List<DataColumn> buildTableColumn(){
    return [
      DataColumn(label: Text(lang.adminId)),
      DataColumn(label: Text(lang.name)),
      DataColumn(label: Text(lang.email)),
      DataColumn(label: Text(lang.status)),
      DataColumn(label: Text(lang.createdAt)),
      DataColumn(label: Text(lang.actions)),
    ];
  }

  DataRow buildDataRow(Admin admin){
    return DataRow(
      color: WidgetStateColor.transparent,
      cells: [
        DataCell(Text(admin.adminId.toString())),
        DataCell(Text(admin.name)),
        DataCell(Text(admin.email)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: selectStatusColor(admin.status.value, 0.2),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Text(
              admin.status.value,
              style: textTheme.bodySmall?.copyWith(color:selectStatusColor(admin.status.value, 1)),
            ),
          ),
        ),
        DataCell(Text(DateUtil.convertDateTimeToString(admin.createdAt))),
        DataCell(
          PopupMenuButton<ActionMenu>(
            iconColor: theme.colorScheme.onTertiary,
            color: theme.colorScheme.primaryContainer,
            onSelected: (action) {
              switch (action) {
                case ActionMenu.EDIT_STATUS:
                  editAction(admin);
                  break;
                case ActionMenu.VIEW:
                  GoRouter.of(parentContext).go('/admins/profile/${admin.adminId}');
                  break;
                default:
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem<ActionMenu>(
                  value: ActionMenu.EDIT_STATUS,
                  child: Text(lang.editStatus),
                ),
                PopupMenuItem<ActionMenu>(
                  value: ActionMenu.VIEW,
                  child: Text(lang.view),
                ),
              ];
            },
          ),
        ),
      ],
    );
  }

  Color selectStatusColor(String status, double alpha){
    if(status == AdminStatus.NORMAL.value) {
      return AcnooAppColors.kSuccess.withValues(alpha: alpha);
    } else if(status == AdminStatus.LOGOUT.value) {
      return AcnooAppColors.kInfo.withValues(alpha: alpha);
    }
    else if(status == AdminStatus.EXIT.value) {
      return AcnooAppColors.kWarning.withValues(alpha: alpha);
    }
    else if(status == AdminStatus.BAN.value) {
      return AcnooAppColors.kError.withValues(alpha: alpha);
    }
    else if(status == AdminStatus.STOP.value) {
      return AcnooAppColors.kError20Op.withValues(alpha: alpha);
    }
    else {
      return AcnooAppColors.kSuccess.withValues(alpha: alpha);
    }
  }
}