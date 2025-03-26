// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/service/app_version/app_version_redis_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/app_version/app_version_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:acnoo_flutter_admin_panel/app/models/app_version/app_version.dart';
import 'package:acnoo_flutter_admin_panel/app/models/app_version/app_version_search_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/app_version/latest_app_version.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../constants/app_version/app_version_type.dart';
import '../../constants/app_version/publish_status.dart';
import '../../constants/common/action_menu.dart';
import '../../core/error/error_handler.dart';
import '../../core/theme/_app_colors.dart';
import '../../core/utils/alert_util.dart';
import '../../widgets/widgets.dart';
import '../common_widget/custom_button.dart';
import 'component/add_app_version_popup.dart';
import 'component/mod_app_version_popup.dart';

class AppVersionListView extends StatefulWidget {
  const AppVersionListView({super.key});

  @override
  State<AppVersionListView> createState() => _AppVersionListViewState();
}

class _AppVersionListViewState extends State<AppVersionListView> with SingleTickerProviderStateMixin {

  late TabController tabController;

  //Service
  final AppVersionService appVersionService = AppVersionService();
  final AppVersionRedisService appVersionRedisService = AppVersionRedisService();

  //Future Model
  late Future<List<AppVersion>> versionList;
  late Future<LatestAppVersion> latestAppVersion;

  //SearchType
  AppVersionType appVersionType = AppVersionType.FORCE;

  //Paging
  int currentPage = 1;
  int rowsPerPage = 10;
  late Future<int> totalPage;

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //앱버전 리스트 조회
  Future<List<AppVersion>> getAppVersionList() async {
    try {
      AppVersionSearchParam appVersionSearchParam = AppVersionSearchParam(versionType: appVersionType);
      return await appVersionService.getAppVersionList(appVersionSearchParam);
    } catch (e) {
      ErrorHandler.handleError(e, context);
      return [];
    }
  }

  //앱버전 리스트 갯수 조회
  Future<int> getTotalCount() async {
    try {
      AppVersionSearchParam appVersionSearchParam = AppVersionSearchParam(versionType: appVersionType);
      int count = await appVersionService.getAppVersionListCount(appVersionSearchParam);
      return (count / rowsPerPage).ceil();
    } catch (e) {
      ErrorHandler.handleError(e, context);
      return 0;
    }
  }

  //현재 출시 버전 조회
  Future<LatestAppVersion> getLatestAppVersion() async {
    try {
      return await appVersionService.getLatestAppVersion();
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  //버전 삭제
  Future<void> delAppVersion(int id) async {
    try {
      await appVersionService.delAppVersion(id);
      loadAllData();
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  Future<void> delAppVersionCache() async {
    try{
      await appVersionRedisService.delAppVersionCache();
      AlertUtil.successDialog(
          context: context,
          message: lang.successModBundle,
          buttonText: lang.confirm,
          onPressed: () {
            GoRouter.of(context).pop();
            loadAllData();
          }
      );
    } catch(e){
      ErrorHandler.handleError(e, context);
    }
  }

  void loadAllData(){
    setState(() {
      latestAppVersion = getLatestAppVersion();
      versionList = getAppVersionList();
      totalPage = getTotalCount();
    });
  }

  @override
  void initState() {
    super.initState();
    loadAllData();
    tabController = TabController(length: AppVersionType.values.length, vsync: this);
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
            padding: EdgeInsets.all(_padding),
            child: ShadowContainer(
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
                          onTap: (value) {
                            appVersionType = AppVersionType.values[value];
                            loadAllData();
                          },
                          tabs: AppVersionType.values.map(
                                (version) => Tab(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: _padding / 2,
                                ),
                                child: Text(version.value),
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
                                  child: CustomButton(
                                    textTheme: textTheme,
                                    label: lang.addNewVersion,
                                    onPressed: () => showAddDialog(context),
                                  )
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
                          child: FutureBuilderFactory.createFutureBuilder(
                              future: latestAppVersion,
                              onSuccess: (context, latestAppVersion) {
                                return publishAppVersionInfo(latestAppVersion, lang);
                              }
                          ),
                        ),
                      ],
                    ),

                    //______________________________________________________________________Data_table__________________
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: _padding),
                          child: FutureBuilderFactory.createFutureBuilder(
                              future: versionList,
                              onSuccess: (context, versionList){
                                return dataTable(versionList, theme, textTheme, lang);
                              }),
                        ),
                      ),
                    ),

                    //______________________________________________________________________footer__________________
                    Padding(
                      padding: EdgeInsets.all(_padding),
                      child: FutureBuilderFactory.createFutureBuilder(
                          future: totalPage,
                          onSuccess: (context, totalPage) {
                            return paginatedSection(totalPage);
                          }
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

  void showAddDialog(BuildContext context) async {
    bool? isSuccess = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddAppVersionDialog();
      },
    );

    if (isSuccess != null && isSuccess) {
      loadAllData();
    }
  }

  void showModDialog(AppVersion version) async {
    bool? isSuccess = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ModAppVersionDialog(version: version);
      },
    );

    if (isSuccess != null && isSuccess) {
      loadAllData();
    }
  }

  Widget publishAppVersionInfo(LatestAppVersion latestAppVersion, l.S lang) {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 36),
        Text(
          '${lang.force} : ${latestAppVersion.forceUpdateVersion??lang.empty}',
          textAlign: TextAlign.right,
        ),
        const SizedBox(width: 36),
        Text(
          '${lang.induce} : ${latestAppVersion.induceUpdateVersion??lang.empty}',
          textAlign: TextAlign.right,
        ),
        const SizedBox(width: 36),
        Text(
          '${lang.bundle} : ${latestAppVersion.bundleUpdateVersion??lang.empty}',
          textAlign: TextAlign.right,
        ),
        const SizedBox(width: 36),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            delAppVersionCache();
          },
        ),
      ],
    );
  }

  Theme dataTable(List<AppVersion> versionList, ThemeData theme, TextTheme textTheme, l.S lang) {

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
          DataColumn(label: Text(lang.versionId)),
          DataColumn(label: Text(lang.appVersion)),
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
                DataCell(Text(data.id.toString(), maxLines: 1,)),
                DataCell(Text(data.version, maxLines: 1,)),
                DataCell(Text(DateUtil.convertDateTimeToString(data.publishAt), maxLines: 1,)),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: selectStatusColor(data.publishStatus.value, 0.2),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      data.publishStatus.value,
                      style: textTheme.bodySmall?.copyWith(color: selectStatusColor(data.publishStatus.value, 1)),
                    ),
                  ),
                ),
                DataCell(Text(DateUtil.convertDateTimeToString(data.createdAt), maxLines: 1)),
                DataCell(Text(DateUtil.convertDateTimeToString(data.updatedAt), maxLines: 1)),
                DataCell(
                  PopupMenuButton<ActionMenu>(
                    iconColor: theme.colorScheme.onTertiary,
                    color: theme.colorScheme.primaryContainer,
                    onSelected: (action) {
                      switch (action) {
                        case ActionMenu.EDIT:
                          showModDialog(data);
                          break;
                        case ActionMenu.DELETE:
                          delAppVersion(data.id);
                          break;
                        default:
                          break;
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<ActionMenu>(
                          value: ActionMenu.EDIT,
                          child: Text(lang.edit),
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
          onPreviousTap: (){
            if (currentPage > 1) {
              setState(() {
                currentPage--;
                versionList = getAppVersionList();
              });
            }
          },
          onNextTap: (){
            if (currentPage < totalPage) {
              setState(() {
                currentPage++;
                versionList = getAppVersionList();
              });
            }
          },
        )
      ],
    );
  }

  Color selectStatusColor(String status, double alpha) {
    if(status == PublishStatus.PUBLISH.value){
      return AcnooAppColors.kSuccess.withValues(alpha: alpha);
    }
    else {
      return AcnooAppColors.kError.withValues(alpha: alpha);
    }
  }
}
