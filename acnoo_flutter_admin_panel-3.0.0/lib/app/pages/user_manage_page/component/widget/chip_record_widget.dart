// 🐦 Flutter imports:
import 'dart:developer';

import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/currency/currency_record_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:acnoo_flutter_admin_panel/app/models/currency/chip_record.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/common_widget/generic_drop_down.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../constants/currency/change_type.dart';
import '../../../../core/helpers/field_styles/_dropdown_styles.dart';
import '../../../../core/static/_static_values.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/compare_util.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/currency/currency_record_search_param.dart';
import '../../../../widgets/pagination_widgets/_pagination_widget.dart';

class ChipRecordWidget extends StatefulWidget {
  const ChipRecordWidget({
    super.key,
    required this.userId
  });

  final int userId;

  @override
  State<ChipRecordWidget> createState() => _ChipRecordWidgetState();
}

class _ChipRecordWidgetState extends State<ChipRecordWidget> {

  //Service
  final CurrencyRecordService currencyRecordService = CurrencyRecordService();

  //Future Model
  late Future<List<ChipRecord>> recordList;

  ///Search
  ChangeType changeType = ChangeType.NONE;

  //Search Date
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  //Paging
  int currentPage = 1;
  int rowsPerPage = 10;
  late Future<int> totalPage;

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //기록 리스트
  Future<List<ChipRecord>> getRecordList() async {
    try {
      return await currencyRecordService.getChipRecordList(getCurrencyRecordSearchParam());
    } catch (e) {
      log(e.toString());
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  //기록 리스트 갯수
  Future<int> getTotalCount() async {
    try {
      int count = await currencyRecordService.getChipRecordListCount(getCurrencyRecordSearchParam());
      return (count / rowsPerPage).ceil();
    } catch (e) {
      ErrorHandler.handleError(e, context);
      return 0;
    }
  }

  CurrencyRecordSearchParam getCurrencyRecordSearchParam() {
    String? startDate = startDateController.text.isNotEmpty ? DateUtil.convertToLocalDateTime(startDateController.text) : null;
    String? endDate = endDateController.text.isNotEmpty ? DateUtil.convertToLocalDateTime(endDateController.text) : null;

    return CurrencyRecordSearchParam(
        userId: widget.userId,
        changeType: (changeType == ChangeType.NONE) ? null : changeType,
        startDate: startDate,
        endDate: endDate,
        page: currentPage,
        limit: rowsPerPage
    );
  }

  void loadAllData() {
    setState(() {
      recordList = getRecordList();
      totalPage = getTotalCount();
    });
  }

  @override
  void initState() {
    super.initState();
    loadAllData();
  }

  @override
  Widget build(BuildContext context) {
    lang = l.S.of(context);
    theme = Theme.of(context);
    textTheme = Theme.of(context).textTheme;
    final sizeInfo = SizeConfig.getSizeInfo(context);
    final double padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 16,
    );

    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //______________________________________________________________________Header__________________
                Padding(
                  padding: sizeInfo.padding,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: GenericDropDown<ChangeType>(
                            labelText: lang.status,
                            searchType: changeType,
                            searchList: ChangeType.values,
                            callBack: (ChangeType value) {
                              changeType = value;
                            }
                        ),
                      ),
                      const SizedBox(width: 8.0),

                      // START DATE
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: startDateController,
                                readOnly: true,
                                selectionControls:
                                EmptyTextSelectionControls(),
                                decoration: InputDecoration(
                                  labelText: lang.startDate,
                                  labelStyle: textTheme.bodySmall?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  hintText: lang.search,
                                  suffixIcon: const Icon(
                                      IconlyLight.calendar,
                                      size: 20), // 달력 아이콘
                                ),
                                onTap: () async {
                                  final result = await showDatePicker(
                                    context: context,
                                    firstDate: AppDateConfig.appFirstDate,
                                    lastDate: AppDateConfig.appLastDate,
                                    initialDate: DateTime.now(),
                                    builder: (context, child) => Theme(
                                      data: theme.copyWith(
                                        datePickerTheme:
                                        DatePickerThemeData(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(4),
                                          ),
                                        ),
                                      ),
                                      child: child!,
                                    ),
                                  );
                                  if (result != null) {
                                    startDateController.text =
                                        DateFormat(DateUtil.dateTimeFormat)
                                            .format(result);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8.0),

                      //END DATE
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: endDateController,
                                readOnly: true,
                                selectionControls:
                                EmptyTextSelectionControls(),
                                decoration: InputDecoration(
                                  labelText: lang.endDate,
                                  labelStyle: textTheme.bodySmall?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  hintText: lang.search,
                                  suffixIcon: const Icon(
                                      IconlyLight.calendar,
                                      size: 20), // 달력 아이콘
                                ),
                                onTap: () async {
                                  final result = await showDatePicker(
                                    context: context,
                                    firstDate: AppDateConfig.appFirstDate,
                                    lastDate: AppDateConfig.appLastDate,
                                    initialDate: DateTime.now(),
                                    builder: (context, child) => Theme(
                                      data: theme.copyWith(
                                        datePickerTheme:
                                        DatePickerThemeData(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(4),
                                          ),
                                        ),
                                      ),
                                      child: child!,
                                    ),
                                  );
                                  if (result != null) {
                                    endDateController.text =
                                        DateFormat(DateUtil.dateTimeFormat)
                                            .format(result);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16.0),

                      IconButton(
                        icon: const Icon(Icons.refresh, size: 20),
                        onPressed: () {
                          startDateController.clear();
                          endDateController.clear();
                        },
                      ),

                      const SizedBox(width: 25.0),

                      ElevatedButton(
                        onPressed: () => loadAllData(),
                        child: const Icon(IconlyLight.search,
                            color: AcnooAppColors.kWhiteColor),
                      ),

                      Spacer(flex: 3),
                    ],
                  ),
                ),

                //______________________________________________________________________Data_table__________________
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: padding),
                      child: FutureBuilderFactory.createFutureBuilder(
                          future: recordList,
                          onSuccess: (context, recordList) {
                            return dataTable(recordList);
                          }),
                    ),
                  ),
                ),

                //______________________________________________________________________footer__________________
                Padding(
                  padding: EdgeInsets.all(padding),
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
    );

  }

  Theme dataTable(List<ChipRecord> recordList) {

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
          DataColumn(label: Text(lang.currencyRecordId)),
          DataColumn(label: Text(lang.changeType)),
          DataColumn(label: Text(lang.changeAmount)),
          DataColumn(label: Text(lang.resultAmount)),
          DataColumn(label: Text(lang.changeDesc)),
          DataColumn(label: Text(lang.createdAt)),
        ],
        rows: recordList.map((data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              cells: [
                DataCell(Text(data.id.toString())),
                DataCell(Text(data.changeType.value)),
                DataCell(Text(data.changeChip.toString())),
                DataCell(Text(data.resultChip.toString())),
                DataCell(Text(data.changeDesc)),
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
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DataTablePaginator(
          currentPage: currentPage,
          totalPages: totalPage,
          onPreviousTap: () {
            if (currentPage > 1) {
              setState(() {
                currentPage--;
                recordList = getRecordList();
              });
            }
          },
          onNextTap: (){
            if (currentPage < totalPage) {
              setState(() {
                currentPage++;
                recordList = getRecordList();
              });
            }
          },
        )
      ],
    );
  }

  ///_______________________________________________________________DropDownList___________________________________
  Container showingChangeTypeDropDown() {
    final _dropdownStyle = AcnooDropdownStyle(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 100, minWidth: 100),
      child: DropdownButtonFormField2<ChangeType>(
        hint: Text(lang.changeType),
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
}
