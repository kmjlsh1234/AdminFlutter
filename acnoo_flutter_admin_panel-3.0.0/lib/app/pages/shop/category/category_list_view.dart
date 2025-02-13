// 🎯 Dart imports:
import 'dart:ui';

// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/admin/admin_manage_service.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// 📦 Package imports:
import 'package:iconly/iconly.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../core/helpers/field_styles/_dropdown_styles.dart';
import '../../../core/service/shop/category/category_service.dart';
import '../../../core/theme/_app_colors.dart';
import '../../../models/common/paging_param.dart';
import '../../../models/shop/category/category.dart';
import '../../../widgets/pagination_widgets/_pagination_widget.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';
import '../../admin_manage_page/admin_add_popup.dart';
import 'add_category_popup.dart';
import 'mod_category_popup.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({super.key});

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  ///_____________________________________________________________________Variables_______________________________
  final CategoryService categoryService = CategoryService();
  late List<Category> categoryList = [];
  final ScrollController _scrollController = ScrollController();
  int currentPage = 0;
  int _rowsPerPage = 10;
  int totalPage = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCategoryList(context);
    getCategoryListCount(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ///_____________________________________________________________________api Functions__________________________________

  //카테고리 리스트 조회
  Future<void> getCategoryList(BuildContext context) async {
    List<Category> list = [];
    try {
      setState(() => isLoading = true);
      PagingParam pagingParam = PagingParam(currentPage + 1, _rowsPerPage);
      list = await categoryService.getCategoryList(pagingParam);
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    setState(() {
      categoryList = list;
      isLoading = false;
    });
  }

  //카테고리 리스트 갯수 조회
  Future<void> getCategoryListCount(BuildContext context) async {
    int count = 0;
    try {
      setState(() => isLoading = true);

      count = await categoryService.getCategoryListCount();
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    setState(() {
      totalPage = (count / _rowsPerPage).ceil();
      isLoading = false;
    });
  }

  //카테고리 삭제
  Future<void> delCategory(BuildContext context, int categoryId) async {
    try {
      setState(() => isLoading = true);
      await categoryService.delCategory(categoryId);
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    setState(() {
      getCategoryList(context);
      getCategoryListCount(context);
      isLoading = false;
    });
  }

  ///_____________________________________________________________________Add_Category_____________________________
  void showAddFormDialog(BuildContext context) async {
    bool isCategoyAdd = await showDialog(
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

    if(isCategoyAdd){
      getCategoryList(context);
      getCategoryListCount(context);
    }
  }

  ///_____________________________________________________________________Mod_Category_____________________________
  void showModFormDialog(BuildContext context, Category category) async {
    bool isCategoyMod = await showDialog(
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

    if(isCategoyMod){
      getCategoryList(context);
      getCategoryListCount(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 480,
          value: _SizeInfo(
            alertFontSize: 12,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 481,
          end: 576,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 577,
          end: 992,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;

    TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

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

                          Spacer(flex: isTablet || isMobile ? 1 : 2),
                          addUserButton(textTheme),
                        ],
                      ),
                    ),

                    //______________________________________________________________________Data_table__________________
                    isMobile || isTablet
                        ? RawScrollbar(
                            padding: const EdgeInsets.only(left: 18),
                            trackBorderColor: theme.colorScheme.surface,
                            trackVisibility: true,
                            scrollbarOrientation: ScrollbarOrientation.bottom,
                            controller: _scrollController,
                            thumbVisibility: true,
                            thickness: 8.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleChildScrollView(
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: constraints.maxWidth,
                                    ),
                                    child: userListDataTable(context),
                                  ),
                                ),
                                Padding(
                                  padding: _sizeInfo.padding,
                                  child: Text(
                                    '${l.S.of(context).showing} ${currentPage * _rowsPerPage + 1} ${l.S.of(context).to} ${currentPage * _rowsPerPage + categoryList.length} ${l.S.of(context).OF} ${categoryList.length} ${l.S.of(context).entries}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: constraints.maxWidth,
                              ),
                              child: isLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : userListDataTable(context),
                            ),
                          ),

                    //______________________________________________________________________footer__________________
                    isTablet || isMobile
                        ? const SizedBox.shrink()
                        : Padding(
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

  ///_____________________________________________________________________add_user_button___________________________
  ElevatedButton addUserButton(TextTheme textTheme) {
    final lang = l.S.of(context);
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: () {
        setState(() {
          showAddFormDialog(context);
        });
      },
      label: Text(
        lang.addNewUser,
        //'Add New User',
        style: textTheme.bodySmall?.copyWith(
          color: AcnooAppColors.kWhiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconAlignment: IconAlignment.start,
      icon: const Icon(
        Icons.add_circle_outline_outlined,
        color: AcnooAppColors.kWhiteColor,
        size: 20.0,
      ),
    );
  }

  ///_____________________________________________________________________pagination_functions_______________________
  int get _totalPages => (categoryList.length / _rowsPerPage).ceil();

  ///_____________________________________select_dropdown_val_________
  void _setRowsPerPage(int value) {
    setState(() {
      _rowsPerPage = value;
      currentPage = 0;
    });
  }

  ///_____________________________________go_next_page________________
  void _goToNextPage() {
    if (currentPage < _totalPages - 1) {
      setState(() {
        currentPage++;
        getCategoryList(context);
      });
    }
  }

  ///_____________________________________go_previous_page____________
  void _goToPreviousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        getCategoryList(context);
      });
    }
  }

  ///_______________________________________________________________pagination_footer_______________________________
  Row paginatedSection(ThemeData theme, TextTheme textTheme) {
    //final lang = l.S.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '${l.S.of(context).showing} ${currentPage * _rowsPerPage + 1} ${l.S.of(context).to} ${currentPage * _rowsPerPage + categoryList.length} ${l.S.of(context).OF} ${categoryList.length} ${l.S.of(context).entries}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataTablePaginator(
          currentPage: currentPage + 1,
          totalPages: _totalPages,
          onPreviousTap: _goToPreviousPage,
          onNextTap: _goToNextPage,
        )
      ],
    );
  }

  ///_______________________________________________________________User_List_Data_Table___________________________
  Theme userListDataTable(BuildContext context) {
    final lang = l.S.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
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
                        case 'View':
                          GoRouter.of(context).go('/admins/info/${data.id}');
                          break;
                        case 'Delete':
                          delCategory(context, data.id);
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

class _SizeInfo {
  final double? alertFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;

  const _SizeInfo({
    this.alertFontSize = 18,
    this.padding = const EdgeInsets.all(24),
    this.innerSpacing = 24,
  });
}
