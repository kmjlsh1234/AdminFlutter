// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../constants/menus/menu/menu_search_type.dart';
import '../../../../constants/menus/menu/menu_visibility.dart';
import '../../../../core/helpers/field_styles/_dropdown_styles.dart';
import '../../../../core/service/menus/menu_service.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/date_util.dart';
import '../../../../core/utils/future_builder_factory.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/menus/menu/menu.dart';
import '../../../../models/menus/menu/menu_search_param.dart';
import '../../../../widgets/pagination_widgets/_pagination_widget.dart';
import '../../../common_widget/search_form_field.dart';

class SearchMenuDialog extends StatefulWidget {
  const SearchMenuDialog({super.key});

  @override
  State<SearchMenuDialog> createState() => _SearchMenuDialogState();
}

class _SearchMenuDialogState extends State<SearchMenuDialog> {
  final MenuService menuService = MenuService();
  late Future<List<Menu>> menuList;

  MenuVisibility menuVisibility = MenuVisibility.VISIBLE;
  MenuSearchType searchType = MenuSearchType.NAME;
  String? searchValue;

  //Paging
  int currentPage = 1;
  int rowsPerPage = 10;
  late Future<int> totalPage;

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //메뉴 리스트 조회
  Future<List<Menu>> getMenuList() async {
    try {
      return await menuService.getMenuList(getMenuSearchParam());
    } catch (e) {
      ErrorHandler.handleError(e, context);
      return [];
    }
  }

  //메뉴 리스트 갯수 조회
  Future<int> getTotalCount() async {
    try {
      int count = await menuService.getMenuListCount(getMenuSearchParam());
      return (count / rowsPerPage).ceil();
    } catch (e) {
      ErrorHandler.handleError(e, context);
      return 0;
    }
  }

  MenuSearchParam getMenuSearchParam() {
    return MenuSearchParam(
        searchType: searchType,
        searchValue: searchValue,
        visibility: menuVisibility,
        page: currentPage,
        limit: rowsPerPage);
  }

  void loadAllData() {
    setState(() {
      menuList = getMenuList();
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
                      //______________________________________________________________________Header__________________
                      Padding(
                        padding: _sizeInfo.padding,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 1, child: searchVisibilityDropDown()),
                            const SizedBox(width: 16.0),
                            Expanded(flex: 1, child: searchTypeDropDown()),
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
                          ],
                        ),
                      ),

                      //______________________________________________________________________Data_table__________________
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width * 0.8,
                            ),
                            child: FutureBuilderFactory.createFutureBuilder(
                                future: menuList,
                                onSuccess: (context, menuList) {
                                  return dataTable(menuList);
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

  ///_______________________________________________________________DropDownList___________________________________
  Container searchTypeDropDown() {
    final dropdownStyle = AcnooDropdownStyle(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 100, minWidth: 100),
      child: DropdownButtonFormField2<MenuSearchType>(
        style: dropdownStyle.textStyle,
        iconStyleData: dropdownStyle.iconStyle,
        buttonStyleData: dropdownStyle.buttonStyle,
        dropdownStyleData: dropdownStyle.dropdownStyle,
        menuItemStyleData: dropdownStyle.menuItemStyle,
        isExpanded: true,
        value: searchType,
        items: MenuSearchType.values.map((MenuSearchType searchType) {
          return DropdownMenuItem<MenuSearchType>(
            value: searchType,
            child: Text(
              searchType.value,
              style: textTheme.bodySmall,
            ),
          );
        }).toList(),
        onChanged: (value) {
          searchType = value!;
        },
      ),
    );
  }

  Container searchVisibilityDropDown() {
    final dropdownStyle = AcnooDropdownStyle(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 100, minWidth: 100),
      child: DropdownButtonFormField2<MenuVisibility>(
        style: dropdownStyle.textStyle,
        iconStyleData: dropdownStyle.iconStyle,
        buttonStyleData: dropdownStyle.buttonStyle,
        dropdownStyleData: dropdownStyle.dropdownStyle,
        menuItemStyleData: dropdownStyle.menuItemStyle,
        isExpanded: true,
        value: menuVisibility,
        items: MenuVisibility.values.map((MenuVisibility visibility) {
          return DropdownMenuItem<MenuVisibility>(
            value: visibility,
            child: Text(
              visibility.value,
              style: textTheme.bodySmall,
            ),
          );
        }).toList(),
        onChanged: (value) {
          menuVisibility = value!;
        },
      ),
    );
  }

  Theme dataTable(List<Menu> menuList) {
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
          DataColumn(label: Text(lang.menuId)),
          DataColumn(label: Text(lang.parentMenuId)),
          DataColumn(label: Text(lang.name)),
          DataColumn(label: Text(lang.sortOrder)),
          DataColumn(label: Text(lang.path)),
          DataColumn(label: Text(lang.visibility)),
          DataColumn(label: Text(lang.createdAt)),
        ],
        rows: menuList.map(
          (data) {
            return DataRow(
              onSelectChanged: (bool? selected) =>
                  GoRouter.of(context).pop(data),
              color: WidgetStateColor.transparent,
              cells: [
                DataCell(Text(data.id.toString())),
                DataCell(Text(data.parentId?.toString() ?? lang.empty)),
                DataCell(Text(data.menuName)),
                DataCell(Text(data.sortOrder.toString())),
                DataCell(Text(data.menuPath)),
                DataCell(
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: selectStatusColor(data.visibility.value, 0.2),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      data.visibility.value,
                      style: textTheme.bodySmall?.copyWith(
                          color:selectStatusColor(data.visibility.value, 1)
                      ),
                    ),
                  ),
                ),
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
                menuList = getMenuList();
              });
            }
          },
          onNextTap: () {
            if (currentPage < totalPage) {
              setState(() {
                currentPage++;
                menuList = getMenuList();
              });
            }
          },
        )
      ],
    );
  }

  Color selectStatusColor(String status, double alpha){
    if(status == MenuVisibility.VISIBLE.value) {
      return AcnooAppColors.kSuccess.withValues(alpha: alpha);
    }
    else {
      return AcnooAppColors.kError.withValues(alpha: alpha);
    }
  }
}
