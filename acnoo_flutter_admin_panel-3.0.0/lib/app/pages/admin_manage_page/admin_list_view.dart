// 🎯 Dart imports:
import 'dart:ui';

// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/admin/admin_manage_service.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/admin_manage_page/widget/admin_mod_status_popup.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../core/constants/admin/admin_search_type.dart';
import '../../core/helpers/field_styles/_dropdown_styles.dart';
import '../../core/theme/_app_colors.dart';
import '../../core/utils/size_config.dart';
import '../../models/admin/admin.dart';
import '../../models/admin/admin_search_param.dart';
import '../../widgets/pagination_widgets/_pagination_widget.dart';
import '../../widgets/shadow_container/_shadow_container.dart';
import '../common_widget/custom_button.dart';
import '../common_widget/search_form_field.dart';
import 'widget/admin_add_popup.dart';

class AdminsListView extends StatefulWidget {
  const AdminsListView({super.key});

  @override
  State<AdminsListView> createState() => _AdminsListViewState();
}

class _AdminsListViewState extends State<AdminsListView> {
  final ScrollController scrollController = ScrollController();
  final AdminManageService adminManageService = AdminManageService();

  List<Admin> adminList = [];
  bool isLoading = true;

  //Paging
  int currentPage = 0;
  int rowsPerPage = 10;
  int totalPage = 0;

  //Search
  AdminSearchType searchType = AdminSearchType.NONE; //NONE, EMAIL, NAME, MOBILE
  String searchValue = "";

  //ADMIN 리스트 조회
  Future<void> getAdminList(BuildContext context) async {
    List<Admin> list = [];
    try {
      AdminSearchParam adminSearchParam = AdminSearchParam(
          searchType.value,
          searchValue,
          currentPage + 1,
          rowsPerPage
      );
      list = await adminManageService.getAdminList(adminSearchParam);
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    adminList = list;
  }

  //ADMIN 리스트 갯수 조회
  Future<void> getAdminListCount(BuildContext context) async {
    int count = 0;
    try {
      AdminSearchParam adminSearchParam = AdminSearchParam(
          searchType.value,
          searchValue,
          currentPage + 1,
          rowsPerPage
      );
      count = await adminManageService.getAdminListCount(adminSearchParam);
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    totalPage = (count / rowsPerPage).ceil();
  }

  //LIST + COUNT
  Future<void> searchListWithCount() async {
    setState(() => isLoading = true);
    await getAdminList(context);
    await getAdminListCount(context);
    setState(() => isLoading = false);
  }

  //LIST
  Future<void> searchList() async {
    setState(() => isLoading = true);
    await getAdminList(context);
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    searchListWithCount();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _sizeInfo = SizeConfig.getSizeInfo(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final lang = l.S.of(context);
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
                final isMobile = constraints.maxWidth < 481;
                final isTablet =
                    constraints.maxWidth < 992 && constraints.maxWidth >= 481;

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
                            flex: isTablet || isMobile ? 2 : 3,
                            child: SearchFormField(
                                textTheme: textTheme,
                                lang: lang,
                                onPressed: (searchValue) {
                                  this.searchValue = searchValue;
                                  searchListWithCount();
                                }),
                          ),
                          Spacer(flex: isTablet || isMobile ? 1 : 2),
                          CustomButton(
                              textTheme: textTheme,
                              label: lang.addNewAdmin,
                              onPressed: () => showAddFormDialog(context)
                          ),
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
                        child: isLoading
                            ? Center(child: CircularProgressIndicator())
                            : userListDataTable(
                                context, lang, theme, textTheme),
                      ),
                    ),

                    //______________________________________________________________________footer__________________
                    Padding(
                      padding: _sizeInfo.padding,
                      child: paginatedSection(theme, textTheme),
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

  //ADMIN 추가 팝업
  void showAddFormDialog(BuildContext context) async {
    bool success = await showDialog(
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

    if (success) {
      searchListWithCount();
    }
  }

  //ADMIN 상태 변경 팝업
  void showModStatusFormDialog(BuildContext context, Admin admin) async {
    bool success = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: AdminModStatusDialog(admin: admin));
      },
    );

    if (success) {
      searchListWithCount();
    }
  }

  ///_____________________________________go_next_page________________
  void goToNextPage() {
    if (currentPage < totalPage - 1) {
      currentPage++;
      getAdminList(context);
    }
  }

  ///_____________________________________go_previous_page____________
  void goToPreviousPage() {
    if (currentPage > 0) {
      currentPage--;
      getAdminList(context);
    }
  }

  ///_______________________________________________________________pagination_footer_______________________________
  Row paginatedSection(ThemeData theme, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '${l.S.of(context).showing} ${currentPage * rowsPerPage + 1} ${l.S.of(context).to} ${currentPage * rowsPerPage + adminList.length} ${l.S.of(context).OF} ${adminList.length} ${l.S.of(context).entries}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataTablePaginator(
          currentPage: currentPage + 1,
          totalPages: totalPage,
          onPreviousTap: goToPreviousPage,
          onNextTap: goToNextPage,
        )
      ],
    );
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
          searchType = value??AdminSearchType.NONE;
        },
      ),
    );
  }

  ///_______________________________________________________________User_List_Data_Table___________________________
  Theme userListDataTable(
      BuildContext context, l.S lang, ThemeData theme, TextTheme textTheme) {
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
          DataColumn(label: Text(lang.phone)),
          DataColumn(label: Text(lang.position)),
          DataColumn(label: Text(lang.status)),
          DataColumn(label: Text(lang.registeredOn)),
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
                DataCell(Text(data.mobile)),
                DataCell(Text(data.roleId.toString())),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: data.status == 'Active'
                          ? AcnooAppColors.kSuccess.withOpacity(0.2)
                          : AcnooAppColors.kError.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      data.status,
                      style: textTheme.bodySmall?.copyWith(
                          color: data.status == 'Active'
                              ? AcnooAppColors.kSuccess
                              : AcnooAppColors.kError),
                    ),
                  ),
                ),
                DataCell(Text(data.createdAt.toString())),
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
                              .go('/admins/info/${data.adminId}');
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
}
