// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/app_version/app_version_service.dart';
import 'package:acnoo_flutter_admin_panel/app/models/app_version/app_version.dart';
import 'package:acnoo_flutter_admin_panel/app/models/app_version/app_version_search_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/app_version/latest_app_version.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/app_version_page/app_version_add_popup.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/app_version_page/app_version_mod_popup.dart';
// 📦 Package imports:
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../constants/app_version/app_version_type.dart';
import '../../constants/app_version/publish_status.dart';
import '../../core/error/error_code.dart';
import '../../core/error/error_handler.dart';
import '../../core/theme/_app_colors.dart';
import '../../widgets/widgets.dart';

class AppVersionListView extends StatefulWidget {
  const AppVersionListView({super.key});

  @override
  State<AppVersionListView> createState() => _AppVersionListViewState();
}

class _AppVersionListViewState extends State<AppVersionListView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final ScrollController scrollController = ScrollController();
  final AppVersionService appVersionService = AppVersionService();

  late List<AppVersion> versionList;
  late LatestAppVersion latestAppVersion;
  bool isLoading = true;

  List<String> get versionTypes => AppVersionType.values.map((e) => e.value).toList();
  AppVersionType appVersionType = AppVersionType.force;

  //Paging
  int currentPage = 1;
  int rowsPerPage = 10;
  int totalPage = 0;

  //앱버전 리스트 조회
  Future<List<AppVersion>> getAppVersionList() async {
    List<AppVersion> list = [];
    try {
      AppVersionSearchParam searchParam = getAppVersionSearchParam();
      list = await appVersionService.getAppVersionList(searchParam);


    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    return list;
  }

  //앱버전 리스트 갯수 조회
  Future<int> getAppVersionListCount() async {
    int count = 0;
    try {
      AppVersionSearchParam searchParam = getAppVersionSearchParam();
      count = await appVersionService.getAppVersionListCount(searchParam);
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    int totalPage = (count / rowsPerPage).ceil();
    return totalPage;
  }

  //LIST + COUNT
  Future<void> searchListWithCount() async {
    setState(() => isLoading = true);
    List<dynamic> results =
        await Future.wait([getAppVersionList(), getAppVersionListCount()]);
    setState(() {
      versionList = results[0];
      totalPage = results[1];
      isLoading = false;
    });
  }

  //LIST
  Future<void> searchList() async {
    setState(() => isLoading = true);
    List<AppVersion> list = await getAppVersionList();
    setState(() {
      versionList = list;
      isLoading = false;
    });
  }

  //현재 출시 버전 조회
  Future<void> getLatestAppVersion() async {
    setState(() => isLoading = true);
    try {
      latestAppVersion = await appVersionService.getLatestAppVersion();
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    setState(() => isLoading = false);
  }

  //버전 삭제
  Future<void> delAppVersion(BuildContext context, int id) async {
    try {
      bool isSuccess = await appVersionService.delAppVersion(id);
      if (isSuccess) {
        getLatestAppVersion();
        searchListWithCount();
      }
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  void goToNextPage() {
    if (currentPage < totalPage) {
      setState(() {
        currentPage++;
        searchList();
      });
    }
  }

  void goToPreviousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
        searchList();
      });
    }
  }

  AppVersionSearchParam getAppVersionSearchParam() {
    return AppVersionSearchParam(
        appVersionType.value.toString(), "CREATED_AT", "DESC");
  }

  @override
  void initState() {
    super.initState();
    getLatestAppVersion();
    searchListWithCount();
    tabController = TabController(length: versionTypes.length, vsync: this);
  }

  @override
  void dispose() {
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
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
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
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
                          controller: tabController,
                          indicatorColor: AcnooAppColors.kPrimary600,
                          indicatorWeight: 2.0,
                          dividerColor: Colors.transparent,
                          unselectedLabelColor: theme.colorScheme.onTertiary,
                          onTap: (value) => setState(() {
                            appVersionType = AppVersionType.values[value];
                            getLatestAppVersion();
                            searchListWithCount();
                          }),
                          tabs: versionTypes
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
                      Visibility(
                        visible: constraints.maxWidth > 576,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: _padding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 36,
                                child: addAppVersion(textTheme, context),
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
                        const Spacer(),
                        // Ensures proper alignment by pushing the next element to the end
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(width: 36),
                              Text(
                                'Force : ${latestAppVersion.forceUpdateVersion}',
                                textAlign: TextAlign.right,
                              ),
                              const SizedBox(width: 36),
                              Text(
                                'Induce : ${latestAppVersion.induceUpdateVersion}',
                                textAlign: TextAlign.right,
                              ),
                              const SizedBox(width: 36),
                              Text(
                                'Bundle : ${latestAppVersion.bundleUpdateVersion}',
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
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
                          padding: EdgeInsets.only(top: _padding),
                          child: dataTable(context),
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
  ElevatedButton addAppVersion(TextTheme textTheme, BuildContext context) {
    final lang = l.S.of(context);
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: () {
        setState(() {
          showAddDialog(context);
        });
      },
      label: Text(
        lang.addNewVersion,
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

  void showAddDialog(BuildContext context) async {
    bool success = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AppVersionAddDialog();
      },
    );

    if (success) {
      getLatestAppVersion();
      searchListWithCount();
    }
  }

  void showModDialog(BuildContext context, AppVersion version) async {
    bool isAppVersionMod = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppVersionModDialog(version: version);
      },
    );

    if (isAppVersionMod) {
      getLatestAppVersion();
      searchListWithCount();
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
            '${l.S.of(context).showing} ${(currentPage - 1) * rowsPerPage + 1} ${l.S.of(context).to} ${(currentPage - 1) * rowsPerPage + versionList.length} ${l.S.of(context).OF} ${versionList.length} ${l.S.of(context).entries}',
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

  Theme dataTable(BuildContext context) {
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
          DataColumn(label: Text(lang.appVersion)),
          DataColumn(label: Text(lang.type)),
          DataColumn(label: Text(lang.publishAt)),
          DataColumn(label: Text(lang.status)),
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
                    data.version,
                    maxLines: 1,
                  ),
                ),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: data.versionType == AppVersionType.force.value
                          ? AcnooAppColors.kWarning.withOpacity(0.2)
                          : data.versionType == AppVersionType.induce.value
                              ? AcnooAppColors.kInfo20Op
                              : data.versionType == AppVersionType.bundle.value
                                  ? AcnooAppColors.kPrimary500.withOpacity(0.2)
                                  : AcnooAppColors.kSuccess.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      data.versionType,
                      maxLines: 1,
                      style: textTheme.bodySmall?.copyWith(
                        color: data.versionType == AppVersionType.force.value
                            ? AcnooAppColors.kWarning
                            : data.versionType == AppVersionType.induce.value
                                ? AcnooAppColors.kInfo
                                : data.versionType ==
                                        AppVersionType.bundle.value
                                    ? AcnooAppColors.kPrimary500
                                    : AcnooAppColors.kSuccess,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    data.publishAt,
                    maxLines: 1,
                  ),
                ),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: data.publishStatus == PublishStatus.publish.value
                          ? AcnooAppColors.kSuccess.withOpacity(0.2)
                          : AcnooAppColors.kError.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      data.publishStatus,
                      style: textTheme.bodySmall?.copyWith(
                          color:
                              data.publishStatus == PublishStatus.publish.value
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
                        /*'View'*/ //0 => _showDetailsDialog(context, data),
                        /*'Edit'*/ 1 => showModDialog(context, data),
                        /*'Delete'*/ 2 => delAppVersion(context, data.id),
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
}
