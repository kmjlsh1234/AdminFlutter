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
import '../../../core/constants/shop/item_unit/item_unit_type.dart';
import '../../../core/helpers/field_styles/_dropdown_styles.dart';
import '../../../core/service/shop/item_unit/item_unit_service.dart';
import '../../../core/theme/_app_colors.dart';
import '../../../models/shop/item_unit/item_unit.dart';
import '../../../models/shop/item_unit/item_unit_search_param.dart';
import '../../../widgets/pagination_widgets/_pagination_widget.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';
import '../../admin_manage_page/admin_add_popup.dart';
import 'add_item_unit_popup.dart';

class ItemUnitListView extends StatefulWidget {
  const ItemUnitListView({super.key});

  @override
  State<ItemUnitListView> createState() => _ItemUnitListViewState();
}

class _ItemUnitListViewState extends State<ItemUnitListView> {
  ///_____________________________________________________________________Variables_______________________________
  final ItemUnitService itemUnitService = ItemUnitService();
  late List<ItemUnit> itemUnitList = [];
  final ScrollController _scrollController = ScrollController();
  int currentPage = 0;
  int _rowsPerPage = 10;
  int totalPage = 0;
  ItemUnitType searchType = ItemUnitType.NONE;

  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getItemUnitList(context);
    getItemUnitListCount(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ///_____________________________________________________________________api Functions__________________________________
  //아이템 유닛 삭제
  Future<void> delItemUnit(BuildContext context, int unitId) async{
    try{
      bool isSuccess = await itemUnitService.delItemUnit(unitId);
      getItemUnitList(context);
      getItemUnitListCount(context);
    } catch (e){
      ErrorHandler.handleError(e, context);
    }
  }

  //아이템 유닛 리스트 조회
  Future<void> getItemUnitList(BuildContext context) async {
    List<ItemUnit> list = [];
    try {
      setState(() => isLoading = true);
      ItemUnitSearchParam itemUnitSearchParam = ItemUnitSearchParam(
          null,
          null,
          null,
          null,
          null,
          null,
          currentPage + 1,
          _rowsPerPage
      );
      list = await itemUnitService.getItemUnitList(itemUnitSearchParam);
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    setState(() {
      itemUnitList = list;
      isLoading = false;
    });
  }



  //아이템 유닛 리스트 갯수 조회
  Future<void> getItemUnitListCount(BuildContext context) async {
    int count = 0;
    try {
      setState(() => isLoading = true);
      ItemUnitSearchParam itemUnitSearchParam = ItemUnitSearchParam(
          null,
          null,
          null,
          null,
          null,
          null,
          currentPage + 1,
          _rowsPerPage
      );
      count = await itemUnitService.getItemUnitListCount(itemUnitSearchParam);
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    setState(() {
      totalPage = (count / _rowsPerPage).ceil();
      isLoading = false;
    });
  }

  ///_____________________________________________________________________Add_ItemUnit_____________________________
  void showAddFormDialog(BuildContext context) async {
    bool isItemUnitAdd = await showDialog(
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

    if(isItemUnitAdd){
      getItemUnitList(context);
      getItemUnitListCount(context);
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
                                    '${l.S.of(context).showing} ${currentPage * _rowsPerPage + 1} ${l.S.of(context).to} ${currentPage * _rowsPerPage + itemUnitList.length} ${l.S.of(context).OF} ${itemUnitList.length} ${l.S.of(context).entries}',
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
  int get _totalPages => (itemUnitList.length / _rowsPerPage).ceil();

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
        getItemUnitList(context);
      });
    }
  }

  ///_____________________________________go_previous_page____________
  void _goToPreviousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        getItemUnitList(context);
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
            '${l.S.of(context).showing} ${currentPage * _rowsPerPage + 1} ${l.S.of(context).to} ${currentPage * _rowsPerPage + itemUnitList.length} ${l.S.of(context).OF} ${itemUnitList.length} ${l.S.of(context).entries}',
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
              onPressed: () => getItemUnitList(context),
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
      child: DropdownButtonFormField2<ItemUnitType>(
        hint: Text('SearchType'),
        style: _dropdownStyle.textStyle,
        iconStyleData: _dropdownStyle.iconStyle,
        buttonStyleData: _dropdownStyle.buttonStyle,
        dropdownStyleData: _dropdownStyle.dropdownStyle,
        menuItemStyleData: _dropdownStyle.menuItemStyle,
        isExpanded: true,
        value: searchType,
        items: ItemUnitType.values.map((ItemUnitType value) {
          return DropdownMenuItem<ItemUnitType>(
            value: value,
            child: Text(
              value.type,
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
                        case 'Edit':
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('${lang.edit} ${data.name}')),
                          );
                          break;
                        case 'View':
                          GoRouter.of(context).go('/shops/item-unit/info/${data.id}');
                          break;
                        case 'Delete':
                          delItemUnit(context, data.id);
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
