// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../../../../generated/l10n.dart' as l;
import '../../../../core/service/menus/role_service.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/date_util.dart';
import '../../../../core/utils/future_builder_factory.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/common/paging_param.dart';
import '../../../../models/menus/role/role.dart';
import '../../../../widgets/pagination_widgets/_pagination_widget.dart';

class SearchRoleDialog extends StatefulWidget {
  const SearchRoleDialog({super.key});

  @override
  State<SearchRoleDialog> createState() => _SearchRoleDialogState();
}

class _SearchRoleDialogState extends State<SearchRoleDialog> {
  final RoleService roleService = RoleService();
  late Future<List<Role>> roleList;

  //Paging
  int currentPage = 1;
  int rowsPerPage = 10;
  late Future<int> totalPage;

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //역할 리스트 조회
  Future<List<Role>> getRoleList() async {
    try {
      PagingParam pagingParam = PagingParam(currentPage, rowsPerPage);
      return await roleService.getRoleList(pagingParam);
    } catch (e) {
      ErrorHandler.handleError(e, context);
      return [];
    }
  }

  //역할 리스트 갯수 조회
  Future<int> getTotalCount() async {
    try {
      int count = await roleService.getRoleListCount();
      int totalPage = (count / rowsPerPage).ceil();
      return totalPage;
    } catch (e) {
      ErrorHandler.handleError(e, context);
      return 0;
    }
  }

  void loadAllData() {
    setState(() {
      roleList = getRoleList();
      totalPage = getTotalCount();
    });
  }

  @override
  void initState(){
    super.initState();
    loadAllData();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    lang = l.S.of(context);
    theme = Theme.of(context);
    textTheme = Theme.of(context).textTheme;
    final _sizeInfo = SizeConfig.getSizeInfo(context);

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
                  Text(lang.role),
                  IconButton(
                    onPressed: () => GoRouter.of(context).pop(null),
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
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width * 0.8,
                            ),
                            child: FutureBuilderFactory.createFutureBuilder(
                                future: roleList,
                                onSuccess: (context, roleList) {
                                  return dataTable(roleList);
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
                            }
                        ),
                      ),
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

  Theme dataTable(List<Role> roleList) {
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
          DataColumn(label: Text(lang.roleId)),
          DataColumn(label: Text(lang.name)),
          DataColumn(label: Text(lang.description)),
          DataColumn(label: Text(lang.createdAt)),
        ],
        rows: roleList.map(
              (data) {
            return DataRow(
              onSelectChanged: (bool? selected) => GoRouter.of(context).pop(data),
              color: WidgetStateColor.transparent,
              cells: [
                DataCell(Text(data.id.toString())),
                DataCell(Text(data.roleName)),
                DataCell(Text(data.description)),
                DataCell(Text(DateUtil.convertDateTimeToString(data.createdAt))),
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
                roleList = getRoleList();
              });
            }
          },
          onNextTap: () {
            if (currentPage < totalPage) {
              setState(() {
                currentPage++;
                roleList = getRoleList();
              });
            }
          },
        )
      ],
    );
  }
}

