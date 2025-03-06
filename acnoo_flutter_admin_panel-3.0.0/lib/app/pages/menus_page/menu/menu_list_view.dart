// 🐦 Flutter imports:
// 📦 Package imports:
import 'dart:ui';

import 'package:acnoo_flutter_admin_panel/app/constants/menus/menu/menu_visibility.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:acnoo_flutter_admin_panel/app/models/menus/menu/menu_search_param.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/common_widget/generic_drop_down.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/menus_page/menu/component/view_all_menu_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart' as l;
import '../../../constants/common/action_menu.dart';
import '../../../constants/menus/menu/menu_search_type.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/service/menus/menu_service.dart';
import '../../../core/theme/_app_colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/menus/menu/menu.dart';
import '../../../providers/menu/menu_provider.dart';
import '../../../widgets/pagination_widgets/_pagination_widget.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';
import '../../common_widget/custom_button.dart';
import '../../common_widget/search_form_field.dart';
import 'component/add_menu_popup.dart';
import 'component/mod_menu_popup.dart';

class MenuListView extends StatefulWidget {
  const MenuListView({super.key});

  @override
  State<MenuListView> createState() => _MenuListViewState();
}

class _MenuListViewState extends State<MenuListView> {
  final MenuService menuService = MenuService();
  late Future<List<Menu>> menuList;

  //Search
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
  late MenuProvider menuProvider;

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

  //메뉴 삭제
  Future<void> delMenu(int menuId) async {
    try{
      await menuService.delMenu(menuId);
      menuProvider.fetchMenus();
      loadAllData();
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  MenuSearchParam getMenuSearchParam() {
    return MenuSearchParam(
        searchType: searchType,
        searchValue: searchValue,
        visibility: menuVisibility,
        page: currentPage,
        limit: rowsPerPage
    );
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
    menuProvider = Provider.of<MenuProvider>(context);
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
                return FutureBuilderFactory.createFutureBuilder(
                    future: menuList,
                    onSuccess: (context, menuList){
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
                                  child: GenericDropDown<MenuVisibility>(
                                      labelText: lang.visibility,
                                      searchType: menuVisibility,
                                      searchList: MenuVisibility.values,
                                      callBack: (MenuVisibility value) {
                                        menuVisibility = value;
                                      }
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  flex: 1,
                                  child: GenericDropDown<MenuSearchType>(
                                      labelText: lang.type,
                                      searchType: searchType,
                                      searchList: MenuSearchType.values,
                                      callBack: (MenuSearchType value) {
                                        searchType = value;
                                      }
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  flex: 2,
                                  child: SearchFormField(
                                      textTheme: textTheme,
                                      lang: lang,
                                      onPressed: (searchValue) {
                                        this.searchValue = searchValue;
                                        loadAllData();
                                      }),
                                ),
                                Spacer(flex: 4),

                                //MENU VIEW
                                CustomButton(
                                    textTheme: textTheme,
                                    label: lang.menuView,
                                    onPressed: () => showViewFormDialog(menuList)
                                ),

                                const SizedBox(width: 16.0),

                                //ADD NEW MENU
                                CustomButton(
                                    textTheme: textTheme,
                                    label: lang.addNewMenu,
                                    onPressed: () => showAddFormDialog()
                                ),
                              ],
                            ),
                          ),

                          //______________________________________________________________________Data_table__________________
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: constraints.maxWidth,
                              ),
                              child: dataTable(menuList),
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

                          )
                        ],
                      );
                    }
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  //Menu 전체 표기 팝업
  void showViewFormDialog(List<Menu> menuList) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: ViewAllMenuDialog()
        );
      },
    );
  }

  //Menu 추가 팝업
  void showAddFormDialog() async {
    bool? isSuccess = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: const AddMenuDialog()
        );
      },
    );

    if (isSuccess != null && isSuccess) {
      loadAllData();
    }
  }

  Theme dataTable(List<Menu> menuList) {
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
        columns: [
          DataColumn(label: Text(lang.menuId)),
          DataColumn(label: Text(lang.parentMenuId)),
          DataColumn(label: Text(lang.menuName)),
          DataColumn(label: Text(lang.sortOrder)),
          DataColumn(label: Text(lang.path)),
          DataColumn(label: Text(lang.visibility)),
          DataColumn(label: Text(lang.createdAt)),
          DataColumn(label: Text(lang.actions)),
        ],
        rows: menuList.map(
              (data) {
            return DataRow(
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
                          delMenu(data.id);
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

  void showModFormDialog(Menu menu) async {
    bool? isSuccess = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: ModMenuDialog(menu: menu));
      },
    );

    if (isSuccess != null && isSuccess) {
      loadAllData();
    }
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
