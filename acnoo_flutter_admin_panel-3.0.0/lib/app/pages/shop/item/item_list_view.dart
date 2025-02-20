// 🎯 Dart imports:
import 'dart:ui';

// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/size_config.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/common_widget/custom_button.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/shop/item/mod_item_status_popup.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../constants/shop/item/item_search_type.dart';
import '../../../constants/shop/item/item_status.dart';
import '../../../core/helpers/field_styles/_dropdown_styles.dart';
import '../../../core/service/shop/item/item_service.dart';
import '../../../core/theme/_app_colors.dart';
import '../../../models/shop/item/item.dart';
import '../../../models/shop/item/item_search_param.dart';
import '../../../widgets/pagination_widgets/_pagination_widget.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';
import '../../common_widget/search_form_field.dart';
import 'add_item_popup.dart';

class ItemListView extends StatefulWidget {
  const ItemListView({super.key});

  @override
  State<ItemListView> createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  final ScrollController scrollController = ScrollController();
  final ItemService itemService = ItemService();
  late Future<List<Item>> itemList;

  //Paging
  int currentPage = 1;
  int rowsPerPage = 10;
  late Future<int> totalPage;

  //Search
  ItemSearchType searchType = ItemSearchType.none;
  String searchValue = '';

  //아이템 리스트 조회
  Future<List<Item>> getItemList() async {
    try {
      return await itemService.getItemList(getItemSearchParam());
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  //아이템 리스트 갯수 조회
  Future<int> getTotalCount() async {
    try {
      int count = await itemService.getItemListCount(getItemSearchParam());
      int totalPage = (count / rowsPerPage).ceil();
      return totalPage;
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  //아이템 삭제
  Future<void> delItem(int itemId) async {
    try{
      await itemService.delItem(itemId);
      loadAllData();
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  void loadAllData() {
    setState(() {
      itemList = getItemList();
      totalPage = getTotalCount();
    });
  }

  ItemSearchParam getItemSearchParam() {
    return ItemSearchParam(
        categoryId: null,
        searchType: searchType == ItemSearchType.none ? null : searchType.value,
        searchValue: searchValue,
        page: currentPage,
        limit: rowsPerPage
    );
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
                            child: searchTypeDropDown(textTheme: textTheme),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            flex: 3,
                            child: SearchFormField(
                              textTheme: textTheme,
                              lang: lang,
                              onPressed: (searchValue) {
                                setState(() {
                                  this.searchValue = searchValue;
                                  itemList = getItemList();
                                  totalPage = getTotalCount();
                                });
                              },
                            ),
                          ),
                          Spacer(flex: 2),
                          CustomButton(
                              textTheme: textTheme,
                              label: lang.addNewItem,
                              onPressed: () => showAddFormDialog())
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
                          child: FutureBuilder<List<Item>>(
                              future: itemList,
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
                                final itemList = snapshot.data!;
                                return dataTable(context, itemList);
                              })),
                    ),

                    //______________________________________________________________________footer__________________
                    Padding(
                        padding: _sizeInfo.padding,
                        child: FutureBuilder<int>(
                            future: totalPage,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              }
                              final totalPage = snapshot.data!;
                              return paginatedSection(theme, textTheme, totalPage);
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

  void showAddFormDialog() async {
    bool success = await showDialog(
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

    if (success) {
      loadAllData();
    }
  }

  void showModStatusFormDialog(Item item) async {
    bool success = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: ModItemStatusDialog(item: item));
      },
    );

    if (success) {
      loadAllData();
    }
  }
  ///_______________________________________________________________pagination_footer_______________________________
  Row paginatedSection(ThemeData theme, TextTheme textTheme, int totalPage) {
    //final lang = l.S.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FutureBuilder<List<Item>>(
            future: itemList,
            builder: (context, snapshot) {
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
                itemList = getItemList();
              });
            }
          },
          onNextTap: () {
            if (currentPage < totalPage) {
              setState(() {
                currentPage++;
                itemList = getItemList();
              });
            }
          },
        )
      ],
    );
  }

  ///_______________________________________________________________DropDownList___________________________________
  Container searchTypeDropDown({required TextTheme textTheme}) {
    final _dropdownStyle = AcnooDropdownStyle(context);
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
  Theme dataTable(BuildContext context, List<Item> itemList) {
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
          DataColumn(label: Text(lang.status)),
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
                DataCell(
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: data.status == ItemStatus.onSale.value
                          ? AcnooAppColors.kSuccess.withOpacity(0.2)
                          : AcnooAppColors.kError.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      data.status,
                      style: textTheme.bodySmall?.copyWith(
                          color:
                          data.status == ItemStatus.onSale.value
                              ? AcnooAppColors.kSuccess
                              : AcnooAppColors.kError),
                    ),
                  ),
                ),
                DataCell(Text(data.createdAt.toString())),
                DataCell(Text(data.updatedAt.toString())),
                DataCell(
                  PopupMenuButton<String>(
                    iconColor: theme.colorScheme.onTertiary,
                    color: theme.colorScheme.primaryContainer,
                    onSelected: (action) {
                      switch (action) {
                        case 'Edit Status':
                          showModStatusFormDialog(data);
                          break;
                        case 'View':
                          GoRouter.of(context)
                              .go('/shops/item/info/${data.id}');
                          break;
                        case 'Delete':
                          delItem(data.id);
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
