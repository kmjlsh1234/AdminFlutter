// 🎯 Dart imports:
import 'dart:ui';

// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/constants/shop/item_unit/item_unit_search_type.dart';
import 'package:acnoo_flutter_admin_panel/app/constants/shop/item_unit/item_unit_type.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/size_config.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/common_widget/custom_button.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../constants/common/action_menu.dart';
import '../../../core/service/shop/item_unit/item_unit_service.dart';
import '../../../core/theme/_app_colors.dart';
import '../../../models/shop/item_unit/item_unit.dart';
import '../../../models/shop/item_unit/item_unit_search_param.dart';
import '../../../widgets/pagination_widgets/_pagination_widget.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';
import '../../common_widget/generic_drop_down.dart';
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
  //UI Controller
  final ScrollController scrollController = ScrollController();

  //Service Layer
  final ItemUnitService itemUnitService = ItemUnitService();

  //Future Model
  late Future<List<ItemUnit>> itemUnitList;

  //Paging
  int currentPage = 1;
  int rowsPerPage = 10;
  late Future<int> totalPage;

  //Search
  ItemUnitSearchType searchType = ItemUnitSearchType.NAME;
  String? searchValue;

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //아이템 유닛 리스트 조회
  Future<List<ItemUnit>> getItemUnitList() async {
    try {
      return await itemUnitService.getItemUnitList(getItemUnitSearchParam());
    } catch (e) {
      ErrorHandler.handleError(e, context);
      return [];
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
      return 0;
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
        searchType: searchType,
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
    lang = l.S.of(context);
    theme = Theme.of(context);
    textTheme = Theme.of(context).textTheme;
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
                          Expanded(
                            flex: 1,
                            child: GenericDropDown<ItemUnitSearchType>(
                                labelText: lang.type,
                                searchType: searchType,
                                searchList: ItemUnitSearchType.values,
                                callBack: (ItemUnitSearchType value) {
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
                                  setState(() {
                                    this.searchValue = searchValue;
                                    loadAllData();
                                  });
                                }),
                          ),
                          Spacer(flex: 4),
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
                        child: FutureBuilderFactory.createFutureBuilder(
                            future: itemUnitList,
                            onSuccess: (context, itemUnitList){
                              return dataTable(itemUnitList, theme, textTheme, lang);
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
          DataColumn(label: Text(lang.itemUnitId)),
          DataColumn(label: Text(lang.itemUnitSku)),
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
                DataCell(
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: selectTypeColor(data.type.value, 0.2),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      data.type.value,
                      style: textTheme.bodySmall?.copyWith(
                          color:selectTypeColor(data.type.value, 1)
                      ),
                    ),
                  ),
                ),
                DataCell(
                    Text(DateUtil.convertDateTimeToString(data.createdAt))),
                DataCell(
                    Text(DateUtil.convertDateTimeToString(data.updatedAt))),
                DataCell(
                  PopupMenuButton<ActionMenu>(
                    iconColor: theme.colorScheme.onTertiary,
                    color: theme.colorScheme.primaryContainer,
                    onSelected: (action) {
                      switch (action) {
                        case ActionMenu.EDIT:
                          showModFormDialog(data);
                          break;
                        case ActionMenu.VIEW:
                          showInfoFormDialog(data);
                          break;
                        case ActionMenu.DELETE:
                          delItemUnit(data.id);
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
                          value: ActionMenu.VIEW,
                          child: Text(lang.view),
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

  Color selectTypeColor(String type, double alpha){
    if(type == ItemUnitType.CONSUMABLE.value) {
      return AcnooAppColors.kSuccess.withValues(alpha: alpha);
    } else if(type == ItemUnitType.PERMANENT.value) {
      return AcnooAppColors.kInfo.withValues(alpha: alpha);
    }
    else if(type == ItemUnitType.EXPIRATION.value) {
      return AcnooAppColors.kError.withValues(alpha: alpha);
    }
    else {
      return AcnooAppColors.kSuccess.withValues(alpha: alpha);
    }
  }
}
