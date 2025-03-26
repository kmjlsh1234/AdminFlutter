// 🎯 Dart imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/admin/admin_manage_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/admin_manage_page/component/admin_table.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../constants/admin/admin_search_type.dart';
import '../../core/utils/popup_util.dart';
import '../../core/utils/size_config.dart';
import '../../models/admin/admin.dart';
import '../../models/admin/admin_search_param.dart';
import '../../widgets/pagination_widgets/_pagination_widget.dart';
import '../../widgets/shadow_container/_shadow_container.dart';
import '../common_widget/custom_button.dart';
import '../common_widget/generic_drop_down.dart';
import '../common_widget/search_form_field.dart';
import 'component/popup/add_admin_popup.dart';
import 'component/popup/mod_admin_status_popup.dart';

class AdminsListView extends StatefulWidget {
  const AdminsListView({super.key});

  @override
  State<AdminsListView> createState() => _AdminsListViewState();
}

class _AdminsListViewState extends State<AdminsListView> {
  final AdminManageService adminManageService = AdminManageService();
  late Future<List<Admin>> adminList;

  //Paging
  int currentPage = 1;
  int rowsPerPage = 10;
  late Future<int> totalPage;

  //Search
  AdminSearchType searchType = AdminSearchType.NAME;
  String? searchValue;

  //관리자 리스트 조회
  Future<List<Admin>> getAdminList() async {
    try {
      return await adminManageService.getAdminList(getAdminSearchParam());
    } catch (e) {
      ErrorHandler.handleError(e, context);
      return [];
    }
  }

  //관리자 리스트 갯수 조회
  Future<int> getTotalCount() async {
    try {
      int count = await adminManageService.getAdminListCount(getAdminSearchParam());
      return (count / rowsPerPage).ceil();
    } catch (e) {
      ErrorHandler.handleError(e, context);
      return 0;
    }
  }

  AdminSearchParam getAdminSearchParam() {
    return AdminSearchParam(
        roleId: null,
        searchType: searchType,
        searchValue: searchValue,
        page: currentPage,
        limit: rowsPerPage
    );
  }

  void loadAllData() {
    setState(() {
      adminList = getAdminList();
      totalPage = getTotalCount();
    });
  }

  @override
  void initState() {
    super.initState();
    loadAllData();
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final sizeInfo = SizeConfig.getSizeInfo(context);

    return Scaffold(
      body: Padding(
        padding: sizeInfo.padding,
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
                      padding: sizeInfo.padding,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: GenericDropDown<AdminSearchType>(
                                labelText: lang.userSearchType,
                                searchType: searchType,
                                searchList: AdminSearchType.values,
                                callBack: (AdminSearchType value) {
                                  searchType = value;
                                }
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            flex: 2,
                            child: SearchFormField(
                                textTheme: textTheme,
                                lang: lang,
                                onPressed: (searchValue) {
                                  this.searchValue = searchValue;
                                  loadAllData();
                                }),
                          ),
                          Spacer(flex: 4),
                          CustomButton(
                              textTheme: textTheme,
                              label: lang.addNewAdmin,
                              onPressed: () => PopupUtil.showReturnPopupDialog(
                                  context: context,
                                  dialog: AddAdminDialog(),
                                  callBack: loadAllData
                              )
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
                            future: adminList,
                            onSuccess: (context, adminList) {
                              return AdminTable(
                                  adminList: adminList,
                                  lang: lang,
                                  theme: theme,
                                  textTheme: textTheme,
                                  parentContext: context,
                                  editAction: (admin) => PopupUtil.showReturnPopupDialog(
                                      context: context,
                                      dialog: ModAdminStatusDialog(admin: admin),
                                      callBack: loadAllData
                                  )
                              );
                            })
                      ),
                    ),

                    //______________________________________________________________________footer__________________

                    Padding(
                      padding: sizeInfo.padding,
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
                adminList = getAdminList();
              });
            }
          },
          onNextTap: () {
            if (currentPage < totalPage) {
              setState(() {
                currentPage++;
                adminList = getAdminList();
              });
            }
          },
        )
      ],
    );
  }
}
