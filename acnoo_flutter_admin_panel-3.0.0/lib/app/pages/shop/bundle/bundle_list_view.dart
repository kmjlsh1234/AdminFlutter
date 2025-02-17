
// 🎯 Dart imports:
import 'dart:ui';

import 'package:acnoo_flutter_admin_panel/app/constants/shop/bundle/bundle_search_type.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/shop/bundle/bundle_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../constants/shop/bundle/bundle_status.dart';
import '../../../constants/shop/product/product_status.dart';
import '../../../core/helpers/field_styles/_dropdown_styles.dart';
import '../../../core/theme/_app_colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/shop/bundle/bundle/bundle.dart';
import '../../../models/shop/bundle/bundle/bundle_search_param.dart';
import '../../../widgets/pagination_widgets/_pagination_widget.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';
import '../../common_widget/custom_button.dart';
import '../../common_widget/search_form_field.dart';
import 'component/mod_bundle_status_popup.dart';

class BundleListView extends StatefulWidget {
  const BundleListView({super.key});

  @override
  State<BundleListView> createState() => _BundleListViewState();
}

class _BundleListViewState extends State<BundleListView> {
  final ScrollController scrollController = ScrollController();
  final BundleService bundleService = BundleService();

  late Future<List<Bundle>> bundleList;

  //Paging
  int currentPage = 1;
  int rowsPerPage = 10;
  late Future<int> totalPage;

  //Search
  BundleStatus bundleStatus = BundleStatus.none;
  BundleSearchType bundleSearchType = BundleSearchType.none;
  String searchValue = "";

  //번들 리스트 조회
  Future<List<Bundle>> getBundleList() async {
    try {
      return await bundleService.getBundleList(getBundleSearchParam());
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  //번들 리스트 갯수 조회
  Future<int> getTotalCount() async {
    try {
      int count = await bundleService.getBundleListCount(getBundleSearchParam());
      int totalPage = (count / rowsPerPage).ceil();
      return totalPage;
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  //번들 삭제
  Future<void> delBundle(int bundleId) async {
    try{
      await bundleService.delBundle(bundleId);
      loadAllData();
    } catch(e){
      ErrorHandler.handleError(e, context);
    }
  }

  void loadAllData(){
    setState(() {
      bundleList = getBundleList();
      totalPage = getTotalCount();
    });
  }

  BundleSearchParam getBundleSearchParam() {
    String? status = bundleStatus == BundleStatus.none ? null : bundleStatus.value;
    String? searchType = bundleSearchType == BundleSearchType.none ? null : bundleSearchType.value;
    return BundleSearchParam(
        searchStatus: status,
        searchType: searchType,
        searchValue: searchValue,
        page: currentPage,
        limit: rowsPerPage
    );
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
    final TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
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
                    future: bundleList,
                    onSuccess: (context, bundleList){
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
                                CustomButton(
                                    textTheme: textTheme,
                                    label: lang.addNewBundle,
                                    onPressed: () =>GoRouter.of(context).go('/shops/bundles/add')
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
                                child: dataTable(bundleList, theme, textTheme, lang),
                            ),
                          ),

                          //______________________________________________________________________footer__________________
                          FutureBuilderFactory.createFutureBuilder(
                              future: totalPage,
                              onSuccess: (context, totalPage){
                                return Padding(
                                  padding: _sizeInfo.padding,
                                  child:
                                  paginatedSection(totalPage, bundleList),
                                );
                              }
                          )
                        ],
                      );
                    });
              },
            ),
          ),
        ),
      ),
    );
  }

  //번들 상태 변경 팝업
  void showModStatusFormDialog(BuildContext context, Bundle bundle) async {
    bool? isSuccess = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: ModBundleStatusDialog(bundle: bundle));
      },
    );

    if (isSuccess != null && isSuccess) {
      loadAllData();
    }
  }


  Row paginatedSection(int totalPage, List<Bundle> bundleList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '${l.S.of(context).showing} ${(currentPage - 1) * rowsPerPage + 1} ${l.S.of(context).to} ${(currentPage - 1) * rowsPerPage + bundleList.length} ${l.S.of(context).OF} ${bundleList.length} ${l.S.of(context).entries}',
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
                this.bundleList = getBundleList();
              });
            }
          },
          onNextTap: () {
            if (currentPage < totalPage) {
              setState(() {
                currentPage++;
                this.bundleList = getBundleList();
              });
            }
          },
        )
      ],
    );
  }

  ///_______________________________________________________________DropDownList___________________________________
  Container searchTypeDropDown(TextTheme textTheme) {
    final dropdownStyle = AcnooDropdownStyle(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 100, minWidth: 100),
      child: DropdownButtonFormField2<BundleStatus>(
        hint: Text('검색 조건'),
        style: dropdownStyle.textStyle,
        iconStyleData: dropdownStyle.iconStyle,
        buttonStyleData: dropdownStyle.buttonStyle,
        dropdownStyleData: dropdownStyle.dropdownStyle,
        menuItemStyleData: dropdownStyle.menuItemStyle,
        isExpanded: true,
        value: bundleStatus,
        items: BundleStatus.values.map((BundleStatus status) {
          return DropdownMenuItem<BundleStatus>(
            value: status,
            child: Text(
              status.value,
              style: textTheme.bodySmall,
            ),
          );
        }).toList(),
        onChanged: (value) {
          bundleStatus = value!;
        },
      ),
    );
  }

  Theme dataTable(List<Bundle> adminList,ThemeData theme, TextTheme textTheme,l.S lang) {
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
          DataColumn(label: Text(lang.name)),
          DataColumn(label: Text(lang.sku)),
          DataColumn(label: Text(lang.status)),
          DataColumn(label: Text(lang.createdAt)),
          DataColumn(label: Text(lang.updatedAt)),
          DataColumn(label: Text(lang.actions)),
        ],
        rows: adminList.map(
          (data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              cells: [
                DataCell(Text(data.id.toString())),
                DataCell(Text(data.name)),
                DataCell(Text(data.sku)),
                DataCell(
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: data.status == ProductStatus.onSale.value
                          ? AcnooAppColors.kSuccess.withOpacity(0.2)
                          : AcnooAppColors.kError.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      data.status,
                      style: textTheme.bodySmall?.copyWith(
                          color: data.status == ProductStatus.onSale.value
                              ? AcnooAppColors.kSuccess
                              : AcnooAppColors.kError),
                    ),
                  ),
                ),
                DataCell(Text(DateUtil.convertDateTimeToString(data.createdAt))),
                DataCell(Text(DateUtil.convertDateTimeToString(data.updatedAt))),
                DataCell(
                  PopupMenuButton<String>(
                    iconColor: theme.colorScheme.onTertiary,
                    color: theme.colorScheme.primaryContainer,
                    onSelected: (action) {
                      switch (action) {
                        case 'Edit Status':
                          showModStatusFormDialog(context, data);
                          break;
                        case 'View':
                          GoRouter.of(context).go('/shops/bundles/info/${data.id}');
                          break;
                        case 'Delete':
                          delBundle(data.id);
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
}
