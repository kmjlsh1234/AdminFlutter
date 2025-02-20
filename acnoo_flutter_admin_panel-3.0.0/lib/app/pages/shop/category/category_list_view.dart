// 🎯 Dart imports:
import 'dart:ui';

// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../core/service/shop/category/category_service.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/common/paging_param.dart';
import '../../../models/shop/category/category.dart';
import '../../../widgets/pagination_widgets/_pagination_widget.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';
import '../../common_widget/custom_button.dart';
import 'add_category_popup.dart';
import 'mod_category_popup.dart';

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
      rethrow;
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
      rethrow;
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
  void loadAllData(){
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
    final _sizeInfo = SizeConfig.getSizeInfo(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
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
                          child: FutureBuilder<List<Category>>(
                              future: categoryList,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                }
                                final categoryList = snapshot.data!;
                                return dataTable(
                                    lang, theme, textTheme, categoryList);
                              })),
                    ),

                    //______________________________________________________________________footer__________________
                    Padding(
                        padding: _sizeInfo.padding,
                        child: FutureBuilder<int>(
                            future: totalPage,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }
                              final totalPage = snapshot.data!;
                              return paginatedSection(
                                  theme, textTheme, totalPage);
                            })),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  ///_______________________________________________________________pagination_footer_______________________________
  Row paginatedSection(ThemeData theme, TextTheme textTheme, int totalPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FutureBuilder<List<Category>>(
            future: categoryList,
            builder: (context, snapshot){
              int currentEntriesCount = 0;
              if (snapshot.hasData) {
                currentEntriesCount = snapshot.data!.length;
              }
              return Expanded(
                child: Text(
                  '${l.S.of(context).showing} ${(currentPage - 1) * rowsPerPage + 1} ${l.S.of(context).to} ${(currentPage - 1) * rowsPerPage + currentEntriesCount} ${l.S.of(context).OF} $currentEntriesCount ${l.S.of(context).entries}',
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }),

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

  ///_______________________________________________________________User_List_Data_Table___________________________
  Theme dataTable(l.S lang, ThemeData theme, TextTheme textTheme,
      List<Category> categoryList) {
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
                ///////////////////////-----------------------------나중에 Text(DateFormat('d MMM yyyy').format(data.createdAt))이렇게 바꾸기),
                DataCell(Text(data.description)),
                DataCell(Text(data.createdAt.toString())),
                DataCell(
                  PopupMenuButton<String>(
                    iconColor: theme.colorScheme.onTertiary,
                    color: theme.colorScheme.primaryContainer,
                    onSelected: (action) {
                      switch (action) {
                        case 'Edit':
                          showModFormDialog(context, data);
                          break;
                        case 'Delete':
                          delCategory(data.id);
                          break;
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'Edit',
                          child: Text(
                            lang.edit,
                            //'Edit',
                            style: textTheme.bodyMedium,
                          ),
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

  void showAddFormDialog(BuildContext context) async {
    bool success = await showDialog(
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

    if (success) {
      loadAllData();
    }
  }

  void showModFormDialog(BuildContext context, Category category) async {
    bool success = await showDialog(
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

    if (success) {
      loadAllData();
    }
  }
}
