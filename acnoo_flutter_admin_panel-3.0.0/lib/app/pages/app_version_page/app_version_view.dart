// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/service/app_version/app_version_service.dart';
import 'package:acnoo_flutter_admin_panel/app/models/app_version/app_version.dart';
import 'package:acnoo_flutter_admin_panel/app/models/app_version/app_version_search_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/app_version/latest_app_version.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/app_version_page/app_version_add_popup.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/app_version_page/app_version_mod_popup.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

// 📦 Package imports:
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../core/constants/app_version/app_version_type.dart';
import '../../core/constants/app_version/publish_status.dart';
import '../../core/error/error_handler.dart';
import '../../core/helpers/helpers.dart';
import '../../core/theme/_app_colors.dart';
import '../../widgets/widgets.dart';

class AppVersionView extends StatefulWidget {
  const AppVersionView({super.key});

  @override
  State<AppVersionView> createState() => _AppVersionViewState();
}

class _AppVersionViewState extends State<AppVersionView>
    with SingleTickerProviderStateMixin {
  ///_____________________________________________________________________Variables_______________________________

  late List<AppVersion> versionList = [];
  LatestAppVersion latestAppVersion = LatestAppVersion();
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final AppVersionService appVersionService = AppVersionService();

  List<String> get _title => AppVersionType.values.map((e) => e.type).toList();
  AppVersionType appVersionType = AppVersionType.FORCE;
  int currentPage = 0;
  int rowsPerPage = 10;
  int totalPage = 0;
  String searchQuery = '';
  bool isLoading = true;

  //앱버전 리스트 조회
  Future<void> getAppVersionList(BuildContext context) async {
    List<AppVersion> list = [];
    try {
      setState(() => isLoading = true);

      AppVersionSearchParam searchParam = AppVersionSearchParam(
        appVersionType.type.toString(),
        "CREATED_AT",
        "DESC",
      );
      list = await appVersionService.getAppVersionList(searchParam);
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    setState(() {
      versionList = list;
      isLoading = false;
    });
  }

  //앱버전 리스트 갯수 조회
  Future<void> getAppVersionListCount(BuildContext context) async {
    int count = 0;
    try {
      setState(() => isLoading = true);

      AppVersionSearchParam searchParam = AppVersionSearchParam(
        appVersionType.type.toString(),
        "CREATED_AT",
        "DESC",
      );
      count = await appVersionService.getAppVersionListCount(searchParam);
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    setState(() {
      totalPage = (count / rowsPerPage).ceil();
      isLoading = false;
    });
  }

  //현재 출시 버전 조회
  Future<void> getLatestAppVersion(BuildContext context) async {
    setState(() => isLoading = true);
    try {
      latestAppVersion = await appVersionService.getLatestAppVersion();
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    setState(() => isLoading = false);
  }

  Future<void> delAppVersion(BuildContext context, int id) async {
    try{
      bool isSuccess = await appVersionService.delAppVersion(id);
      if(isSuccess){
        getAppVersionList(context);
        getAppVersionListCount(context);
        getLatestAppVersion(context);
      }
    }catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  @override
  void initState() {
    super.initState();
    getAppVersionList(context);
    getAppVersionListCount(context);
    getLatestAppVersion(context);
    _tabController = TabController(length: _title.length, vsync: this);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  ///_____________________________________________________________________Add_App_Version_____________________________
  void showAddDialog(BuildContext context) async {
    bool isAppVersionAdd = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AppVersionAddDialog();
      },
    );

    if (isAppVersionAdd) {
      getAppVersionList(context);
      getAppVersionListCount(context);
      getLatestAppVersion(context);
    }
  }

  ///_____________________________________________________________________Mod_App_Version_____________________________
  void showModDialog(BuildContext context, AppVersion version) async {
    bool isAppVersionMod = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppVersionModDialog(version: version);
      },
    );

    if (isAppVersionMod) {
      getAppVersionList(context);
      getAppVersionListCount(context);
      getLatestAppVersion(context);
    }
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
                                  appVersionType = AppVersionType.values[value];
                                  getAppVersionList(context);
                                  getAppVersionListCount(context);
                                  getLatestAppVersion(context);
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
                              isTablet ? Container() : const Spacer(),
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
        getAppVersionList(context);
      });
    }
  }

  ///_____________________________________go_previous_page____________
  void _goToPreviousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        getAppVersionList(context);
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
                      color: data.versionType == AppVersionType.FORCE.type
                          ? AcnooAppColors.kWarning.withOpacity(0.2)
                          : data.versionType == AppVersionType.INDUCE.type
                              ? AcnooAppColors.kInfo20Op
                              : data.versionType == AppVersionType.BUNDLE.type
                                  ? AcnooAppColors.kPrimary500.withOpacity(0.2)
                                  : AcnooAppColors.kSuccess.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      data.versionType,
                      maxLines: 1,
                      style: textTheme.bodySmall?.copyWith(
                        color: data.versionType == AppVersionType.FORCE.type
                            ? AcnooAppColors.kWarning
                            : data.versionType == AppVersionType.INDUCE.type
                                ? AcnooAppColors.kInfo
                                : data.versionType == AppVersionType.BUNDLE.type
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
                      color: data.publishStatus == PublishStatus.PUBLISH.status
                          ? AcnooAppColors.kSuccess.withOpacity(0.2)
                          : AcnooAppColors.kError.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      data.publishStatus,
                      style: textTheme.bodySmall?.copyWith(
                          color:
                              data.publishStatus == PublishStatus.PUBLISH.status
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
