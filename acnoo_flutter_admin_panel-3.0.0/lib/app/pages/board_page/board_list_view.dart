// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:acnoo_flutter_admin_panel/app/models/board/board_search_param.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/common_widget/generic_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../constants/board/board_status.dart';
import '../../constants/board/board_type.dart';
import '../../constants/common/action_menu.dart';
import '../../core/error/error_handler.dart';
import '../../core/service/board/board_service.dart';
import '../../core/theme/_app_colors.dart';
import '../../core/utils/size_config.dart';
import '../../models/board/board_simple.dart';
import '../../widgets/widgets.dart';
import '../common_widget/custom_button.dart';
import '../common_widget/search_form_field.dart';

class BoardListView extends StatefulWidget {
  const BoardListView({super.key});

  @override
  State<BoardListView> createState() => _BoardListViewState();
}

class _BoardListViewState extends State<BoardListView>
    with SingleTickerProviderStateMixin {
  final BoardService boardService = BoardService();
  late TabController tabController;

  late Future<List<BoardSimple>> boardList;

  //Paging
  int currentPage = 1;
  int rowsPerPage = 10;
  late Future<int> totalPage;

  //Search
  BoardType boardType = BoardType.NOTICE;
  BoardStatus boardStatus = BoardStatus.PUBLISH;
  String? searchValue;

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //게시판 리스트 조회
  Future<List<BoardSimple>> getBoardList() async {
    try {
      return await boardService.getBoardList(getBoardSearchParam());
    } catch (e) {
      ErrorHandler.handleError(e, context);
      return [];
    }
  }

  //게시판 리스트 갯수 조회
  Future<int> getTotalCount() async {
    try {
      int count = await boardService.getBoardListCount(getBoardSearchParam());
      return (count / rowsPerPage).ceil();
    } catch (e) {
      ErrorHandler.handleError(e, context);
      return 0;
    }
  }

  Future<void> delBoard(int boardId) async {
    try {

    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  BoardSearchParam getBoardSearchParam() {
    return BoardSearchParam(
        boardType: boardType,
        boardStatus: boardStatus,
        searchValue: searchValue,
        page: currentPage,
        limit: rowsPerPage);
  }

  void loadAllData() {
    setState(() {
      boardList = getBoardList();
      totalPage = getTotalCount();
    });
  }

  @override
  void initState() {
    super.initState();
    loadAllData();
    tabController = TabController(length: BoardType.values.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    lang = l.S.of(context);
    theme = Theme.of(context);
    textTheme = Theme.of(context).textTheme;
    final _sizeInfo = SizeConfig.getSizeInfo(context);
    final double _padding = responsiveValue<double>(
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
            padding: _sizeInfo.padding,
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
                          controller: tabController,
                          indicatorColor: AcnooAppColors.kPrimary600,
                          indicatorWeight: 2.0,
                          dividerColor: Colors.transparent,
                          unselectedLabelColor:
                          theme.colorScheme.onTertiary,
                          onTap: (value) =>
                              setState(() {
                                boardType = BoardType.values[value];
                                loadAllData();
                              }),
                          tabs: BoardType.values
                              .map((type) =>
                              Tab(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: _padding / 2,
                                  ),
                                  child: Text(type.value),
                                ),
                              ),
                          )
                              .toList(),
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
                physics: const AlwaysScrollableScrollPhysics(),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
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
                                child: GenericDropDown<BoardStatus>(
                                    labelText: lang.status,
                                    searchType: boardStatus,
                                    searchList: BoardStatus.values,
                                    callBack: (BoardStatus value) {
                                      boardStatus = value;
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
                              CustomButton(
                                  textTheme: textTheme,
                                  label: lang.addNewBoard,
                                  onPressed: () => GoRouter.of(context).go('/boards/write')
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
                            child: FutureBuilderFactory.createFutureBuilder(
                                future: boardList,
                                onSuccess: (context, boardList){
                                  return dataTable(boardList);
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
                              }
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Theme dataTable(List<BoardSimple> boardList) {

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
          DataColumn(label: Text(lang.boardId)),
          DataColumn(label: Text(lang.title)),
          DataColumn(label: Text(lang.status)),
          DataColumn(label: Text(lang.createdAt)),
          DataColumn(label: Text(lang.updatedAt)),
          DataColumn(label: Text(lang.actions)),
        ],
        rows: boardList.map((data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              cells: [
                DataCell(Text(data.id.toString())),
                DataCell(Text(data.title)),
                DataCell(
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: selectStatusColor(data.status.value, 0.2),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      data.status.value,
                      style: textTheme.bodySmall?.copyWith(
                          color:selectStatusColor(data.status.value, 1)
                      ),
                    ),
                  ),
                ),
                DataCell(Text(DateUtil.convertDateTimeToString(data.createdAt))),
                DataCell(Text(DateUtil.convertDateTimeToString(data.updatedAt))),
                DataCell(
                  PopupMenuButton<ActionMenu>(
                    iconColor: theme.colorScheme.onTertiary,
                    color: theme.colorScheme.primaryContainer,
                    onSelected: (action) {
                      switch (action) {
                        case ActionMenu.VIEW:
                          GoRouter.of(context).go('/boards/info/${data.id}');
                          break;
                        case ActionMenu.DELETE:
                          delBoard(data.id);
                          break;
                        default:
                          break;
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<ActionMenu>(
                          value: ActionMenu.VIEW,
                          child: Text(lang.view),
                        ),
                        PopupMenuItem<ActionMenu>(
                          value: ActionMenu.DELETE,
                          child: Text(lang.delete),
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
                boardList = getBoardList();
              });
            }
          },
          onNextTap: () {
            if (currentPage < totalPage) {
              setState(() {
                currentPage++;
                boardList = getBoardList();
              });
            }
          },
        )
      ],
    );
  }

  Color selectStatusColor(String status, double alpha){
    if(status == BoardStatus.PUBLISH.value) {
      return AcnooAppColors.kSuccess.withValues(alpha: alpha);
    } else {
      return AcnooAppColors.kError.withValues(alpha: alpha);
    }

  }
}