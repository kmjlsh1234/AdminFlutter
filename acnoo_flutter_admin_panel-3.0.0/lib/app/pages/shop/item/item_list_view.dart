// 🎯 Dart imports:
import 'dart:ui';

// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// 📦 Package imports:
import 'package:iconly/iconly.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../constants/shop/item/item_search_type.dart';
import '../../../core/helpers/field_styles/_dropdown_styles.dart';
import '../../../core/service/shop/item/item_service.dart';
import '../../../core/theme/_app_colors.dart';
import '../../../models/shop/item/item.dart';
import '../../../models/shop/item/item_search_param.dart';
import '../../../widgets/pagination_widgets/_pagination_widget.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';
import 'add_item_popup.dart';

class ItemListView extends StatefulWidget {
  const ItemListView({super.key});

  @override
  State<ItemListView> createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  ///_____________________________________________________________________Variables_______________________________
  final ItemService itemService = ItemService();
  late List<Item> itemList = [];
  final ScrollController _scrollController = ScrollController();
  int currentPage = 0;
  int _rowsPerPage = 10;
  int totalPage = 0;

  ItemSearchType searchType = ItemSearchType.none;
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getItemList(context);
    getItemListCount(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ///_____________________________________________________________________api Functions__________________________________

  //아이템 리스트 조회
  Future<void> getItemList(BuildContext context) async {
    List<Item> list = [];
    try {
      setState(() => isLoading = true);
      ItemSearchParam itemSearchParam = getItemSearchParam();
      list = await itemService.getItemList(itemSearchParam);
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    setState(() {
      itemList = list;
      isLoading = false;
    });
  }

  //아이템 리스트 갯수 조회
  Future<void> getItemListCount(BuildContext context) async {
    int count = 0;
    try {
      setState(() => isLoading = true);
      ItemSearchParam itemSearchParam = getItemSearchParam();
      count = await itemService.getItemListCount(itemSearchParam);
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    setState(() {
      totalPage = (count / _rowsPerPage).ceil();
      isLoading = false;
    });
  }

  ItemSearchParam getItemSearchParam() {
    return ItemSearchParam(
        categoryId: null,
        searchType: null,
        searchValue: null,
        page: currentPage + 1,
        limit: _rowsPerPage
    );
  }
  ///_____________________________________________________________________Add_Item_____________________________
  void showAddFormDialog(BuildContext context) async {
    bool isItemAdd = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: const AddItemDialog());
      },
    );

    if(isItemAdd){
      getItemList(context);
      getItemListCount(context);
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
                          Expanded(
                            flex: 1,
                            child: showingSearchTypeDropDown(
                                isTablet: isTablet,
                                isMobile: isMobile,
                                textTheme: textTheme),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            flex: isTablet || isMobile ? 2 : 3,
                            child: searchFormField(textTheme: textTheme),
                          ),
                          Spacer(flex: isTablet || isMobile ? 1 : 2),
                          addItemButton(textTheme),
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
                                    '${l.S.of(context).showing} ${currentPage * _rowsPerPage + 1} ${l.S.of(context).to} ${currentPage * _rowsPerPage + itemList.length} ${l.S.of(context).OF} ${itemList.length} ${l.S.of(context).entries}',
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

  ///_____________________________________________________________________add_Item_button___________________________
  ElevatedButton addItemButton(TextTheme textTheme) {
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
  int get _totalPages => (itemList.length / _rowsPerPage).ceil();

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
        getItemList(context);
      });
    }
  }

  ///_____________________________________go_previous_page____________
  void _goToPreviousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        getItemList(context);
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
            '${l.S.of(context).showing} ${currentPage * _rowsPerPage + 1} ${l.S.of(context).to} ${currentPage * _rowsPerPage + itemList.length} ${l.S.of(context).OF} ${itemList.length} ${l.S.of(context).entries}',
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

  ///_______________________________________________________________Search_Field___________________________________
  TextFormField searchFormField({required TextTheme textTheme}) {
    final lang = l.S.of(context);
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
        // hintText: 'Search...',
        hintText: '${lang.search}...',
        hintStyle: textTheme.bodySmall,
        suffixIcon: Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: AcnooAppColors.kPrimary700,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: ElevatedButton(
              onPressed: () => getItemList(context),
              child: const Icon(IconlyLight.search,
                  color: AcnooAppColors.kWhiteColor),
            )),
      ),
      onChanged: (value) {
        searchQuery = value;
      },
    );
  }

  ///_______________________________________________________________DropDownList___________________________________
  Container showingSearchTypeDropDown(
      {required bool isTablet,
      required bool isMobile,
      required TextTheme textTheme}) {
    final _dropdownStyle = AcnooDropdownStyle(context);
    //final theme = Theme.of(context);
    final lang = l.S.of(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 100, minWidth: 100),
      child: DropdownButtonFormField2<ItemSearchType>(
        hint: Text('SearchType'),
        style: _dropdownStyle.textStyle,
        iconStyleData: _dropdownStyle.iconStyle,
        buttonStyleData: _dropdownStyle.buttonStyle,
        dropdownStyleData: _dropdownStyle.dropdownStyle,
        menuItemStyleData: _dropdownStyle.menuItemStyle,
        isExpanded: true,
        value: searchType,
        items: ItemSearchType.values.map((ItemSearchType searchType) {
          return DropdownMenuItem<ItemSearchType>(
            value: searchType,
            child: Text(
              searchType.value,
              style: textTheme.bodySmall,
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            searchType = value;
          }
        },
      ),
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
          DataColumn(label: Text(lang.category)),
          DataColumn(label: Text(lang.itemUnit)),
          DataColumn(label: Text(lang.sku)),
          DataColumn(label: Text(lang.name)),
          DataColumn(label: Text(lang.type)),
          DataColumn(label: Text(lang.createdAt)),
          DataColumn(label: Text(lang.updatedAt)),
          DataColumn(label: Text(lang.actions)),
        ],
        rows: itemList.map(
          (data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              cells: [
                DataCell(Text(data.id.toString())),
                DataCell(Text(data.categoryId.toString())),
                DataCell(Text(data.itemUnitId.toString())),
                DataCell(Text(data.sku)),
                DataCell(Text(data.name)),
                DataCell(Text(data.currencyType)),
                DataCell(Text(data.createdAt.toString())),
                DataCell(Text(data.updatedAt.toString())),
                DataCell(
                  PopupMenuButton<String>(
                    iconColor: theme.colorScheme.onTertiary,
                    color: theme.colorScheme.primaryContainer,
                    onSelected: (action) {
                      switch (action) {
                        case 'Edit':
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('${lang.edit} ${data.name}')),
                          );
                          break;
                        case 'View':
                          GoRouter.of(context).go('/shops/item/info/${data.id}');
                          break;
                        case 'Delete':

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
