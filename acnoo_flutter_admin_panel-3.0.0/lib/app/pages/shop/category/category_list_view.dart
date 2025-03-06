// 🎯 Dart imports:
import 'dart:ui';

// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../constants/common/action_menu.dart';
import '../../../core/service/shop/category/category_service.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/common/paging_param.dart';
import '../../../models/shop/category/category.dart';
import '../../../widgets/pagination_widgets/_pagination_widget.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';
import '../../common_widget/custom_button.dart';
import 'component/add_category_popup.dart';
import 'component/mapping_item_popup.dart';
import 'component/mod_category_popup.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({super.key});

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  final ScrollController scrollController = ScrollController();
  final CategoryService categoryService = CategoryService();
  late Future<List<Category>> categoryList;

  //Paging
  int currentPage = 1;
  int rowsPerPage = 10;
  late Future<int> totalPage;

  //카테고리 리스트 조회
  Future<List<Category>> getCategoryList() async {
    try {
      PagingParam pagingParam = PagingParam(currentPage, rowsPerPage);
      return await categoryService.getCategoryList(pagingParam);
    } catch (e) {
      ErrorHandler.handleError(e, context);
      return [];
    }
  }

  //카테고리 리스트 갯수 조회
  Future<int> getTotalCount() async {
    try {
      int count = await categoryService.getCategoryListCount();
      int totalPage = (count / rowsPerPage).ceil();
      return totalPage;
    } catch (e) {
      ErrorHandler.handleError(e, context);
      return 0;
    }
  }

  //카테고리 삭제
  Future<void> delCategory(int categoryId) async {
    try {
      await categoryService.delCategory(categoryId);
      loadAllData();
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  //List + Total
  void loadAllData() {
    setState(() {
      categoryList = getCategoryList();
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
    final theme = Theme.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
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
                              label: lang.addNewCategory,
                              onPressed: () =>
                                  showAddFormDialog(context)),
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
                          child: FutureBuilderFactory.createFutureBuilder(
                              future: categoryList,
                              onSuccess: (context, categoryList){
                                return dataTable(categoryList, theme, textTheme, lang);
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

  Theme dataTable(List<Category> categoryList, ThemeData theme, TextTheme textTheme, l.S lang) {
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
          DataColumn(label: Text(lang.categoryId)),
          DataColumn(label: Text(lang.name)),
          DataColumn(label: Text(lang.description)),
          DataColumn(label: Text(lang.createdAt)),
          DataColumn(label: Text(lang.actions)),
        ],
        rows: categoryList.map(
              (data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              cells: [
                DataCell(Text(data.id.toString())),
                DataCell(Text(data.name)),
                DataCell(Text(data.description)),
                DataCell(
                    Text(DateUtil.convertDateTimeToString(data.createdAt))),
                DataCell(
                  PopupMenuButton<ActionMenu>(
                    iconColor: theme.colorScheme.onTertiary,
                    color: theme.colorScheme.primaryContainer,
                    onSelected: (action) {
                      switch (action) {
                        case ActionMenu.MAPPING_ITEM:
                          showMappingItemFormDialog(data.id);
                        case ActionMenu.EDIT:
                          showModFormDialog(data);
                          break;
                        case ActionMenu.DELETE:
                          delCategory(data.id);
                          break;
                        default:
                          break;
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<ActionMenu>(
                          value: ActionMenu.MAPPING_ITEM,
                          child: Text(lang.showMappingItem),
                        ),
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
                categoryList = getCategoryList();
              });
            }
          },
          onNextTap: () {
            if (currentPage < totalPage) {
              setState(() {
                currentPage++;
                categoryList = getCategoryList();
              });
            }
          },
        )
      ],
    );
  }

  void showAddFormDialog(BuildContext context) async {
    bool? isSuccess = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: const AddCategoryDialog());
      },
    );

    if (isSuccess != null && isSuccess) {
      loadAllData();
    }
  }

  void showModFormDialog(Category category) async {
    bool? isSuccess = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: ModCategoryDialog(category: category));
      },
    );

    if (isSuccess != null && isSuccess) {
      loadAllData();
    }
  }

  void showMappingItemFormDialog(int categoryId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: MappingItemDialog(categoryId: categoryId));
      },
    );
  }
}
