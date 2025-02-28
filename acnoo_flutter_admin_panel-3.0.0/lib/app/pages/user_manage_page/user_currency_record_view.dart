// 🐦 Flutter imports:

import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../../generated/l10n.dart' as l;
import '../../constants/currency/change_type.dart';
import '../../constants/shop/item/currency_type.dart';
import '../../constants/user/user_menu.dart';
import '../../core/error/error_handler.dart';
import '../../core/helpers/field_styles/_dropdown_styles.dart';
import '../../core/service/currency/currency_record_service.dart';
import '../../core/static/_static_values.dart';
import '../../core/utils/compare_util.dart';
import '../../core/utils/future_builder_factory.dart';
import '../../models/currency/base_currency_record.dart';
import '../../models/currency/currency_record_search_param.dart';
import '../../widgets/widgets.dart';
import '../common_widget/search_form_field.dart';
import 'component/nav_bar/currency_nav_tab_bar.dart';
import 'component/nav_bar/user_nav_bar.dart';


class UserCurrencyRecordView extends StatefulWidget {
  const UserCurrencyRecordView({super.key, required this.userId});
  final int userId;

  @override
  State<UserCurrencyRecordView> createState() => _UserCurrencyRecordViewState();
}

class _UserCurrencyRecordViewState extends State<UserCurrencyRecordView> {
  UserMenu currentMenu = UserMenu.currencyRecord;
  CurrencyType currentCurrency = CurrencyType.chip;

  final ScrollController scrollController = ScrollController();

  //Service
  final CurrencyRecordService currencyRecordService = CurrencyRecordService();

  //Future Model
  late Future<List<BaseCurrencyRecord>> recordList;

  ///Search
  ChangeType changeType = ChangeType.none;
  String searchValue = '';

  //Search Date
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  //Paging
  int currentPage = 1;
  int rowsPerPage = 10;
  late Future<int> totalPage;

  //기록 리스트
  Future<List<BaseCurrencyRecord>> getChipRecordList() async {
    try {
      switch(currentCurrency){
        case CurrencyType.diamond:
          return await currencyRecordService.getDiamondRecordList(getCurrencyRecordSearchParam());
        case CurrencyType.coin:
          return await currencyRecordService.getCoinRecordList(getCurrencyRecordSearchParam());
        case CurrencyType.chip:
          return await currencyRecordService.getChipRecordList(getCurrencyRecordSearchParam());
        case CurrencyType.free:
          break;
        case CurrencyType.event:
          break;
      }
      return [];
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  //기록 리스트 갯수
  Future<int> getTotalCount() async {
    try {
      int count = 0;
      switch(currentCurrency){
        case CurrencyType.diamond:
          count =  await currencyRecordService.getDiamondRecordListCount(getCurrencyRecordSearchParam());
          break;
        case CurrencyType.coin:
          count =  await currencyRecordService.getChipRecordListCount(getCurrencyRecordSearchParam());
        case CurrencyType.chip:
          count =  await currencyRecordService.getChipRecordListCount(getCurrencyRecordSearchParam());
          break;
        case CurrencyType.free:
          break;
        case CurrencyType.event:
          break;
      }

      return (count / rowsPerPage).ceil();
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  CurrencyRecordSearchParam getCurrencyRecordSearchParam() {
    String? type = CompareUtil.compareStringValue(ChangeType.none.value, changeType.value);
    return CurrencyRecordSearchParam(
        userId: widget.userId,
        changeType: type,
        startDate: DateUtil.convertStringToLocalDateTime(startDateController.text),
        endDate: DateUtil.convertStringToLocalDateTime(endDateController.text),
        page: currentPage,
        limit: rowsPerPage
    );
  }

  void loadAllData() {
    setState(() {
      recordList = getChipRecordList();
      totalPage = getTotalCount();
    });
  }

  void selectCurrency(CurrencyType type){
    CurrencyType currencyType = type;
    setState(() {
      currentCurrency = currencyType;
      loadAllData();
    });
  }

  @override
  void initState(){
    super.initState();
    loadAllData();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final l.S lang = l.S.of(context);
    final double padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 16,
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: EdgeInsets.all(padding),
            child: ShadowContainer(
              contentPadding: EdgeInsets.zero,
              customHeader: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: UserNavBar(userMenu: currentMenu, userId: widget.userId),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 0.3,
                    height: 0,
                    color: theme.colorScheme.outline,
                  )
                ],
              ),
              child: Column(
                children: [
                  ShadowContainer(
                    customHeader: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CurrencyNavTabBar(onTabSelected: selectCurrency, selectCurrency: currentCurrency),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 0.3,
                          height: 0,
                          color: theme.colorScheme.outline,
                        )
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsetsDirectional.all(16),
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints) {
                            return FutureBuilderFactory.createFutureBuilder(
                                future: recordList,
                                onSuccess: (context, recordList){
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
                                                        loadAllData();
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
                                            minWidth: constraints.maxWidth,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(top: padding),
                                            child: dataTable(recordList, theme, textTheme, lang),
                                          ),
                                        ),
                                      ),

                                      //______________________________________________________________________footer__________________
                                      Padding(
                                        padding: EdgeInsets.all(padding),
                                        child: FutureBuilderFactory.createFutureBuilder(
                                            future: totalPage,
                                            onSuccess: (context, totalPage) {
                                              return paginatedSection(totalPage, recordList);
                                            }
                                        ),
                                      ),
                                    ],
                                  );
                                });

                          }),
                    ),
                  ),
                ],
              )
            ),
          );
        },
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

  Row paginatedSection(int totalPage, List<BaseCurrencyRecord> recordList) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '${l.S.of(context).showing} ${(currentPage - 1) * rowsPerPage + 1} ${l.S.of(context).to} ${(currentPage - 1) * rowsPerPage + recordList.length} ${l.S.of(context).OF} ${recordList.length} ${l.S.of(context).entries}',
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
                this.recordList = getChipRecordList();
              });
            }
          },
          onNextTap: (){
            if (currentPage < totalPage) {
              setState(() {
                currentPage++;
                this.recordList = getChipRecordList();
              });
            }
          },
        )
      ],
    );
  }


  Theme dataTable(List<BaseCurrencyRecord> recordList, ThemeData theme, TextTheme textTheme, l.S lang) {

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
        rows: recordList.map(
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
                    data.changeAmount.toString(),
                    maxLines: 1,
                  ),
                ),
                DataCell(
                  Text(
                    data.resultAmount.toString(),
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
                    DateUtil.convertDateTimeToString(data.createdAt),
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
