import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/models/currency/chip_record.dart';
import 'package:acnoo_flutter_admin_panel/app/models/currency/currency_record_search_param.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../generated/l10n.dart' as l;
import '../../core/constants/currency/change_type.dart';
import '../../core/helpers/field_styles/_dropdown_styles.dart';
import '../../core/service/currency/currency_record_service.dart';
import '../../core/static/_static_values.dart';
import '../../core/theme/_app_colors.dart';
import '../../widgets/file_export_button/file_export_button.dart';
import '../../widgets/pagination_widgets/_pagination_widget.dart';

class ChipRecordWidget extends StatefulWidget {
  const ChipRecordWidget({super.key, required this.userId, required this.constraints});

  final int userId;
  final BoxConstraints constraints;
  @override
  State<ChipRecordWidget> createState() => _ChipRecordWidgetState();
}

class _ChipRecordWidgetState extends State<ChipRecordWidget>{
  final ScrollController _scrollController = ScrollController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final CurrencyRecordService currencyRecordService = CurrencyRecordService();
  List<ChipRecord> chipList = [];
  int currentPage = 0;
  int rowsPerPage = 10;
  int totalPage = 1;
  ChangeType changeType = ChangeType.NONE;
  String searchQuery = '';
  bool isLoading = true;

  Future<void> getChipRecordList(BuildContext context) async {
    List<ChipRecord> list = [];
    try{
      setState(() => isLoading = true);
      CurrencyRecordSearchParam currencyRecordSearchParam = CurrencyRecordSearchParam(
          widget.userId,changeType== ChangeType.NONE ? null : changeType.changeType.toString(),
          startDateController.text,
          endDateController.text,
          currentPage + 1,
          rowsPerPage
      );
      list = await currencyRecordService.getChipRecordList(currencyRecordSearchParam);
    } catch(e){
      ErrorHandler.handleError(e, context);
    }
    chipList = list;
    setState(() => isLoading = false);
  }

  Future<void> getChipRecordListCount(BuildContext context) async {
    int count = 0;
    try{
      setState(() => isLoading = true);
      CurrencyRecordSearchParam currencyRecordSearchParam = CurrencyRecordSearchParam(
          widget.userId,changeType== ChangeType.NONE ? null : changeType.changeType.toString(),
          startDateController.text,
          endDateController.text,
          currentPage + 1,
          rowsPerPage
      );
      count = await currencyRecordService.getChipRecordListCount(currencyRecordSearchParam);
    } catch(e){
      ErrorHandler.handleError(e, context);
    }
    setState(() {
      totalPage = (count / rowsPerPage).ceil();
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getChipRecordList(context);
    getChipRecordListCount(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final lang = l.S.of(context);
    final double _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 16,
    );
    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
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
                      child:
                      searchFormField(textTheme: textTheme),
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
                          hintText: 'yyyy-MM-ddTHH:mm:ss',//'mm/dd/yyyy',
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
                          hintText: 'yyyy-MM-ddTHH:mm:ss',//'mm/dd/yyyy',
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
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: widget.constraints.maxWidth,
              ),
              child: Padding(
                padding: EdgeInsets.only(top: _padding),
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : chipListDataTable(context),
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
      ),
    );
  }

  ///_______________________________________________________________Search_Field___________________________________
  Container searchFormField({required TextTheme textTheme}) {
    final lang = l.S.of(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 440, minWidth: 230),
      child: TextFormField(
        decoration: InputDecoration(
          isDense: true,
          //hintText: 'Search...',
          hintText: '${lang.search}...',
          hintStyle: textTheme.bodySmall,
          suffixIcon: Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: AcnooAppColors.kPrimary700,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: ElevatedButton(
                onPressed: () {
                  getChipRecordList(context);
                  getChipRecordListCount(context);
                },
                child: Icon(
                    IconlyLight.search,
                    color: AcnooAppColors.kWhiteColor
                )
            ),
          ),
        ),
      ),
    );
  }
  ///_______________________________________________________________DropDownList___________________________________
  Container showingChangeTypeDropDown(
      {required TextTheme textTheme}) {
    final _dropdownStyle = AcnooDropdownStyle(context);
    //final theme = Theme.of(context);
    final lang = l.S.of(context);
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
        items: ChangeType.values.map((ChangeType value) {
          return DropdownMenuItem<ChangeType>(
            value: value,
            child: Text(
              value.changeType.toString(),
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
            '${l.S.of(context).showing} ${currentPage * rowsPerPage + 1} ${l.S.of(context).to} ${currentPage * rowsPerPage + chipList.length} ${l.S.of(context).OF} ${chipList.length} ${l.S.of(context).entries}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataTablePaginator(
          currentPage: currentPage + 1,
          totalPages: totalPage,
          onPreviousTap: _goToPreviousPage,
          onNextTap: _goToNextPage,
        )
      ],
    );
  }

  ///_____________________________________select_dropdown_val_________
  void _setRowsPerPage(int value) {
    setState(() {
      rowsPerPage = value;
      currentPage = 0;
    });
  }

  ///_____________________________________go_next_page________________
  void _goToNextPage() {
    if (currentPage < totalPage - 1) {
      setState(() {
        currentPage++;
        getChipRecordList(context);
      });
    }
  }

  ///_____________________________________go_previous_page____________
  void _goToPreviousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        getChipRecordList(context);
      });
    }
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

  Flexible buttonsWidget() {
    return Flexible(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox.square(
              dimension: 24), // Placeholder space for better alignment
          Flexible(
            child: FileExportButton.excel(
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: FileExportButton.csv(
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: FileExportButton.print(
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: FileExportButton.pdf(
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
