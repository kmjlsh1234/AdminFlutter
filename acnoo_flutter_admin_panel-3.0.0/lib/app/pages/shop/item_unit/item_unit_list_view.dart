// 🎯 Dart imports:
import 'dart:ui';

// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/constants/shop/item_unit/item_unit_search_type.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/size_config.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/common_widget/custom_button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../core/helpers/field_styles/_dropdown_styles.dart';
import '../../../core/service/shop/item_unit/item_unit_service.dart';
import '../../../core/utils/compare_util.dart';
import '../../../models/shop/item_unit/item_unit.dart';
import '../../../models/shop/item_unit/item_unit_search_param.dart';
import '../../../widgets/pagination_widgets/_pagination_widget.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';
import '../../common_widget/search_form_field.dart';
import 'component/add_item_unit_popup.dart';
import 'component/item_unit_info_popup.dart';
import 'component/mod_item_unit_popup.dart';

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
      int count =
          await itemUnitService.getItemUnitListCount(getItemUnitSearchParam());
      return (count / rowsPerPage).ceil();
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
    String? itemSearchType = CompareUtil.compareStringValue(ItemUnitSearchType.none.value, searchType.value);
    return ItemUnitSearchParam(
        searchType: itemSearchType,
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
                return FutureBuilderFactory.createFutureBuilder(
                    future: itemUnitList,
                    onSuccess: (context, itemUnitList) {
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
                              child: dataTable(itemUnitList, theme, textTheme, lang),
                            ),
                          ),

                          //______________________________________________________________________footer__________________
                          Padding(
                              padding: _sizeInfo.padding,
                              child: FutureBuilderFactory.createFutureBuilder(
                                  future: totalPage,
                                  onSuccess: (context, totalPage) {
                                    return paginatedSection(totalPage, itemUnitList);
                                  }
                              ),
                          ),
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

  Theme dataTable(List<ItemUnit> itemUnitList, ThemeData theme, TextTheme textTheme, l.S lang) {

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
                DataCell(
                    Text(DateUtil.convertDateTimeToString(data.createdAt))),
                DataCell(
                    Text(DateUtil.convertDateTimeToString(data.updatedAt))),
                DataCell(
                  PopupMenuButton<String>(
                    iconColor: theme.colorScheme.onTertiary,
                    color: theme.colorScheme.primaryContainer,
                    onSelected: (action) {
                      switch (action) {
                        case 'Edit':
                          showModFormDialog(data);
                          break;
                        case 'View':
                          showInfoFormDialog(data);
                          break;
                        case 'Delete':
                          delItemUnit(data.id);
                          break;
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'Edit',
                          child: Text(lang.edit, style: textTheme.bodyMedium),
                        ),
                        PopupMenuItem<String>(
                          value: 'View',
                          child: Text(lang.view, style: textTheme.bodyMedium),
                        ),
                        PopupMenuItem<String>(
                          value: 'Delete',
                          child: Text(lang.delete, style: textTheme.bodyMedium),
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

  Row paginatedSection(int totalPage, List<ItemUnit> itemUnitList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '${l.S.of(context).showing} ${(currentPage - 1) * rowsPerPage + 1} ${l.S.of(context).to} ${(currentPage - 1) * rowsPerPage + itemUnitList.length} ${l.S.of(context).OF} ${itemUnitList.length} ${l.S.of(context).entries}',
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
                this.itemUnitList = getItemUnitList();
              });
            }
          },
          onNextTap: () {
            if (currentPage < totalPage) {
              setState(() {
                currentPage++;
                this.itemUnitList = getItemUnitList();
              });
            }
          },
        )
      ],
    );
  }

  void showInfoFormDialog(ItemUnit itemUnit) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: ItemUnitInfoDialog(itemUnit: itemUnit));
      },
    );
  }

  void showAddFormDialog() async {
    bool? isSuccess = await showDialog(
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

    if (isSuccess!= null && isSuccess) {
      loadAllData();
    }
  }

  void showModFormDialog(ItemUnit itemUnit) async {
    bool? isSuccess = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: ModItemUnitDialog(itemUnit: itemUnit));
      },
    );

    if (isSuccess!= null && isSuccess) {
      loadAllData();
    }
  }
}
