// 🎯 Dart imports:
import 'dart:ui';

// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/compare_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../constants/user/user_search_date_type.dart';
import '../../constants/user/user_search_type.dart';
import '../../constants/user/user_status.dart';
import '../../core/helpers/field_styles/_dropdown_styles.dart';
import '../../core/service/user/user_manage_service.dart';
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
  UserSearchType searchType = UserSearchType.none;
  String searchValue = '';

  //Search_Date
  UserSearchDateType searchDateType = UserSearchDateType.none;
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  //유저 리스트 조회
  Future<List<UserProfile>> getUserList() async {
    try {
      return await userManageService.getUserList(getUserSearchParam());
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  //전체 페이지 갯수 조회
  Future<int> getTotalCount() async {
    try {
      int count = await userManageService.getUserListCount(getUserSearchParam());
      return (count / rowsPerPage).ceil();
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  UserSearchParam getUserSearchParam() {
    String? userSearchType = CompareUtil.compareStringValue(UserSearchType.none.value, searchType.value);
    String? userSearchDateType = CompareUtil.compareStringValue(UserSearchDateType.none.value, searchDateType.value);
    return UserSearchParam(
        searchType: userSearchType,
        searchValue: searchValue,
        searchDateType: userSearchDateType,
        startDate: DateUtil.convertStringToLocalDateTime(startDateController.text),
        endDate: DateUtil.convertStringToLocalDateTime(endDateController.text),
        page: currentPage,
        limit: rowsPerPage
    );
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _sizeInfo = SizeConfig.getSizeInfo(context);
    final theme = Theme.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final lang = l.S.of(context);

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
                    future: userList,
                    onSuccess: (context, userList) {
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
                                  child: searchTypeDropDown(textTheme),
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
                              child: dataTable(userList, theme, textTheme, lang),
                            ),
                          ),

                          //______________________________________________________________________footer__________________
                          Padding(
                            padding: _sizeInfo.padding,
                            child: FutureBuilderFactory.createFutureBuilder(
                                future: totalPage,
                                onSuccess: (context, totalPage) {
                                  return paginatedSection(totalPage, userList);
                                }),
                          ),
                        ],
                      );
                    }
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

  ///_______________________________________________________________DropDownList___________________________________
  Container searchTypeDropDown(TextTheme textTheme) {
    final dropdownStyle = AcnooDropdownStyle(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 100, minWidth: 100),
      child: DropdownButtonFormField2<UserSearchType>(
        hint: Text('검색 조건'),
        style: dropdownStyle.textStyle,
        iconStyleData: dropdownStyle.iconStyle,
        buttonStyleData: dropdownStyle.buttonStyle,
        dropdownStyleData: dropdownStyle.dropdownStyle,
        menuItemStyleData: dropdownStyle.menuItemStyle,
        isExpanded: true,
        value: searchType,
        items: UserSearchType.values.map((UserSearchType searchType) {
          return DropdownMenuItem<UserSearchType>(
            value: searchType,
            child: Text(
              searchType.value,
              style: textTheme.bodySmall,
            ),
          );
        }).toList(),
        onChanged: (value) {
          searchType = value ?? UserSearchType.none;
        },
      ),
    );
  }

  Theme dataTable(List<UserProfile> userList, ThemeData theme, TextTheme textTheme, l.S lang) {

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
          DataColumn(label: Text(lang.userName)),
          DataColumn(label: Text(lang.email)),
          DataColumn(label: Text(lang.type)),
          DataColumn(label: Text(lang.status)),
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
                DataCell(Text(data.loginType)),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: data.status == UserStatus.normal.value
                          ? AcnooAppColors.kSuccess.withOpacity(0.2)
                          : AcnooAppColors.kError.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      data.status,
                      style: textTheme.bodySmall?.copyWith(
                          color: data.status == UserStatus.normal.value
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

  Row paginatedSection(int totalPage, List<UserProfile> userList) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '${l.S.of(context).showing} ${(currentPage - 1) * rowsPerPage + 1} ${l.S.of(context).to} ${(currentPage - 1) * rowsPerPage + userList.length} ${l.S.of(context).OF} ${userList.length} ${l.S.of(context).entries}',
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
                this.userList = getUserList();
              });
            }
          },
          onNextTap: () {
            if (currentPage < totalPage) {
              setState(() {
                currentPage++;
                this.userList = getUserList();
              });
            }
          },
        )
      ],
    );
  }
}
