// 🎯 Dart imports:
import 'dart:ui';

// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:acnoo_flutter_admin_panel/app/models/menus/privilege/privilege_search_param.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/menus_page/privilege/component/add_privilege_popup.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../constants/common/action_menu.dart';
import '../../../constants/menus/privilege/privilege_type.dart';
import '../../../core/service/menus/privilege_service.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/menus/privilege/privilege.dart';
import '../../../widgets/pagination_widgets/_pagination_widget.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';
import '../../common_widget/custom_button.dart';
import 'component/mod_privilege_popup.dart';

class PrivilegeListView extends StatefulWidget {
  const PrivilegeListView({super.key});

  @override
  State<PrivilegeListView> createState() => _PrivilegeListViewState();
}

class _PrivilegeListViewState extends State<PrivilegeListView> {

  final PrivilegeService privilegeService = PrivilegeService();
  late Future<List<Privilege>> privilegeList;

  PrivilegeType privilegeType = PrivilegeType.MENU;

  //Paging
  int currentPage = 1;
  int rowsPerPage = 10;
  late Future<int> totalPage;

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //권한 리스트 조회
  Future<List<Privilege>> getPrivilegeList() async {
    try {
      return await privilegeService.getPrivilegeList(getPrivilegeSearchParam());
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  //권한 리스트 갯수 조회
  Future<int> getTotalCount() async {
    try {
      int count = await privilegeService.getPrivilegeListCount(
          getPrivilegeSearchParam());
      return (count / rowsPerPage).ceil();
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  //권한 삭제
  Future<void> delPrivilege(int privilegeId) async {
    try {
      await privilegeService.delPrivilege(privilegeId);
      loadAllData();
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  PrivilegeSearchParam getPrivilegeSearchParam() {
    return PrivilegeSearchParam(
        searchType: null,
        searchValue: null,
        page: currentPage,
        limit: rowsPerPage
    );
  }

  void loadAllData() {
    setState(() {
      privilegeList = getPrivilegeList();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    lang = l.S.of(context);
    theme = Theme.of(context);
    textTheme = Theme.of(context).textTheme;
    final _sizeInfo = SizeConfig.getSizeInfo(context);

    return Scaffold(
      body: Padding(
        padding: _sizeInfo.padding,
        child: ShadowContainer(
          showHeader: false,
          contentPadding: EdgeInsets.zero,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //______________________________________________________________________Header__________________
                    Padding(
                      padding: _sizeInfo.padding,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Spacer(flex: 2),
                          CustomButton(
                              textTheme: textTheme,
                              label: lang.addNewPrivilege,
                              onPressed: () => showAddFormDialog()),
                        ],
                      ),
                    ),

                    //______________________________________________________________________Data_table__________________
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: constraints.maxWidth),
                          child: FutureBuilderFactory.createFutureBuilder(
                              future: privilegeList,
                              onSuccess: (context, privilegeList){
                                return dataTable(privilegeList);
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Theme dataTable(List<Privilege> privilegeList) {
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
          DataColumn(label: Text(lang.privilegeId)),
          DataColumn(label: Text(lang.menuName)),
          DataColumn(label: Text(lang.privilegeName)),
          DataColumn(label: Text(lang.privilegeCode)),
          DataColumn(label: Text(lang.createdAt)),
          DataColumn(label: Text(lang.actions)),
        ],
        rows: privilegeList.map(
              (data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              cells: [
                DataCell(Text(data.id.toString())),
                DataCell(Text(data.menuName ?? lang.empty)),
                DataCell(Text(data.privilegeName)),
                DataCell(Text(data.privilegeCode)),
                DataCell(Text(DateUtil.convertDateTimeToString(data.createdAt))),
                DataCell(
                  PopupMenuButton<ActionMenu>(
                    iconColor: theme.colorScheme.onTertiary,
                    color: theme.colorScheme.primaryContainer,
                    onSelected: (action) {
                      switch (action) {
                        case ActionMenu.EDIT:
                          showModFormDialog(data);
                          break;
                        case ActionMenu.DELETE:
                          delPrivilege(data.id);
                          break;
                        default:
                          break;
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<ActionMenu>(
                          value: ActionMenu.EDIT,
                          child: Text(lang.edit),
                        ),
                        PopupMenuItem<ActionMenu>(
                          value: ActionMenu.DELETE,
                          child: Text(lang.delete),
                        ),
                      ];
                    },
                  ),
                ),
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
                privilegeList = getPrivilegeList();
              });
            }
          },
          onNextTap: () {
            if (currentPage < totalPage) {
              setState(() {
                currentPage++;
                privilegeList = getPrivilegeList();
              });
            }
          },
        )
      ],
    );
  }

  void showAddFormDialog() async {
    bool? isSuccess = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: const AddPrivilegeDialog()
        );
      },
    );

    if (isSuccess != null && isSuccess) {
      loadAllData();
    }
  }

  void showModFormDialog(Privilege privilege) async {
    bool? isSuccess = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: ModPrivilegeDialog(privilege: privilege)
        );
      },
    );

    if (isSuccess != null && isSuccess) {
      loadAllData();
    }
  }
}
