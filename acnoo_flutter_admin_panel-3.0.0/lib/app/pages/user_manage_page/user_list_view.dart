// 🎯 Dart imports:
import 'dart:ui';

// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/user_manage_page/widget/popup/user_mod_popup.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../constants/user/user_search_date_type.dart';
import '../../constants/user/user_search_type.dart';
import '../../core/helpers/field_styles/_dropdown_styles.dart';
import '../../core/service/user/user_manage_service.dart';
import '../../core/theme/_app_colors.dart';
import '../../core/utils/size_config.dart';
import '../../models/user/user_profile.dart';
import '../../models/user/user_search_param.dart';
import '../../widgets/pagination_widgets/_pagination_widget.dart';
import '../../widgets/shadow_container/_shadow_container.dart';
import '../common_widget/search_form_field.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  final ScrollController scrollController = ScrollController();
  final UserManageService userManageService = UserManageService();

  late List<UserProfile> userList;
  bool isLoading = true;

  //Paging
  int currentPage = 1;
  int rowsPerPage = 10;
  int totalPage = 0;

  //Search
  UserSearchType searchType = UserSearchType.none;
  String searchValue = '';

  //Search_Date
  UserSearchDateType searchDateType = UserSearchDateType.none;
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  //유저 리스트 조회
  Future<List<UserProfile>> getUserList() async {
    List<UserProfile> list = [];
    try {
      UserSearchParam userSearchParam = getUserSearchParam();
      list = await userManageService.getUserList(userSearchParam);
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    return list;
  }

  //유저 리스트 갯수 조회
  Future<int> getUserListCount() async {
    int count = 0;
    try {
      UserSearchParam userSearchParam = getUserSearchParam();
      count = await userManageService.getUserListCount(userSearchParam);
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
    int totalPage = (count / rowsPerPage).ceil();
    return totalPage;
  }

  //LIST + COUNT
  Future<void> searchListWithCount() async {
    setState(() => isLoading = true);
    List<dynamic> results = await Future.wait([getUserList(), getUserListCount()]);
    setState(() {
      userList = results[0];
      totalPage = results[1];
      isLoading = false;
    });
  }

  //LIST
  Future<void> searchList() async {
    setState(() => isLoading = true);
    List<UserProfile> list = await getUserList();
    setState(() {
      userList = list;
      isLoading = false;
    });
  }

  UserSearchParam getUserSearchParam(){
    return UserSearchParam(
        searchType == UserSearchType.none ? null : searchType.value,
        searchValue,
        searchDateType == UserSearchDateType.none ? null : searchDateType.value,
        startDateController.text,
        endDateController.text,
        currentPage,
        rowsPerPage
    );
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

  @override
  void initState() {
    super.initState();
    searchListWithCount();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _sizeInfo = SizeConfig.getSizeInfo(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final lang = l.S.of(context);

    if(isLoading){
      return Center(child: CircularProgressIndicator());
    }

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
                                  searchListWithCount();
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
                        child: userListDataTable(context),
                      ),
                    ),

                    //______________________________________________________________________footer__________________
                    Padding(
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

  ///_______________________________________________________________pagination_footer_______________________________
  Row paginatedSection(ThemeData theme, TextTheme textTheme) {
    //final lang = l.S.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '${l.S.of(context).showing} ${(currentPage -1) * rowsPerPage + 1} ${l.S.of(context).to} ${(currentPage -1) * rowsPerPage + userList.length} ${l.S.of(context).OF} ${userList.length} ${l.S.of(context).entries}',
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
          searchType = value??UserSearchType.none;
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
          DataColumn(label: Text(lang.userName)),
          DataColumn(label: Text(lang.email)),
          DataColumn(label: Text(lang.phone)),
          DataColumn(label: Text(lang.position)),
          DataColumn(label: Text(lang.status)),
          DataColumn(label: Text(lang.createdAt)),
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
                DataCell(Text(data.mobile)),
                DataCell(Text(data.userType.toString())),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: data.status == 'Active'
                          ? AcnooAppColors.kSuccess.withOpacity(0.2)
                          : AcnooAppColors.kError.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      data.status,
                      style: textTheme.bodySmall?.copyWith(
                          color: data.status == 'Active'
                              ? AcnooAppColors.kSuccess
                              : AcnooAppColors.kError),
                    ),
                  ),
                ),
                DataCell(Text(data.createdAt)),
                DataCell(
                  PopupMenuButton<String>(
                    iconColor: theme.colorScheme.onTertiary,
                    color: theme.colorScheme.primaryContainer,
                    onSelected: (action) {
                      switch (action) {
                        case 'Edit':
                          showFormDialog(context, data);
                          break;
                        case 'View':
                          GoRouter.of(context).go('/users/profile/${data.userId}');
                          break;
                        case 'Delete':
                          setState(() {});
                          break;
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'Edit',
                          child: Text(
                            lang.edit,
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
                        PopupMenuItem<String>(
                          value: 'Delete',
                          child: Text(lang.delete,
                              // 'Delete',
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

  void showFormDialog(BuildContext context, UserProfile userProfile) async {
    bool isUserStatusMod = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: UserModDialog(userProfile: userProfile));
      },
    );

    if (isUserStatusMod) {
      searchListWithCount();
    }
  }
}
