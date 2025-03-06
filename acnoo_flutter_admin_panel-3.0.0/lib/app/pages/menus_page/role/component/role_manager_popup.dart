// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../constants/admin/admin_status.dart';
import '../../../../core/service/admin/admin_manage_service.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/date_util.dart';
import '../../../../core/utils/future_builder_factory.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/admin/admin.dart';
import '../../../../models/admin/admin_search_param.dart';
import '../../../../widgets/pagination_widgets/_pagination_widget.dart';

class RoleManagerDialog extends StatefulWidget {
  const RoleManagerDialog({super.key, required this.roleId});

  final int roleId;

  @override
  State<RoleManagerDialog> createState() => _RoleManagerDialogState();
}

class _RoleManagerDialogState extends State<RoleManagerDialog> {
  final ScrollController scrollController = ScrollController();
  final AdminManageService adminManageService = AdminManageService();

  //Future Model
  late Future<List<Admin>> adminList;

  //Paging
  int currentPage = 1;
  int rowsPerPage = 10;
  late Future<int> totalPage;

  //ADMIN 리스트 조회
  Future<List<Admin>> getAdminList() async {
    try {
      return await adminManageService.getAdminList(getAdminSearchParam());
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  //ADMIN 리스트 갯수 조회
  Future<int> getTotalCount() async {
    try {
      int count =
          await adminManageService.getAdminListCount(getAdminSearchParam());
      return (count / rowsPerPage).ceil();
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  AdminSearchParam getAdminSearchParam() {
    return AdminSearchParam(
        roleId: widget.roleId,
        searchType: null,
        searchValue: null,
        page: currentPage,
        limit: rowsPerPage);
  }

  void loadAllData() {
    setState(() {
      adminList = getAdminList();
      totalPage = getTotalCount();
    });
  }

  @override
  void initState() {
    super.initState();
    loadAllData();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
                  Text(lang.roleManager),
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
                width: MediaQuery.of(context).size.width * 0.8,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //______________________________________________________________________Data_table__________________
                      SingleChildScrollView(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width * 0.8,
                          ),
                          child: FutureBuilderFactory.createFutureBuilder(
                              future: adminList,
                              onSuccess: (context, adminList){
                                return dataTable(adminList, theme, textTheme, lang);
                              }),
                        ),
                      ),

                      //______________________________________________________________________footer__________________
                      Padding(
                        padding: _sizeInfo.padding,
                        child: FutureBuilderFactory.createFutureBuilder(
                            future: totalPage,
                            onSuccess: (context, totalPage) {
                              return paginatedSection(totalPage);
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Theme dataTable(
      List<Admin> adminList, ThemeData theme, TextTheme textTheme, l.S lang) {
    return Theme(
      data: ThemeData(
          dividerColor: theme.colorScheme.outline,
          dividerTheme: DividerThemeData(
            color: theme.colorScheme.outline,
          )),
      child: DataTable(
        checkboxHorizontalMargin: 16,
        headingTextStyle: textTheme.titleMedium,
        dataTextStyle: textTheme.bodySmall,
        headingRowColor: WidgetStateProperty.all(theme.colorScheme.surface),
        showBottomBorder: true,
        columns: [
          DataColumn(label: Text(lang.serial)),
          DataColumn(label: Text(lang.userName)),
          DataColumn(label: Text(lang.email)),
          DataColumn(label: Text(lang.position)),
          DataColumn(label: Text(lang.status)),
          DataColumn(label: Text(lang.createdAt)),
        ],
        rows: adminList.map(
          (data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              cells: [
                DataCell(Text(data.adminId.toString())),
                DataCell(Text(data.name)),
                DataCell(Text(data.email)),
                DataCell(Text(data.roleId.toString())),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: selectStatusColor(data.status.value, 0.2),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      data.status.value,
                      style: textTheme.bodySmall
                          ?.copyWith(color: selectStatusColor(data.status.value, 1)),
                    ),
                  ),
                ),
                DataCell(
                    Text(DateUtil.convertDateTimeToString(data.createdAt))),
              ],
            );
          },
        ).toList(),
      ),
    );
  }

  Row paginatedSection(int totalPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DataTablePaginator(
          currentPage: currentPage,
          totalPages: totalPage,
          onPreviousTap: () {
            if (currentPage > 1) {
              setState(() {
                currentPage--;
                adminList = getAdminList();
              });
            }
          },
          onNextTap: () {
            if (currentPage < totalPage) {
              setState(() {
                currentPage++;
                adminList = getAdminList();
              });
            }
          },
        )
      ],
    );
  }

  Color selectStatusColor(String status, double alpha) {
    if (status == AdminStatus.NORMAL.value) {
      return AcnooAppColors.kSuccess.withValues(alpha: alpha);
    } else if (status == AdminStatus.LOGOUT.value) {
      return AcnooAppColors.kInfo.withValues(alpha: alpha);
    } else if (status == AdminStatus.EXIT.value) {
      return AcnooAppColors.kWarning.withValues(alpha: alpha);
    } else if (status == AdminStatus.BAN.value) {
      return AcnooAppColors.kError.withValues(alpha: alpha);
    } else if (status == AdminStatus.STOP.value) {
      return AcnooAppColors.kError20Op.withValues(alpha: alpha);
    } else {
      return AcnooAppColors.kSuccess.withValues(alpha: alpha);
    }
  }
}
