// 🎯 Dart imports:
import 'dart:ui';

// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/common_widget/generic_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../constants/user/login_type.dart';
import '../../constants/user/user_search_date_type.dart';
import '../../constants/user/user_search_type.dart';
import '../../constants/user/user_status.dart';
import '../../core/service/user/user_manage_service.dart';
import '../../core/static/_static_values.dart';
import '../../core/theme/_app_colors.dart';
import '../../core/utils/size_config.dart';
import '../../models/user/user_profile.dart';
import '../../models/user/user_search_param.dart';
import '../../widgets/pagination_widgets/_pagination_widget.dart';
import '../../widgets/shadow_container/_shadow_container.dart';
import '../common_widget/search_form_field.dart';
import 'component/popup/mod_user_status_popup.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  final ScrollController scrollController = ScrollController();

  //Service
  final UserManageService userManageService = UserManageService();

  //Future Model
  late Future<List<UserProfile>> userList;

  //Paging
  int currentPage = 1;
  int rowsPerPage = 10;
  late Future<int> totalPage;

  //Search
  UserStatus searchStatus = UserStatus.NORMAL;
  LoginType loginType = LoginType.EMAIL;

  UserSearchType searchType = UserSearchType.EMAIL;
  String? searchValue;

  //Search_Date
  UserSearchDateType searchDateType = UserSearchDateType.CREATED_AT;
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //유저 리스트 조회
  Future<List<UserProfile>> getUserList() async {
    try {
      return await userManageService.getUserList(getUserSearchParam());
    } catch (e) {
      ErrorHandler.handleError(e, context);
      return [];
    }
  }

  //전체 페이지 갯수 조회
  Future<int> getTotalCount() async {
    try {
      int count =
          await userManageService.getUserListCount(getUserSearchParam());
      return (count / rowsPerPage).ceil();
    } catch (e) {
      ErrorHandler.handleError(e, context);
      return 0;
    }
  }

  UserSearchParam getUserSearchParam() {
    String? startDate = startDateController.text.isNotEmpty
        ? DateUtil.convertToLocalDateTime(startDateController.text)
        : null;
    String? endDate = endDateController.text.isNotEmpty
        ? DateUtil.convertToLocalDateTime(endDateController.text)
        : null;

    return UserSearchParam(
        loginType: loginType,
        searchStatus: searchStatus,
        searchType: searchType,
        searchValue: searchValue,
        searchDateType: searchDateType,
        startDate: startDate,
        endDate: endDate,
        page: currentPage,
        limit: rowsPerPage);
  }

  void loadAllData() {
    setState(() {
      userList = getUserList();
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
    scrollController.dispose();
    startDateController.dispose();
    endDateController.dispose();
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
                            child: GenericDropDown<UserStatus>(
                                labelText: lang.userStatus,
                                searchType: searchStatus,
                                searchList: UserStatus.values,
                                callBack: (UserStatus value) {
                                  searchStatus = value;
                                }
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            flex: 1,
                            child: GenericDropDown<LoginType>(
                                labelText: lang.loginType,
                                searchType: loginType,
                                searchList: LoginType.values,
                                callBack: (LoginType value) {
                                  loginType = value;
                                }
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            flex: 1,
                            child: GenericDropDown<UserSearchType>(
                                labelText: lang.userSearchType,
                                searchType: searchType,
                                searchList: UserSearchType.values,
                                callBack: (UserSearchType value) {
                                  searchType = value;
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
                          Spacer(flex: 3),

                          // SEARCH DATE TYPE
                          Expanded(
                            flex: 1,
                            child: GenericDropDown<UserSearchDateType>(
                                labelText: lang.userDateSearchType,
                                searchType: searchDateType,
                                searchList: UserSearchDateType.values,
                                callBack: (UserSearchDateType value) {
                                  searchDateType = value;
                                }
                            ),
                          ),

                          const SizedBox(width: 8.0),

                          // START DATE
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: startDateController,
                                    readOnly: true,
                                    selectionControls:
                                        EmptyTextSelectionControls(),
                                    decoration: InputDecoration(
                                      labelText: lang.startDate,
                                      labelStyle: textTheme.bodySmall?.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      hintText: lang.search,
                                      suffixIcon: const Icon(
                                          IconlyLight.calendar,
                                          size: 20), // 달력 아이콘
                                    ),
                                    onTap: () async {
                                      final result = await showDatePicker(
                                        context: context,
                                        firstDate: AppDateConfig.appFirstDate,
                                        lastDate: AppDateConfig.appLastDate,
                                        initialDate: DateTime.now(),
                                        builder: (context, child) => Theme(
                                          data: theme.copyWith(
                                            datePickerTheme:
                                                DatePickerThemeData(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        ),
                                      );
                                      if (result != null) {
                                        startDateController.text =
                                            DateFormat(DateUtil.dateTimeFormat)
                                                .format(result);
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
                                    selectionControls:
                                        EmptyTextSelectionControls(),
                                    decoration: InputDecoration(
                                      labelText: lang.endDate,
                                      labelStyle: textTheme.bodySmall?.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      hintText: lang.search,
                                      suffixIcon: const Icon(
                                          IconlyLight.calendar,
                                          size: 20), // 달력 아이콘
                                    ),
                                    onTap: () async {
                                      final result = await showDatePicker(
                                        context: context,
                                        firstDate: AppDateConfig.appFirstDate,
                                        lastDate: AppDateConfig.appLastDate,
                                        initialDate: DateTime.now(),
                                        builder: (context, child) => Theme(
                                          data: theme.copyWith(
                                            datePickerTheme:
                                                DatePickerThemeData(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        ),
                                      );
                                      if (result != null) {
                                        endDateController.text =
                                            DateFormat(DateUtil.dateTimeFormat)
                                                .format(result);
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
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                          ),
                          child: FutureBuilderFactory.createFutureBuilder(
                              future: userList,
                              onSuccess: (context, userList) {
                                return dataTable(
                                    userList, theme, textTheme, lang);
                              })
                      ),
                    ),

                    //______________________________________________________________________footer__________________
                    Padding(
                      padding: _sizeInfo.padding,
                      child: FutureBuilderFactory.createFutureBuilder(
                          future: totalPage,
                          onSuccess: (context, totalPage) {
                            return paginatedSection(totalPage);
                          }),
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

  void showFormDialog(BuildContext context, UserProfile userProfile) async {
    bool? isSuccess = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: ModUserStatusDialog(userProfile: userProfile));
      },
    );

    if (isSuccess != null && isSuccess) {
      loadAllData();
    }
  }

  Theme dataTable(List<UserProfile> userList, ThemeData theme,
      TextTheme textTheme, l.S lang) {
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
          DataColumn(label: Text(lang.userId)),
          DataColumn(label: Text(lang.nickName)),
          DataColumn(label: Text(lang.email)),
          DataColumn(label: Text(lang.loginType)),
          DataColumn(label: Text(lang.userStatus)),
          DataColumn(label: Text(lang.actions)),
        ],
        rows: userList.map(
          (data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              cells: [
                DataCell(Text(data.userId.toString())),
                DataCell(Text(data.nickname)),
                DataCell(Text(data.email)),
                DataCell(Text(data.loginType.value)),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: data.status == UserStatus.NORMAL
                          ? AcnooAppColors.kSuccess.withValues(alpha: 0.2)
                          : AcnooAppColors.kError.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      data.status.value,
                      style: textTheme.bodySmall?.copyWith(
                          color: data.status == UserStatus.NORMAL
                              ? AcnooAppColors.kSuccess
                              : AcnooAppColors.kError),
                    ),
                  ),
                ),
                DataCell(
                  PopupMenuButton<String>(
                    iconColor: theme.colorScheme.onTertiary,
                    color: theme.colorScheme.primaryContainer,
                    onSelected: (action) {
                      switch (action) {
                        case 'Edit Status':
                          showFormDialog(context, data);
                          break;
                        case 'View':
                          GoRouter.of(context)
                              .go('/users/profile/${data.userId}');
                          break;
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'Edit Status',
                          child: Text(
                            lang.editStatus,
                            //'Edit',
                            style: textTheme.bodyMedium,
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'View',
                          child: Text(lang.view,
                              // 'View',
                              style: textTheme.bodyMedium),
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
                userList = getUserList();
              });
            }
          },
          onNextTap: () {
            if (currentPage < totalPage) {
              setState(() {
                currentPage++;
                userList = getUserList();
              });
            }
          },
        )
      ],
    );
  }
}
