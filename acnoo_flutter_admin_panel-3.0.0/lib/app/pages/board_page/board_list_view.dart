// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/models/board/board_search_param.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
// 📦 Package imports:
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../constants/board/board_status.dart';
import '../../constants/board/board_type.dart';
import '../../core/error/error_handler.dart';
import '../../core/helpers/helpers.dart';
import '../../core/service/board/board_service.dart';
import '../../core/theme/_app_colors.dart';
import '../../models/board/board.dart';
import '../../widgets/widgets.dart';

class BoardListView extends StatefulWidget {
  const BoardListView({super.key});

  @override
  State<BoardListView> createState() => _BoardListViewState();
}

class _BoardListViewState extends State<BoardListView> with SingleTickerProviderStateMixin {
  ///_____________________________________________________________________Variables_______________________________

  late List<Board> versionList = [];
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final BoardService boardService = BoardService();

  List<String> get _title => BoardType.values.map((e) => e.value).toList();
  BoardType boardType = BoardType.notice;
  int currentPage = 0;
  int rowsPerPage = 10;
  int totalPage = 0;
  String searchQuery = '';
  bool isLoading = true;

  //게시판 리스트 조회
  Future<void> getBoardList(BuildContext context) async {
    List<Board> list = [];
    try {
      setState(() => isLoading = true);

      BoardSearchParam boardSearchParam = BoardSearchParam(boardType.value, null, null, null, null, currentPage + 1, rowsPerPage);
      list = await boardService.getBoardList(boardSearchParam);
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    setState(() {
      versionList = list;
      isLoading = false;
    });
  }

  //게시판 리스트 갯수 조회
  Future<void> getBoardListCount(BuildContext context) async {
    int count = 0;
    try {
      setState(() => isLoading = true);

      BoardSearchParam boardSearchParam = BoardSearchParam(boardType.value, null, null, null, null, currentPage + 1, rowsPerPage);
      count = await boardService.getBoardListCount(boardSearchParam);
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    setState(() {
      totalPage = (count / rowsPerPage).ceil();
      isLoading = false;
    });
  }

  Future<void> delBoard(BuildContext context, int id) async {
    try{

    }catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  @override
  void initState() {
    super.initState();
    getBoardList(context);
    getBoardListCount(context);
    _tabController = TabController(length: _title.length, vsync: this);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final isMobile = constraints.maxWidth < 576;
                final isTablet =
                    constraints.maxWidth < 992 && constraints.maxWidth >= 576;
                return Padding(
                  padding: EdgeInsets.all(_padding),
                  child: ShadowContainer(
                    // headerPadding: EdgeInsets.zero,
                    contentPadding: EdgeInsets.zero,
                    customHeader: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TabBar(
                                indicatorPadding: EdgeInsets.zero,
                                splashBorderRadius: BorderRadius.circular(12),
                                isScrollable: true,
                                tabAlignment: TabAlignment.start,
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                indicatorSize: TabBarIndicatorSize.tab,
                                controller: _tabController,
                                indicatorColor: AcnooAppColors.kPrimary600,
                                indicatorWeight: 2.0,
                                dividerColor: Colors.transparent,
                                unselectedLabelColor:
                                    theme.colorScheme.onTertiary,
                                onTap: (value) => setState(() {
                                  boardType = BoardType.values[value];
                                  getBoardList(context);
                                  getBoardListCount(context);
                                }),
                                tabs: _title
                                    .map(
                                      (e) => Tab(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: _padding / 2,
                                          ),
                                          child: Text(e),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            //add_button_for_web
                            Visibility(
                              visible: constraints.maxWidth > 576,
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: _padding),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: 36,
                                      child: addBoard(textTheme, context),
                                    ),
                                  ],
                                ),
                              ),
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
                                      child: showingValueDropDown(
                                          isTablet: isTablet,
                                          isMobile: isMobile,
                                          textTheme: textTheme),
                                    ),
                                    const SizedBox(width: 16.0),
                                    Flexible(
                                      flex: isTablet ? 1 : 2,
                                      child:
                                          searchFormField(textTheme: textTheme),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          //______________________________________________________________________Data_table__________________
                          SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: constraints.maxWidth,
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(top: _padding),
                                child: userListDataTable(context),
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
                    ),
                  ),
                );
              },
            ),
          );
  }

  ///_____________________________________________________________________add_AppVersion_button___________________________
  ElevatedButton addBoard(TextTheme textTheme, BuildContext context) {
    final lang = l.S.of(context);
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: () {
        setState(() {
          GoRouter.of(context).go('/boards/write');
        });
      },
      label: Text(
        lang.addNewUser,
        //l.S.of(context).addNewUser,
        //'Add New User',
        maxLines: 1,
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

  ///_____________________________________go_next_page________________
  void _goToNextPage() {
    if (currentPage < totalPage - 1) {
      setState(() {
        currentPage++;
        getBoardList(context);
      });
    }
  }

  ///_____________________________________go_previous_page____________
  void _goToPreviousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        getBoardList(context);
      });
    }
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
            '${l.S.of(context).showing} ${currentPage * rowsPerPage + 1} ${l.S.of(context).to} ${currentPage * rowsPerPage + versionList.length} ${l.S.of(context).OF} ${versionList.length} ${l.S.of(context).entries}',
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
            child: const Icon(IconlyLight.search,
                color: AcnooAppColors.kWhiteColor),
          ),
        ),
      ),
    );
  }

  ///_______________________________________________________________DropDownList___________________________________
  Container showingValueDropDown(
      {required bool isTablet,
      required bool isMobile,
      required TextTheme textTheme}) {
    final _dropdownStyle = AcnooDropdownStyle(context);
    //final theme = Theme.of(context);
    final lang = l.S.of(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 100, minWidth: 100),
      child: DropdownButtonFormField2<int>(
        style: _dropdownStyle.textStyle,
        iconStyleData: _dropdownStyle.iconStyle,
        buttonStyleData: _dropdownStyle.buttonStyle,
        dropdownStyleData: _dropdownStyle.dropdownStyle,
        menuItemStyleData: _dropdownStyle.menuItemStyle,
        isExpanded: true,
        value: rowsPerPage,
        items: [10, 20, 30, 40, 50].map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(
              //isTablet || isMobile ? '$value' :
              '${lang.show} $value',
              style: textTheme.bodySmall,
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            //setRowsPerPage(value);
          }
        },
      ),
    );
  }

  ///_______________________________________________________________User_List_Data_Table___________________________
  Theme userListDataTable(BuildContext context) {
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
          DataColumn(label: Text(lang.title)),
          DataColumn(label: Text(lang.boardType)),
          DataColumn(label: Text(lang.boardStatus)),
          DataColumn(label: Text(lang.createdAt)),
          DataColumn(label: Text(lang.updatedAt)),
          DataColumn(label: Text(lang.actions)),
        ],
        rows: versionList.map(
          (data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              cells: [
                DataCell(
                  Text(
                    data.id.toString(),
                    maxLines: 1,
                  ),
                ),
                DataCell(
                  Text(
                    data.title,
                    maxLines: 1,
                  ),
                ),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: data.boardType == BoardType.event.value
                          ? AcnooAppColors.kWarning.withOpacity(0.2)
                          : AcnooAppColors.kInfo20Op,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      data.boardType,
                      maxLines: 1,
                      style: textTheme.bodySmall?.copyWith(
                        color: data.boardType == BoardType.event.value
                            ? AcnooAppColors.kWarning
                            : AcnooAppColors.kInfo,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: data.status == BoardStatus.publish.value
                          ? AcnooAppColors.kSuccess.withOpacity(0.2)
                          : AcnooAppColors.kError.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      data.status,
                      style: textTheme.bodySmall?.copyWith(
                          color:
                              data.status == BoardStatus.publish.value
                                  ? AcnooAppColors.kSuccess
                                  : AcnooAppColors.kError),
                    ),
                  ),
                ),
                DataCell(Text(
                  data.createdAt,
                  maxLines: 1,
                )),
                DataCell(Text(
                  data.updatedAt,
                  maxLines: 1,
                )),
                DataCell(
                  PopupMenuButton<int>(
                    iconColor: theme.colorScheme.onTertiary,
                    itemBuilder: (context) => {
                      // "View": FeatherIcons.eye,
                      // "Edit": FeatherIcons.edit,
                      // "Delete": FeatherIcons.trash2,

                      lang.view: FeatherIcons.eye,
                      lang.edit: FeatherIcons.edit,
                      lang.delete: FeatherIcons.trash2,
                    }
                        .entries
                        .toList()
                        .asMap()
                        .entries
                        .map(
                          (e) => PopupMenuItem<int>(
                            value: e.key,
                            child: Row(
                              children: [
                                Icon(
                                  e.value.value,
                                  color: theme.colorScheme.onTertiary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  e.value.key,
                                  style: theme.textTheme.bodyLarge?.copyWith(),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onSelected: (value) {
                      return switch (value) {
                        /*'View'*/ 0 => GoRouter.of(context).go('/boards/info/${data.id}'),
                        /*'Edit'*/ 1 => print('123'),//showModDialog(context, data),
                        /*'Delete'*/ 2 => print('123'),//delAppVersion(context, data.id),
                        _ => null,
                      };
                    },
                    color: theme.colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
/*
  Future<dynamic> _showDetailsDialog(
      BuildContext context, AppVersion data) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return DetailsDialog(
          appointment: version,
        );
      },
    );
  }
  */
}
