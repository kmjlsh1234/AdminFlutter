// 🎯 Dart imports:
import 'dart:ui';

// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/constants/shop/item_unit/item_unit_search_type.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/size_config.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/common_widget/custom_button.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/shop/item_unit/widget/add_item_unit_popup.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../core/helpers/field_styles/_dropdown_styles.dart';
import '../../../core/service/shop/item_unit/item_unit_service.dart';
import '../../../models/shop/item_unit/item_unit.dart';
import '../../../models/shop/item_unit/item_unit_search_param.dart';
import '../../../widgets/pagination_widgets/_pagination_widget.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';
import '../../common_widget/search_form_field.dart';

class ItemUnitListView extends StatefulWidget {
  const ItemUnitListView({super.key});

  @override
  State<ItemUnitListView> createState() => _ItemUnitListViewState();
}

class _ItemUnitListViewState extends State<ItemUnitListView> {
  final ScrollController scrollController = ScrollController();
  final ItemUnitService itemUnitService = ItemUnitService();
  late Future<List<ItemUnit>> itemUnitList;

  //Paging
  int currentPage = 1;
  int rowsPerPage = 10;
  late Future<int> totalPage;

  //Search
  ItemUnitSearchType searchType = ItemUnitSearchType.none;
  String searchValue = '';

  //아이템 유닛 리스트 조회
  Future<List<ItemUnit>> getItemUnitList() async {
    try {
      return await itemUnitService.getItemUnitList(getItemUnitSearchParam());
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  //아이템 유닛 리스트 갯수 조회
  Future<int> getTotalCount() async {
    try {
      int count = await itemUnitService.getItemUnitListCount(getItemUnitSearchParam());
      int totalPage = (count / rowsPerPage).ceil();
      return totalPage;
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  //아이템 유닛 삭제
  Future<void> delItemUnit(int unitId) async {
    try {
      await itemUnitService.delItemUnit(unitId);
      loadAllData();
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  ItemUnitSearchParam getItemUnitSearchParam() {
    return ItemUnitSearchParam(
        searchType: searchType == ItemUnitSearchType.none ? null : searchType.value,
        searchValue: searchValue,
        page: currentPage,
        limit: rowsPerPage
    );
  }

  void loadAllData() {
    setState(() {
      itemUnitList = getItemUnitList();
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
    final _sizeInfo = SizeConfig.getSizeInfo(context);
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
                                    loadAllData();
                                  });
                                }),
                          ),
                          Spacer(flex: 2),
                          CustomButton(
                              textTheme: textTheme,
                              label: lang.addNewItemUnit,
                              onPressed: () => showAddFormDialog()
                          )
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
                          child: FutureBuilder<List<ItemUnit>>(
                              future: itemUnitList,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                }
                                final itemUnitList = snapshot.data!;
                                return dataTable(context, itemUnitList);
                              })
                      ),
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
                            })
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

  void showAddFormDialog() async {
    bool success = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: const AddItemUnitDialog());
      },
    );

    if (success) {
      loadAllData();
    }
  }

  ///_______________________________________________________________pagination_footer_______________________________
  Row paginatedSection(ThemeData theme, TextTheme textTheme, int totalPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FutureBuilder<List<ItemUnit>>(
            future: itemUnitList,
            builder: (context, snapshot) {
              int currentEntriesCount = 0;
              if (snapshot.hasData) {
                currentEntriesCount = snapshot.data!.length;
              }
              return Expanded(
                child: Text('${l.S.of(context).showing} ${(currentPage - 1) * rowsPerPage} ${l.S.of(context).to} ${(currentPage - 1) * rowsPerPage + currentEntriesCount} ${l.S.of(context).OF} $currentEntriesCount ${l.S.of(context).entries}',
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
                itemUnitList = getItemUnitList();
              });
            }
          },
          onNextTap: () {
            if (currentPage < totalPage) {
              setState(() {
                currentPage++;
                itemUnitList = getItemUnitList();
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
      child: DropdownButtonFormField2<ItemUnitSearchType>(
        hint: Text('SearchType'),
        style: _dropdownStyle.textStyle,
        iconStyleData: _dropdownStyle.iconStyle,
        buttonStyleData: _dropdownStyle.buttonStyle,
        dropdownStyleData: _dropdownStyle.dropdownStyle,
        menuItemStyleData: _dropdownStyle.menuItemStyle,
        isExpanded: true,
        value: searchType,
        items: ItemUnitSearchType.values.map((ItemUnitSearchType searchType) {
          return DropdownMenuItem<ItemUnitSearchType>(
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

  ///_______________________________________________________________Data_Table___________________________
  Theme dataTable(BuildContext context, List<ItemUnit> itemUnitList) {
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
          DataColumn(label: Text(lang.sku)),
          DataColumn(label: Text(lang.name)),
          DataColumn(label: Text(lang.type)),
          DataColumn(label: Text(lang.createdAt)),
          DataColumn(label: Text(lang.updatedAt)),
          DataColumn(label: Text(lang.actions)),
        ],
        rows: itemUnitList.map(
          (data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              cells: [
                DataCell(Text(data.id.toString())),
                DataCell(Text(data.sku)),
                DataCell(Text(data.name)),
                DataCell(Text(data.type)),
                DataCell(Text(data.createdAt.toString())),
                DataCell(Text(data.updatedAt.toString())),
                DataCell(
                  PopupMenuButton<String>(
                    iconColor: theme.colorScheme.onTertiary,
                    color: theme.colorScheme.primaryContainer,
                    onSelected: (action) {
                      switch (action) {
                        case 'View':
                          GoRouter.of(context)
                              .go('/shops/item-unit/info/${data.id}');
                          break;
                        case 'Delete':
                          delItemUnit(data.id);
                          break;
                      }
                    },
                    itemBuilder: (context) {
                      return [
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
