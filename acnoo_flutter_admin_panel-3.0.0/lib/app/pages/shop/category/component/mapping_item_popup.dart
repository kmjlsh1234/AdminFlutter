// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/item/item_search_param.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/service/shop/item/item_service.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/date_util.dart';
import '../../../../core/utils/future_builder_factory.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/shop/item/item.dart';
import '../../../../widgets/pagination_widgets/_pagination_widget.dart';

class MappingItemDialog extends StatefulWidget {
  const MappingItemDialog({super.key, required this.categoryId});

  final int categoryId;

  @override
  State<MappingItemDialog> createState() => _MappingItemDialogState();
}

class _MappingItemDialogState extends State<MappingItemDialog> {
  final ItemService itemService = ItemService();
  late Future<List<Item>> itemList;

  //Paging
  int currentPage = 1;
  int rowsPerPage = 10;
  late Future<int> totalPage;

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //아이템 리스트 조회
  Future<List<Item>> getItemList() async {
    try {
      return await itemService.getItemList(getItemSearchParam());
    } catch (e) {
      ErrorHandler.handleError(e, context);
      return [];
    }
  }

  //아이템 리스트 갯수 조회
  Future<int> getTotalCount() async {
    try {
      int count = await itemService.getItemListCount(getItemSearchParam());
      return (count / rowsPerPage).ceil();
    } catch (e) {
      ErrorHandler.handleError(e, context);
      return 0;
    }
  }

  ItemSearchParam getItemSearchParam() {
    return ItemSearchParam(
        categoryId: widget.categoryId,
        searchStatus: null,
        searchType: null,
        searchValue: null,
        page: currentPage,
        limit: rowsPerPage);
  }

  void loadAllData() {
    setState(() {
      itemList = getItemList();
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
                  Text(lang.item),
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
                      //______________________________________________________________________Data_table__________________
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width * 0.8,
                          ),
                          child: FutureBuilderFactory.createFutureBuilder(
                              future: itemList,
                              onSuccess: (context, itemList) {
                                return dataTable(itemList);
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

  Theme dataTable(List<Item> itemList) {
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
          DataColumn(label: Text(lang.itemId)),
          DataColumn(label: Text(lang.sku)),
          DataColumn(label: Text(lang.name)),
          DataColumn(label: Text(lang.createdAt)),
        ],
        rows: itemList.map(
          (data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              cells: [
                DataCell(Text(data.id.toString())),
                DataCell(Text(data.sku)),
                DataCell(Text(data.name)),
                DataCell(
                    Text(DateUtil.convertDateTimeToString(data.createdAt))),
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
}
