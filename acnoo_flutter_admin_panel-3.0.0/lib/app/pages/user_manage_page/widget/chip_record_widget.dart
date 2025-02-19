import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/size_config.dart';
import 'package:acnoo_flutter_admin_panel/app/models/currency/chip_record.dart';
import 'package:acnoo_flutter_admin_panel/app/models/currency/currency_record_search_param.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../../generated/l10n.dart' as l;
import '../../../constants/currency/change_type.dart';
import '../../../core/helpers/field_styles/_dropdown_styles.dart';
import '../../../core/service/currency/currency_record_service.dart';
import '../../../core/static/_static_values.dart';
import '../../../widgets/pagination_widgets/_pagination_widget.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';
import '../../common_widget/search_form_field.dart';

class ChipRecordWidget extends StatefulWidget {
  const ChipRecordWidget({super.key, required this.userId, required this.constraints});

  final int userId;
  final BoxConstraints constraints;

  @override
  State<ChipRecordWidget> createState() => _ChipRecordWidgetState();
}

class _ChipRecordWidgetState extends State<ChipRecordWidget> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final CurrencyRecordService currencyRecordService = CurrencyRecordService();

  late List<ChipRecord> chipList;
  bool isLoading = true;

  //Search
  ChangeType changeType = ChangeType.none;
  String searchValue = '';

  //Paging
  int currentPage = 1;
  int rowsPerPage = 10;
  int totalPage = 0;

  //Chip 기록 리스트
  Future<List<ChipRecord>> getChipRecordList() async {
    List<ChipRecord> list = [];
    try {
      CurrencyRecordSearchParam currencyRecordSearchParam = getCurrencyRecordSearchParam();
      list = await currencyRecordService.getChipRecordList(currencyRecordSearchParam);
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    return list;
  }

  //Chip 기록 리스트 갯수
  Future<int> getChipRecordListCount() async {
    int count = 0;
    try {
      CurrencyRecordSearchParam currencyRecordSearchParam = getCurrencyRecordSearchParam();
      count = await currencyRecordService.getChipRecordListCount(currencyRecordSearchParam);
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    int totalPage = (count / rowsPerPage).ceil();
    return totalPage;
  }

  //LIST + COUNT
  Future<void> searchListWithCount() async {
    setState(() => isLoading = true);
    List<dynamic> results = await Future.wait([getChipRecordList(), getChipRecordListCount()]);
    setState(() {
      chipList = results[0];
      totalPage = results[1];
      isLoading = false;
    });
  }

  //LIST
  Future<void> searchList() async {
    setState(() => isLoading = true);
    List<ChipRecord> list = await getChipRecordList();
    setState(() {
      chipList = list;
      isLoading = false;
    });
  }

  CurrencyRecordSearchParam getCurrencyRecordSearchParam() {
    return CurrencyRecordSearchParam(
        widget.userId,
        changeType == ChangeType.none ? null : changeType.value,
        startDateController.text,
        endDateController.text,
        currentPage,
        rowsPerPage);
  }

  void goToNextPage() {
    if (currentPage < totalPage) {
      currentPage++;
      searchList();
    }
  }

  void goToPreviousPage() {
    if (currentPage > 1) {
      currentPage--;
      searchList();
    }
  }

  @override
  void initState() {
    super.initState();
    searchListWithCount();
  }

  @override
  void dispose() {
    scrollController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final lang = l.S.of(context);
    final _sizeInfo = SizeConfig.getSizeInfo(context);
    final double _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 16,
    );

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
        body: Padding(
        padding: _sizeInfo.padding,
        child: ShadowContainer(
        showHeader: false,
        contentPadding: EdgeInsets.zero,
          child: SingleChildScrollView(
            padding: const EdgeInsetsDirectional.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //______________________________________________________________________Header__________________
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: showingChangeTypeDropDown(textTheme: textTheme),
                                ),
                                const SizedBox(width: 16.0),
                                Flexible(
                                  flex: 2,
                                  child: SearchFormField(
                                      textTheme: textTheme,
                                      lang: lang,
                                      onPressed: (searchValue) {
                                        this.searchValue = searchValue;
                                        searchListWithCount();
                                      }),
                                ),
                                const SizedBox(width: 16.0),
                                Flexible(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: startDateController,
                                    keyboardType: TextInputType.visiblePassword,
                                    readOnly: true,
                                    selectionControls: EmptyTextSelectionControls(),
                                    decoration: InputDecoration(
                                      labelText: l.S.of(context).startDate,
                                      labelStyle: textTheme.bodySmall?.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      hintText: 'yyyy-MM-ddTHH:mm:ss', //'mm/dd/yyyy',
                                      suffixIcon:
                                      const Icon(IconlyLight.calendar, size: 20),
                                    ),
                                    onTap: () async {
                                      final _result = await showDatePicker(
                                        context: context,
                                        firstDate: AppDateConfig.appFirstDate,
                                        lastDate: AppDateConfig.appLastDate,
                                        initialDate: DateTime.now(),
                                        builder: (context, child) => Theme(
                                          data: theme.copyWith(
                                            datePickerTheme: DatePickerThemeData(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        ),
                                      );
                                      if (_result != null) {
                                        startDateController.text = DateFormat(
                                          //AppDateConfig.appNumberOnlyDateFormat,
                                          AppDateConfig.localDateTimeFormat,
                                        ).format(_result);
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Flexible(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: endDateController,
                                    keyboardType: TextInputType.visiblePassword,
                                    readOnly: true,
                                    selectionControls: EmptyTextSelectionControls(),
                                    decoration: InputDecoration(
                                      labelText: l.S.of(context).endDate,
                                      labelStyle: textTheme.bodySmall?.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      hintText: 'yyyy-MM-ddTHH:mm:ss', //'mm/dd/yyyy',
                                      suffixIcon:
                                      const Icon(IconlyLight.calendar, size: 20),
                                    ),
                                    onTap: () async {
                                      final _result = await showDatePicker(
                                        context: context,
                                        firstDate: AppDateConfig.appFirstDate,
                                        lastDate: AppDateConfig.appLastDate,
                                        initialDate: DateTime.now(),
                                        builder: (context, child) => Theme(
                                          data: theme.copyWith(
                                            datePickerTheme: DatePickerThemeData(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        ),
                                      );
                                      if (_result != null) {
                                        endDateController.text = DateFormat(
                                          //AppDateConfig.appNumberOnlyDateFormat,
                                          AppDateConfig.localDateTimeFormat,
                                        ).format(_result);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),
                          // Ensures proper alignment by pushing the next element to the end
                          //buttonsWidget(),
                        ],
                      ),

                      //______________________________________________________________________Data_table__________________
                      SingleChildScrollView(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: widget.constraints.maxWidth,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: _padding),
                            child: chipListDataTable(context),
                          ),
                        ),
                      ),

                      //______________________________________________________________________footer__________________
                      Padding(
                        padding: EdgeInsets.all(_padding),
                        child: paginatedSection(
                          theme,
                          textTheme,
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ),
        ),
    );
  }

  ///_______________________________________________________________DropDownList___________________________________
  Container showingChangeTypeDropDown({required TextTheme textTheme}) {
    final _dropdownStyle = AcnooDropdownStyle(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 100, minWidth: 100),
      child: DropdownButtonFormField2<ChangeType>(
        hint: Text('changeType'),
        style: _dropdownStyle.textStyle,
        iconStyleData: _dropdownStyle.iconStyle,
        buttonStyleData: _dropdownStyle.buttonStyle,
        dropdownStyleData: _dropdownStyle.dropdownStyle,
        menuItemStyleData: _dropdownStyle.menuItemStyle,
        isExpanded: true,
        value: changeType,
        items: ChangeType.values.map((ChangeType changeType) {
          return DropdownMenuItem<ChangeType>(
            value: changeType,
            child: Text(
              changeType.value,
              style: textTheme.bodySmall,
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            changeType = value;
          }
        },
      ),
    );
  }

  ///_______________________________________________________________pagination_footer_______________________________
  Row paginatedSection(ThemeData theme, TextTheme textTheme) {
    // ignore: unused_local_variable
    final lang = l.S.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '${l.S.of(context).showing} ${(currentPage - 1) * rowsPerPage + 1} ${l.S.of(context).to} ${(currentPage - 1) * rowsPerPage + chipList.length} ${l.S.of(context).OF} ${chipList.length} ${l.S.of(context).entries}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataTablePaginator(
          currentPage: currentPage,
          totalPages: totalPage,
          onPreviousTap: goToPreviousPage,
          onNextTap: goToNextPage,
        )
      ],
    );
  }

  ///_______________________________________________________________User_List_Data_Table___________________________
  Theme chipListDataTable(BuildContext context) {
    final theme = Theme.of(context);
    final lang = l.S.of(context);
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
          DataColumn(label: Text('${lang.SL}.')),
          DataColumn(label: Text(lang.changeType)),
          DataColumn(label: Text(lang.changeAmount)),
          DataColumn(label: Text(lang.resultAmount)),
          DataColumn(label: Text(lang.changeDesc)),
          DataColumn(label: Text(lang.createdAt)),
        ],
        rows: chipList.map(
          (data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              cells: [
                DataCell(Text(
                  data.id.toString(),
                  maxLines: 1,
                )),
                DataCell(
                  Text(
                    data.changeType,
                    maxLines: 1,
                  ),
                ),
                DataCell(
                  Text(
                    data.changeChip.toString(),
                    maxLines: 1,
                  ),
                ),
                DataCell(
                  Text(
                    data.resultChip.toString(),
                    maxLines: 1,
                  ),
                ),
                DataCell(
                  Text(
                    data.changeDesc,
                    maxLines: 1,
                  ),
                ),
                DataCell(
                  Text(
                    data.createdAt,
                    maxLines: 1,
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
