// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/service/app_version/app_version_redis_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/app_version/app_version_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:acnoo_flutter_admin_panel/app/models/app_version/app_version.dart';
import 'package:acnoo_flutter_admin_panel/app/models/app_version/app_version_search_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/app_version/latest_app_version.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/app_version_page/widget/add_app_version_popup.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/app_version_page/widget/mod_app_version_popup.dart';
// 📦 Package imports:
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../constants/app_version/app_version_type.dart';
import '../../constants/app_version/publish_status.dart';
import '../../core/error/error_handler.dart';
import '../../core/theme/_app_colors.dart';
import '../../core/utils/alert_util.dart';
import '../../widgets/widgets.dart';
import '../common_widget/custom_button.dart';

class AppVersionListView extends StatefulWidget {
  const AppVersionListView({super.key});

  @override
  State<AppVersionListView> createState() => _AppVersionListViewState();
}

class _AppVersionListViewState extends State<AppVersionListView> with SingleTickerProviderStateMixin {

  //UI Controller
  final ScrollController scrollController = ScrollController();
  late TabController tabController;

  //Service
  final AppVersionService appVersionService = AppVersionService();
  final AppVersionRedisService appVersionRedisService = AppVersionRedisService();

  //Future Model
  late Future<List<AppVersion>> versionList;
  late Future<LatestAppVersion> latestAppVersion;

  //SearchType
  AppVersionType appVersionType = AppVersionType.force;

  //Paging
  int currentPage = 1;
  int rowsPerPage = 10;
  late Future<int> totalPage;

  //앱버전 리스트 조회
  Future<List<AppVersion>> getAppVersionList() async {
    try {
      AppVersionSearchParam appVersionSearchParam = AppVersionSearchParam(versionType: appVersionType.value);
      return await appVersionService.getAppVersionList(appVersionSearchParam);
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  //앱버전 리스트 갯수 조회
  Future<int> getTotalCount() async {
    try {
      AppVersionSearchParam appVersionSearchParam = AppVersionSearchParam(versionType: appVersionType.value);
      int count = await appVersionService.getAppVersionListCount(appVersionSearchParam);
      return (count / rowsPerPage).ceil();
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
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
      bool isSuccess = await appVersionService.delAppVersion(id);
      if (isSuccess) {
        loadAllData();
      }
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  Future<void> delAppVersionCache() async {
    try{
      bool isSuccess = await appVersionRedisService.delAppVersionCache();
      //AlertUtil.popupSuccessDialog(context, '앱 버전 캐시 삭제 성공');
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
    scrollController.dispose();
    tabController.dispose();
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

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return FutureBuilderFactory.createFutureBuilder(
              future: versionList,
              onSuccess: (context, versionList) {
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
                                      return publishAppVersionInfo(latestAppVersion);
                                    }
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
                                child: dataTable(versionList, theme, textTheme, lang),
                              ),
                            ),
                          ),

                          //______________________________________________________________________footer__________________
                          Padding(
                            padding: EdgeInsets.all(_padding),
                            child: FutureBuilderFactory.createFutureBuilder(
                                future: totalPage,
                                onSuccess: (context, totalPage) {
                                  return paginatedSection(totalPage, versionList);
                                }
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
          );
        },
      ),
    );
  }

  void showAddDialog(BuildContext context) async {
    bool success = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddAppVersionDialog();
      },
    );

    if (success) {
      loadAllData();
    }
  }

  void showModDialog(BuildContext context, AppVersion version) async {
    bool isAppVersionMod = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ModAppVersionDialog(version: version);
      },
    );

    if (isAppVersionMod) {
      loadAllData();
    }
  }

  Widget publishAppVersionInfo(LatestAppVersion latestAppVersion) {

    return Row(
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
                DataCell(Text(data.id.toString(), maxLines: 1,)),
                DataCell(Text(data.version, maxLines: 1,)),
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
                DataCell(Text(DateUtil.convertDateTimeToString(data.publishAt), maxLines: 1,)),
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
                DataCell(Text(DateUtil.convertDateTimeToString(data.createdAt), maxLines: 1)),
                DataCell(Text(DateUtil.convertDateTimeToString(data.updatedAt), maxLines: 1)),
                DataCell(
                  PopupMenuButton<int>(
                    iconColor: theme.colorScheme.onTertiary,
                    itemBuilder: (context) => {
                      // "View": FeatherIcons.eye,
                      // "Edit": FeatherIcons.edit,
                      // "Delete": FeatherIcons.trash2,

                      //lang.view: FeatherIcons.eye,
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
                        /*'Edit'*/ 0 => showModDialog(context, data),
                        /*'Delete'*/ 1 => delAppVersion(data.id),
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

  Row paginatedSection(int totalPage, List<AppVersion> versionList) {
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
          onPreviousTap: (){
            if (currentPage > 1) {
              setState(() {
                currentPage--;
                this.versionList = getAppVersionList();
              });
            }
          },
          onNextTap: (){
            if (currentPage < totalPage) {
              setState(() {
                currentPage++;
                this.versionList = getAppVersionList();
              });
            }
          },
        )
      ],
    );
  }
}
