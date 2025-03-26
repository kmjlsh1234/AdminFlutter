// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../constants/shop/item/item_search_type.dart';
import '../../../../constants/shop/item/item_status.dart';
import '../../../../core/helpers/field_styles/_dropdown_styles.dart';
import '../../../../core/service/shop/item/item_service.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/date_util.dart';
import '../../../../core/utils/future_builder_factory.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/shop/item/item.dart';
import '../../../../models/shop/item/item_search_param.dart';
import '../../../../widgets/pagination_widgets/_pagination_widget.dart';
import '../../../common_widget/search_form_field.dart';

class SearchItemDialog extends StatefulWidget {
  const SearchItemDialog({super.key});

  @override
  State<SearchItemDialog> createState() => _SearchItemDialogState();
}

class _SearchItemDialogState extends State<SearchItemDialog> {
  final ItemService itemService = ItemService();
  late Future<List<Item>> itemList;

  ItemSearchType searchType = ItemSearchType.NAME;
  String? searchValue;

  //Paging
  int currentPage = 1;
  int rowsPerPage = 10;
  late Future<int> totalPage;

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
      int count =
      await itemService.getItemListCount(getItemSearchParam());
      return (count / rowsPerPage).ceil();
    } catch (e) {
      ErrorHandler.handleError(e, context);
      return 0;
    }
  }

  ItemSearchParam getItemSearchParam() {
    return ItemSearchParam(
        categoryId: null,
        searchStatus: ItemStatus.ON_SALE,
        searchType: searchType,
        searchValue: searchValue,
        page: currentPage,
        limit: rowsPerPage,
    );
  }

  void loadAllData() {
    setState(() {
      itemList = getItemList();
      totalPage = getTotalCount();
    });
  }

  @override
  void initState(){
    super.initState();
    loadAllData();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _sizeInfo = SizeConfig.getSizeInfo(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

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
                  Text(lang.role),
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
                  child: FutureBuilderFactory.createFutureBuilder(
                      future: itemList,
                      onSuccess: (context, itemList) {
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
                                    child: searchTypeDropDown(textTheme: textTheme, lang: lang),
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
                                ],
                              ),
                            ),

                            //______________________________________________________________________Data_table__________________
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: MediaQuery.of(context).size.width * 0.8,
                                  ),
                                  child: dataTable(itemList, theme, textTheme, lang)
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
                      }),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  ///_______________________________________________________________DropDownList___________________________________
  Container searchTypeDropDown({required TextTheme textTheme, required l.S lang}) {
    final _dropdownStyle = AcnooDropdownStyle(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 100, minWidth: 100),
      child: DropdownButtonFormField2<ItemSearchType>(
        decoration: InputDecoration(
            labelText: lang.type
        ),
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

  Theme dataTable(List<Item> itemList, ThemeData theme, TextTheme textTheme, l.S lang) {
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
        rows: itemList.map((data) {
            return DataRow(
              onSelectChanged: (bool? selected) => GoRouter.of(context).pop(data),
              color: WidgetStateColor.transparent,
              cells: [
                DataCell(Text(data.id.toString())),
                DataCell(Text(data.sku)),
                DataCell(Text(data.name)),
                DataCell(Text(DateUtil.convertDateTimeToString(data.createdAt))),
              ],
            );
          },
        ).toList(),
      ),
    );
  }

  Row paginatedSection(int totalPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

