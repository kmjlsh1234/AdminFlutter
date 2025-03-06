// 🎯 Dart imports:
import 'dart:ui';

import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/date_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/future_builder_factory.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../constants/shop/product/product_status.dart';
import '../../../core/service/shop/product/product_service.dart';
import '../../../core/theme/_app_colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/shop/product/product/product.dart';
import '../../../models/shop/product/product/product_search_param.dart';
import '../../../widgets/pagination_widgets/_pagination_widget.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';
import '../../common_widget/custom_button.dart';
import '../../common_widget/generic_drop_down.dart';
import '../../common_widget/search_form_field.dart';
import 'component/mod_product_status_popup.dart';

class ProductsListView extends StatefulWidget {
  const ProductsListView({super.key});

  @override
  State<ProductsListView> createState() => _ProductsListViewState();
}

class _ProductsListViewState extends State<ProductsListView> {
  final ProductService productService = ProductService();

  late Future<List<Product>> productList;

  //Paging
  int currentPage = 1;
  int rowsPerPage = 10;
  late Future<int> totalPage;

  //Search
  ProductStatus productStatus = ProductStatus.NONE;
  String? searchValue;

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //상품 리스트 조회
  Future<List<Product>> getProductList() async {
    try {
      return await productService.getProductList(getProductSearchParam());
    } catch (e) {
      ErrorHandler.handleError(e, context);
      return [];
    }
  }

  //상품 리스트 갯수 조회
  Future<int> getTotalCount() async {
    try {
      int count = await productService.getProductListCount(getProductSearchParam());
      return (count / rowsPerPage).ceil();
    } catch (e) {
      ErrorHandler.handleError(e, context);
      return 0;
    }
  }

  //상품 삭제
  Future<void> delProduct(int productId) async {
    try{
      await productService.delProduct(productId);
      loadAllData();
    } catch(e){
      ErrorHandler.handleError(e, context);
    }
  }

  void loadAllData(){
    setState(() {
      productList = getProductList();
      totalPage = getTotalCount();
    });
  }

  ProductSearchParam getProductSearchParam() {
    return ProductSearchParam(
        searchStatus: productStatus == ProductStatus.NONE ? null : productStatus,
        searchValue: searchValue,
        page:  currentPage,
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    lang = l.S.of(context);
    theme = Theme.of(context);
    TextTheme textTheme = Theme.of(context).textTheme;
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
                return FutureBuilderFactory.createFutureBuilder(
                    future: productList,
                    onSuccess: (context, productList){
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
                                  child: GenericDropDown<ProductStatus>(
                                      labelText: lang.status,
                                      searchType: productStatus,
                                      searchList: ProductStatus.values,
                                      callBack: (ProductStatus value) {
                                        productStatus = value;
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
                                    label: lang.addNewProduct,
                                    onPressed: () =>GoRouter.of(context).go('/shops/products/add')
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
                              child: dataTable(productList, theme, textTheme, lang),
                            ),
                          ),

                          //______________________________________________________________________footer__________________
                          Padding(
                            padding: _sizeInfo.padding,
                            child: FutureBuilderFactory.createFutureBuilder(
                                future: totalPage,
                                onSuccess: (context, totalPage) {
                                  return paginatedSection(totalPage, productList);
                                }
                            ),
                          ),
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

  //Product 상태 변경 팝업
  void showModStatusFormDialog(BuildContext context, Product product) async {
    bool? isSuccess = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: ModProductStatusDialog(product: product));
      },
    );

    if (isSuccess != null && isSuccess) {
      loadAllData();
    }
  }

  Theme dataTable(List<Product> productList, ThemeData theme, TextTheme textTheme, l.S lang) {
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
          DataColumn(label: Text(lang.productId)),
          DataColumn(label: Text(lang.name)),
          DataColumn(label: Text(lang.status)),
          DataColumn(label: Text(lang.createdAt)),
          DataColumn(label: Text(lang.updatedAt)),
          DataColumn(label: Text(lang.actions)),
        ],
        rows: productList.map(
          (data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              cells: [
                DataCell(Text(data.id.toString())),
                DataCell(Text(data.name)),
                DataCell(
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: data.status == ProductStatus.ON_SALE
                          ? AcnooAppColors.kSuccess.withValues(alpha: 0.2)
                          : AcnooAppColors.kError.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      data.status.value,
                      style: textTheme.bodySmall?.copyWith(
                          color: data.status == ProductStatus.ON_SALE
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
                          GoRouter.of(context).go('/shops/products/info/${data.id}');
                          break;
                        case 'Delete':
                          delProduct(data.id);
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

  Row paginatedSection(int totalPage, List<Product> productList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '${l.S.of(context).showing} ${(currentPage - 1) * rowsPerPage + 1} ${l.S.of(context).to} ${(currentPage - 1) * rowsPerPage + productList.length} ${l.S.of(context).OF} ${productList.length} ${l.S.of(context).entries}',
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
                this.productList = getProductList();
              });
            }
          },
          onNextTap: () {
            if (currentPage < totalPage) {
              setState(() {
                currentPage++;
                this.productList = getProductList();
              });
            }
          },
        )
      ],
    );
  }
}
