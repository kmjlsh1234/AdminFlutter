// 🎯 Dart imports:
// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/constants/user/drop_out_user_search_type.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/user/drop_out_user_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:acnoo_flutter_admin_panel/app/models/user/drop_out_user.dart';
import 'package:acnoo_flutter_admin_panel/app/models/user/drop_out_user_search_param.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/common_widget/generic_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../core/static/_static_values.dart';
import '../../core/utils/size_config.dart';
import '../../widgets/pagination_widgets/_pagination_widget.dart';
import '../../widgets/shadow_container/_shadow_container.dart';
import '../common_widget/search_form_field.dart';

class DropOutUserListView extends StatefulWidget {
  const DropOutUserListView({super.key});

  @override
  State<DropOutUserListView> createState() => _DropOutUserListViewState();
}

class _DropOutUserListViewState extends State<DropOutUserListView> {
  final DropOutUserService dropOutUserService = DropOutUserService();
  late Future<List<DropOutUser>> dropOutUserList;

  //Input Controller
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  //Paging
  int currentPage = 1;
  int rowsPerPage = 10;
  late Future<int> totalPage;

  //Search
  DropOutUserSearchType searchType = DropOutUserSearchType.EMAIL;
  String? searchValue;

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //탈퇴 유저 리스트 조회
  Future<List<DropOutUser>> getDropOutUserList() async {
    try {
      return await dropOutUserService.getDropOutUserList(getDropOutUserSearchParam());
    } catch (e) {
      ErrorHandler.handleError(e, context);
      return [];
    }
  }

  //탈퇴 유저 리스트 갯수 조회
  Future<int> getTotalCount() async {
    try {
      int count = await dropOutUserService.getDropOutUserListCount(getDropOutUserSearchParam());
      return (count / rowsPerPage).ceil();
    } catch (e) {
      ErrorHandler.handleError(e, context);
      return 0;
    }
  }

  DropOutUserSearchParam getDropOutUserSearchParam() {
    String? startDate = startDateController.text.isNotEmpty ? DateUtil.convertToLocalDateTime(startDateController.text) : null;
    String? endDate = endDateController.text.isNotEmpty ? DateUtil.convertToLocalDateTime(endDateController.text) : null;

    return DropOutUserSearchParam(
        searchType: searchType,
        searchValue: searchValue,
        startDate: startDate,
        endDate: endDate,
        page: currentPage,
        limit: rowsPerPage
    );
  }

  void loadAllData() {
    setState(() {
      dropOutUserList = getDropOutUserList();
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
                    future: dropOutUserList,
                    onSuccess: (BuildContext context, dropOutUserList) {
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
                                  child: GenericDropDown<DropOutUserSearchType>(
                                      labelText: lang.type,
                                      searchType: searchType,
                                      searchList: DropOutUserSearchType.values,
                                      callBack: (DropOutUserSearchType value) {
                                        searchType.value;
                                      }
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  flex: 3,
                                  child: SearchFormField(
                                      textTheme: textTheme,
                                      lang: lang,
                                      onPressed: (searchValue) {
                                        this.searchValue = searchValue;
                                        loadAllData();
                                      }),
                                ),
                                Spacer(flex: 2),

                                // START DATE
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: startDateController,
                                          readOnly: true,
                                          selectionControls: EmptyTextSelectionControls(),
                                          decoration: InputDecoration(
                                            labelText: lang.startDate,
                                            labelStyle: textTheme.bodySmall?.copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            hintText: lang.search,
                                            suffixIcon: const Icon(IconlyLight.calendar, size: 20), // 달력 아이콘
                                          ),
                                          onTap: () async {
                                            final result = await showDatePicker(
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
                                            if (result != null) {
                                              startDateController.text = DateFormat(DateUtil.dateTimeFormat).format(result);
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
                                          selectionControls: EmptyTextSelectionControls(),
                                          decoration: InputDecoration(
                                            labelText: lang.endDate,
                                            labelStyle: textTheme.bodySmall?.copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            hintText: lang.search,
                                            suffixIcon: const Icon(IconlyLight.calendar, size: 20), // 달력 아이콘
                                          ),
                                          onTap: () async {
                                            final result = await showDatePicker(
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
                                            if (result != null) {
                                              endDateController.text = DateFormat(DateUtil.dateTimeFormat).format(result);
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
                              child: dataTable(dropOutUserList),
                            ),
                          ),

                          //______________________________________________________________________footer__________________
                          Padding(
                              padding: _sizeInfo.padding,
                              child: FutureBuilderFactory.createFutureBuilder(
                                  future: totalPage,
                                  onSuccess: (context, totalPage) {
                                    return paginatedSection(totalPage, dropOutUserList);
                                  }
                              ),
                          )
                        ],
                      );
                  });
              },
            ),
          ),
        ),
      ),
    );
  }

  Theme dataTable(List<DropOutUser> dropOutUserList) {

    return Theme(
      data: ThemeData(
          dividerColor: theme.colorScheme.outline,
          dividerTheme: DividerThemeData(
            color: theme.colorScheme.outline,
          )
      ),
      child: DataTable(
        checkboxHorizontalMargin: 16,
        headingTextStyle: textTheme.titleMedium,
        dataTextStyle: textTheme.bodySmall,
        headingRowColor: WidgetStateProperty.all(theme.colorScheme.surface),
        showBottomBorder: true,
        columns: [
          DataColumn(label: Text(lang.dropOutUserId)),
          DataColumn(label: Text(lang.userId)),
          DataColumn(label: Text(lang.email)),
          DataColumn(label: Text(lang.mobile)),
          DataColumn(label: Text(lang.dropAt)),
        ],
        rows: dropOutUserList.map(
          (data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              cells: [
                DataCell(Text(data.id.toString())),
                DataCell(Text(data.userId.toString())),
                DataCell(Text(data.email)),
                DataCell(Text(data.mobile)),
                DataCell(Text(DateUtil.convertDateTimeToString(data.dropAt))),
              ],
            );
          },
        ).toList(),
      ),
    );
  }

  Row paginatedSection(int totalPage, List<DropOutUser> dropOutUserList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '${l.S.of(context).showing} ${(currentPage - 1) * rowsPerPage + 1} ${l.S.of(context).to} ${(currentPage - 1) * rowsPerPage + dropOutUserList.length} ${l.S.of(context).OF} ${dropOutUserList.length} ${l.S.of(context).entries}',
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
                this.dropOutUserList = getDropOutUserList();
              });
            }
          },
          onNextTap: () {
            if (currentPage < totalPage) {
              setState(() {
                currentPage++;
                this.dropOutUserList = getDropOutUserList();
              });
            }
          },
        )
      ],
    );
  }
}
