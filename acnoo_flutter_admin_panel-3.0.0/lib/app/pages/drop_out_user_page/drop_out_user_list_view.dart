// 🎯 Dart imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
// 📦 Package imports:
import 'package:iconly/iconly.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../constants/user/drop_out_user_search_type.dart';
import '../../core/helpers/field_styles/_dropdown_styles.dart';
import '../../core/service/user/drop_out_user_service.dart';
import '../../core/theme/_app_colors.dart';
import '../../models/user/drop_out_user.dart';
import '../../models/user/drop_out_user_search_param.dart';
import '../../widgets/pagination_widgets/_pagination_widget.dart';
import '../../widgets/shadow_container/_shadow_container.dart';

class DropOutUserListView extends StatefulWidget {
  const DropOutUserListView({super.key});

  @override
  State<DropOutUserListView> createState() => _DropOutUserListViewState();
}

class _DropOutUserListViewState extends State<DropOutUserListView> {
  ///_____________________________________________________________________Variables_______________________________
  final DropOutUserService dropOutUserService = DropOutUserService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  late List<DropOutUser> dropOutUserList = [];
  int currentPage = 0;
  int _rowsPerPage = 10;
  int totalPage = 0;
  DropOutUserSearchType searchType = DropOutUserSearchType.none;
  String searchQuery = '';

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getDropOutUserList(context);
    getDropOutUserListCount(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ///_____________________________________________________________________api Functions__________________________________

  //탈퇴 유저 리스트 조회
  Future<void> getDropOutUserList(BuildContext context) async {
    List<DropOutUser> list = [];
    try {
      setState(() => isLoading = true);
      DropOutUserSearchParam dropOutUserSearchParam = DropOutUserSearchParam(
          (searchType == DropOutUserSearchType.none) ? null : searchType.value,
          searchQuery,
          startDateController.text,
          endDateController.text,
          currentPage + 1,
          _rowsPerPage
      );
      list = await dropOutUserService.getDropOutUserList(dropOutUserSearchParam);
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    setState(() {
      dropOutUserList = list;
      isLoading = false;
    });
  }



  //탈퇴 유저 리스트 갯수 조회
  Future<void> getDropOutUserListCount(BuildContext context) async {
    int count = 0;
    try {
      setState(() => isLoading = true);
      DropOutUserSearchParam dropOutUserSearchParam = DropOutUserSearchParam(
          (searchType == DropOutUserSearchType.none) ? null : searchType.value,
          searchQuery,
          startDateController.text,
          endDateController.text,
          currentPage + 1,
          _rowsPerPage
      );
      count = await dropOutUserService.getDropOutUserListCount(dropOutUserSearchParam);
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    setState(() {
      totalPage = (count / _rowsPerPage).ceil();
      isLoading = false;
    });
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
                                    '${l.S.of(context).showing} ${currentPage * _rowsPerPage + 1} ${l.S.of(context).to} ${currentPage * _rowsPerPage + dropOutUserList.length} ${l.S.of(context).OF} ${dropOutUserList.length} ${l.S.of(context).entries}',
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

  ///_____________________________________________________________________pagination_functions_______________________
  int get _totalPages => (dropOutUserList.length / _rowsPerPage).ceil();

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
        getDropOutUserList(context);
      });
    }
  }

  ///_____________________________________go_previous_page____________
  void _goToPreviousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        getDropOutUserList(context);
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
            '${l.S.of(context).showing} ${currentPage * _rowsPerPage + 1} ${l.S.of(context).to} ${currentPage * _rowsPerPage + dropOutUserList.length} ${l.S.of(context).OF} ${dropOutUserList.length} ${l.S.of(context).entries}',
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
              onPressed: () {
                getDropOutUserList(context);
                getDropOutUserListCount(context);
              },
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
      child: DropdownButtonFormField2<DropOutUserSearchType>(
        hint: Text('SearchType'),
        style: _dropdownStyle.textStyle,
        iconStyleData: _dropdownStyle.iconStyle,
        buttonStyleData: _dropdownStyle.buttonStyle,
        dropdownStyleData: _dropdownStyle.dropdownStyle,
        menuItemStyleData: _dropdownStyle.menuItemStyle,
        isExpanded: true,
        value: searchType,
        items: DropOutUserSearchType.values.map((DropOutUserSearchType value) {
          return DropdownMenuItem<DropOutUserSearchType>(
            value: value,
            child: Text(
              value.value,
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
          DataColumn(label: Text(lang.userId)),
          DataColumn(label: Text(lang.email)),
          DataColumn(label: Text(lang.phone)),
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
                DataCell(Text(data.mobile.toString())),
                DataCell(Text(data.dropAt.toString())),
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
