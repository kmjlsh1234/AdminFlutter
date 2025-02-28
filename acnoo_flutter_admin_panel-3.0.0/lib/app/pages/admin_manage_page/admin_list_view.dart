// 🎯 Dart imports:
import 'dart:ui';

// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/admin/admin_manage_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/compare_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../constants/admin/admin_search_type.dart';
import '../../constants/admin/admin_status.dart';
import '../../core/helpers/field_styles/_dropdown_styles.dart';
import '../../core/theme/_app_colors.dart';
import '../../core/utils/size_config.dart';
import '../../models/admin/admin.dart';
import '../../models/admin/admin_search_param.dart';
import '../../widgets/pagination_widgets/_pagination_widget.dart';
import '../../widgets/shadow_container/_shadow_container.dart';
import '../common_widget/custom_button.dart';
import '../common_widget/search_form_field.dart';
import 'component/add_admin_popup.dart';
import 'component/mod_admin_status_popup.dart';

class AdminsListView extends StatefulWidget {
  const AdminsListView({super.key});

  @override
  State<AdminsListView> createState() => _AdminsListViewState();
}

class _AdminsListViewState extends State<AdminsListView> {

  //UI Controller
  final ScrollController scrollController = ScrollController();

  //Service
  final AdminManageService adminManageService = AdminManageService();

  //Future Model
  late Future<List<Admin>> adminList;

  //Paging
  int currentPage = 1;
  int rowsPerPage = 10;
  late Future<int> totalPage;

  //Search
  AdminSearchType searchType = AdminSearchType.none;
  String searchValue = '';

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
        searchType: CompareUtil.compareStringValue(AdminSearchType.none.value, searchType.value),
        searchValue: searchValue,
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
    final theme = Theme.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final lang = l.S.of(context);
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
                return FutureBuilderFactory.createFutureBuilder<List<Admin>>(
                    future: adminList,
                  onSuccess: (BuildContext context, adminList) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //______________________________________________________________________Header__________________
                          Padding(
                            padding: _sizeInfo.padding,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: searchTypeDropDown(textTheme),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  flex: 3,
                                  child: SearchFormField(
                                      textTheme: textTheme,
                                      lang: lang,
                                      onPressed: (searchValue) {
                                        this.searchValue = searchValue;
                                        loadAllData();
                                      }),
                                ),
                                Spacer(flex: 2),
                                CustomButton(
                                    textTheme: textTheme,
                                    label: lang.addNewAdmin,
                                    onPressed: () => showAddFormDialog(context)),
                              ],
                            ),
                          ),

                          //______________________________________________________________________Data_table__________________
                          SingleChildScrollView(
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: constraints.maxWidth,
                              ),
                              child: dataTable(adminList, textTheme, theme, lang),
                            ),
                          ),

                          //______________________________________________________________________footer__________________
                          Padding(
                              padding: _sizeInfo.padding,
                              child: FutureBuilderFactory.createFutureBuilder(
                                  future: totalPage,
                                  onSuccess: (context, totalPage) {
                                    return paginatedSection(totalPage, adminList);
                                  }
                              ),

                          )
                        ],
                      );
                  });
              },
            ),
          ),
        ),
      ),
    );
  }

  //ADMIN 추가 팝업
  void showAddFormDialog(BuildContext context) async {
    bool? isSuccess = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: const AddAdminDialog());
      },
    );

    if (isSuccess != null && isSuccess) {
      loadAllData();
    }
  }

  //ADMIN 상태 변경 팝업
  void showModStatusFormDialog(BuildContext context, Admin admin) async {
    bool? isSuccess = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: ModAdminStatusDialog(admin: admin));
      },
    );

    if (isSuccess != null && isSuccess) {
      loadAllData();
    }
  }

  ///_______________________________________________________________DropDownList___________________________________
  Container searchTypeDropDown(TextTheme textTheme) {
    final dropdownStyle = AcnooDropdownStyle(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 100, minWidth: 100),
      child: DropdownButtonFormField2<AdminSearchType>(
        hint: Text('검색 조건'),
        style: dropdownStyle.textStyle,
        iconStyleData: dropdownStyle.iconStyle,
        buttonStyleData: dropdownStyle.buttonStyle,
        dropdownStyleData: dropdownStyle.dropdownStyle,
        menuItemStyleData: dropdownStyle.menuItemStyle,
        isExpanded: true,
        value: searchType,
        items: AdminSearchType.values.map((AdminSearchType searchType) {
          return DropdownMenuItem<AdminSearchType>(
            value: searchType,
            child: Text(
              searchType.value,
              style: textTheme.bodySmall,
            ),
          );
        }).toList(),
        onChanged: (value) {
          searchType = value ?? AdminSearchType.none;
        },
      ),
    );
  }

  Theme dataTable(List<Admin> adminList, TextTheme textTheme, ThemeData theme, l.S lang) {

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
          DataColumn(label: Text(lang.actions)),
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
                      color: data.status == AdminStatus.normal.value
                          ? AcnooAppColors.kSuccess.withOpacity(0.2)
                          : AcnooAppColors.kError.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      data.status,
                      style: textTheme.bodySmall?.copyWith(
                          color: data.status == AdminStatus.normal.value
                              ? AcnooAppColors.kSuccess
                              : AcnooAppColors.kError),
                    ),
                  ),
                ),
                DataCell(
                    Text(DateUtil.convertDateTimeToString(data.createdAt))),
                DataCell(
                  PopupMenuButton<String>(
                    iconColor: theme.colorScheme.onTertiary,
                    color: theme.colorScheme.primaryContainer,
                    onSelected: (action) {
                      switch (action) {
                        case 'Edit Status':
                          showModStatusFormDialog(context, data);
                          break;
                        case 'View':
                          GoRouter.of(context)
                              .go('/admins/profile/${data.adminId}');
                          break;
                        case 'Delete':
                          setState(() {});
                          break;
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'Edit Status',
                          child: Text(
                            lang.editStatus,
                            //'Edit',
                            style: textTheme.bodyMedium,
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'View',
                          child: Text(lang.view,
                              // 'View',
                              style: textTheme.bodyMedium),
                        ),
                        PopupMenuItem<String>(
                          value: 'Delete',
                          child: Text(lang.delete,
                              // 'Delete',
                              style: textTheme.bodyMedium),
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

  Row paginatedSection(int totalPage, List<Admin> adminList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '${l.S.of(context).showing} ${(currentPage - 1) * rowsPerPage + 1} ${l.S.of(context).to} ${(currentPage - 1) * rowsPerPage + adminList.length} ${l.S.of(context).OF} ${adminList.length} ${l.S.of(context).entries}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataTablePaginator(
          currentPage: currentPage,
          totalPages: totalPage,
          onPreviousTap: () {
            if (currentPage > 1) {
              setState(() {
                currentPage--;
                this.adminList = getAdminList();
              });
            }
          },
          onNextTap: () {
            if (currentPage < totalPage) {
              setState(() {
                currentPage++;
                this.adminList = getAdminList();
              });
            }
          },
        )
      ],
    );
  }
}
