import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../../../generated/l10n.dart' as l;
import '../../../../core/static/static.dart';
import '../../../../widgets/widgets.dart';
import 'components/components.dart' as comp;

class StoreAnalyticsDashboard extends StatefulWidget {
  const StoreAnalyticsDashboard({super.key});

  @override
  State<StoreAnalyticsDashboard> createState() =>
      _StoreAnalyticsDashboardState();
}

class _StoreAnalyticsDashboardState extends State<StoreAnalyticsDashboard> {
  //---------------------Map Props---------------------//
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static const CameraPosition _rhHomeCenterAcnoo = CameraPosition(
    target: LatLng(23.7545212, 90.389183),
    zoom: 18.7654,
  );
  //---------------------Map Props---------------------//

  @override
  Widget build(BuildContext context) {
    final _lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _mqSize = MediaQuery.sizeOf(context);

    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      lg: 24,
    );
    return Scaffold(
      body: ScrollbarTheme(
        data: _theme.scrollbarTheme.copyWith(
          trackColor: WidgetStateProperty.all(Colors.transparent),
          thumbColor: WidgetStateProperty.all(Color(0xffD1D5DB)),
          radius: Radius.zero,
          mainAxisMargin: 0,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.all(_padding / 2.5),
          child: Column(
            children: [
              // Overview & Income Report Chart
              ResponsiveGridRow(
                children: [
                  ResponsiveGridCol(
                    md: 12,
                    lg: 6,
                    child: ShadowContainer(
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),
                      contentPadding: EdgeInsetsDirectional.all(_padding / 2.5),
                      showHeader: false,
                      child: ResponsiveGridRow(
                        children: List.generate(_overviewItem.length, (index) {
                          final _data = _overviewItem[index];
                          return ResponsiveGridCol(
                            lg: 6,
                            md: 6,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: comp.StoreOverviewWidget(
                                color: _data.color,
                                title: _data.title,
                                value: _data.value,
                                subAmount: _data.subAmount,
                                icon: _data.icon,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  ResponsiveGridCol(
                    md: 12,
                    lg: 6,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(height: 350),
                      child: ShadowContainer(
                        margin: EdgeInsetsDirectional.all(_padding / 2.5),
                        contentPadding:
                            EdgeInsetsDirectional.all(_padding / 2.5),
                        //headerText: 'Income Report',
                        headerText: _lang.incomeReport,
                        trailing: const FilterDropdownButton(),
                        child: const comp.StoreIncomeReport(),
                      ),
                    ),
                  ),
                ],
              ),

              // Top Selling Category, Items & Source
              ResponsiveGridRow(
                children: [
                  // Top Selling Category
                  ResponsiveGridCol(
                    lg: 4,
                    md: _mqSize.width < 768 ? 12 : 6,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(height: 455),
                      child: ShadowContainer(
                        margin: EdgeInsetsDirectional.all(_padding / 2.5),
                        contentPadding:
                            EdgeInsetsDirectional.all(_padding / 2.5),
                        trailing: Text.rich(
                          TextSpan(
                            //text: 'View All',
                            text: _lang.view,
                            mouseCursor: SystemMouseCursors.click,
                          ),
                          style: _theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: _theme.colorScheme.primary,
                          ),
                        ),
                        headerText: _lang.topSellingCategories,
                        child: comp.TopSellingCategoriesChat(),
                      ),
                    ),
                  ),

                  // Top Selling Items
                  ResponsiveGridCol(
                    lg: 4,
                    md: _mqSize.width < 768 ? 12 : 6,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(height: 455),
                      child: ShadowContainer(
                        margin: EdgeInsets.all(_padding / 2.5),
                        contentPadding: EdgeInsets.zero,
                        headerText: _lang.topSellingItems,
                        trailing: Text.rich(
                          TextSpan(
                            text: _lang.viewAll,
                            mouseCursor: SystemMouseCursors.click,
                          ),
                          style: _theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: _theme.colorScheme.primary,
                          ),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: _sellingItems.length,
                          itemBuilder: (_, index) {
                            final _item = _sellingItems[index];
                            return comp.StoreTopSellingItem(
                              title: _item.itemName,
                              trailing: _item.amount,
                              imagePath: _item.image,
                              subtitle: comp.buildReview(
                                context,
                                reviews: _item.rating,
                                rating: _item.ratingStar,
                              ),
                            );
                          },
                          separatorBuilder: (c, i) {
                            return const SizedBox(height: 16);
                          },
                        ),
                      ),
                    ),
                  ),

                  // Most Visited Source
                  ResponsiveGridCol(
                    lg: 4,
                    md: _mqSize.width < 1240 ? 12 : 6,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(height: 455),
                      child: ShadowContainer(
                        richHeaderText: TextSpan(
                          text: '${_lang.visitedBySource} ',
                          style: _theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(
                              text: '(${_lang.visitors})',
                              style: _theme.textTheme.titleLarge
                                  ?.copyWith(color: _theme.colorScheme.primary),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.all(_padding / 2.5),
                        contentPadding: EdgeInsets.zero,
                        showHeader: true,
                        trailing: const FilterDropdownButton(),
                        // headerText: 'Visits by Source (24k Visitors)',
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: _visitedItems.length,
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: 20,
                            // vertical: 12,
                          ),
                          itemBuilder: (_, index) {
                            final _item = _visitedItems[index];
                            return comp.VisitSourceWidget(
                              title: _item.title,
                              imagePath: _item.image,
                              subtitle: _item.subtitle,
                              amount: _item.amunt,
                              ratingPercent: _item.ratingPersent,
                            );
                          },
                          separatorBuilder: (_, __) {
                            return SizedBox.square(dimension: 8);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Most Visited Country & Author Sales & Refund
              ResponsiveGridRow(
                children: [
                  ResponsiveGridCol(
                    md: 12,
                    lg: 6,
                    child: ShadowContainer(
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),
                      contentPadding: EdgeInsetsDirectional.zero,
                      headerText: _lang.visitedByCountry,
                      trailing: FilterDropdownButton(),
                      child: ResponsiveGridRow(
                        children: [
                          ResponsiveGridCol(
                            md: 6,
                            lg: 6,
                            xs: 12,
                            child: SizedBox(
                              height: 360,
                              width: double.maxFinite,
                              child: GoogleMap(
                                mapType: MapType.none,
                                initialCameraPosition: _rhHomeCenterAcnoo,
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
                              ),
                            ),
                          ),
                          ResponsiveGridCol(
                            md: 6,
                            lg: 6,
                            xs: 12,
                            child: ConstrainedBox(
                              constraints: BoxConstraints.tightFor(height: 360),
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: _visitedCountryList.length,
                                itemBuilder: (_, index) {
                                  final _item = _visitedCountryList[index];
                                  return comp.VisitedCountryWidget(
                                    title: _item.title,
                                    imagePath: _item.image,
                                    subtitle: _item.subtitle,
                                    ratingPercent: _item.persentAmount,
                                  );
                                },
                                separatorBuilder: (c, i) {
                                  return const SizedBox(height: 16);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ResponsiveGridCol(
                    md: 12,
                    lg: 6,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(height: 460),
                      child: ShadowContainer(
                        margin: EdgeInsetsDirectional.all(_padding / 2.5),
                        contentPadding:
                            EdgeInsetsDirectional.all(_padding / 2.5),
                        headerText: _lang.authorSalesAndRefund,
                        trailing: FilterDropdownButton(),
                        child: comp.AuthorSaleRefundWidget(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<({Color color, String title, String value, String subAmount, String icon})>
    get _overviewItem {
  return [
    (
      color: Color(0xff9935FE),
      title: l.S.current.totalCustomers,
      value: '857',
      subAmount: '18',
      icon: AcnooSVGIcons.usersIcon,
    ),
    (
      color: Color(0xff0043FA),
      title: l.S.current.totalOrders,
      value: '5027',
      subAmount: '18',
      icon: AcnooSVGIcons.shopIcon,
    ),
    (
      color: Color(0xff00CCC4),
      title: l.S.current.totalSales,
      value: '\$7,000',
      subAmount: '\$10k',
      icon: AcnooSVGIcons.tagDollarIcon,
    ),
    (
      color: Color(0xffF44207),
      title: l.S.current.totalRefund,
      value: '\$3000.00',
      subAmount: '18',
      icon: AcnooSVGIcons.refundsIcon,
    ),
  ];
}

List<
    ({
      String itemName,
      String amount,
      String image,
      double ratingStar,
      int rating
    })> get _sellingItems {
  return [
    (
      image: "assets/images/static_images/product_images/product_image_12.png",
      amount: "\$72",
      itemName: "Protein Bar",
      rating: 24,
      ratingStar: 4.0,
    ),
    (
      image: "assets/images/static_images/product_images/product_image_13.png",
      amount: "\$72",
      itemName: "Palm Bliss",
      rating: 35,
      ratingStar: 5.0,
    ),
    (
      image: "assets/images/static_images/product_images/product_image_14.png",
      amount: "\$72",
      itemName: "DSLR camera",
      rating: 20,
      ratingStar: 3.0,
    ),
    (
      image: "assets/images/static_images/product_images/product_image_19.png",
      amount: "\$72",
      itemName: "Quaker Meal",
      rating: 30,
      ratingStar: 4.0,
    ),
    (
      image: "assets/images/static_images/product_images/product_image_16.png",
      amount: "\$72",
      itemName: "Samsung M32 - 64 GB",
      rating: 24,
      ratingStar: 4.0,
    ),
  ];
}

List<
    ({
      String title,
      String subtitle,
      SvgImageHolder image,
      double amunt,
      double ratingPersent
    })> get _visitedItems {
  return [
    (
      image: AcnooSVGIcons.facebookIcon,
      title: "Social Networks",
      subtitle: "All social site",
      ratingPersent: 20.5,
      amunt: 1200,
    ),
    (
      image: AcnooSVGIcons.telegramIcon,
      title: "Direct Source",
      subtitle: "Direct link clicks",
      ratingPersent: 20.5,
      amunt: 1200,
    ),
    (
      image: AcnooSVGIcons.shareIcon,
      title: "Referrals",
      subtitle: "Impact radius visits",
      ratingPersent: 20.5,
      amunt: 1200,
    ),
    (
      image: AcnooSVGIcons.sEmailIcon,
      title: "Email Newsletter",
      subtitle: "Email campaigns",
      ratingPersent: -4,
      amunt: 300,
    ),
    (
      image: AcnooSVGIcons.cloudIcon,
      title: "Others",
      subtitle: "Many sources",
      ratingPersent: 20.5,
      amunt: 1200,
    ),
    (
      image: AcnooSVGIcons.facebookIcon,
      title: "Social Networks",
      subtitle: "All social site",
      ratingPersent: 20.5,
      amunt: 1200,
    ),
  ];
}

List<({String title, String subtitle, String image, double persentAmount})>
    get _visitedCountryList {
  return [
    (
      title: "India",
      subtitle: "1500",
      image: "assets/images/widget_images/country_image/in.png",
      persentAmount: 20,
    ),
    (
      title: "Bangladesh",
      subtitle: "8,000",
      image: "assets/images/widget_images/country_image/bd.png",
      persentAmount: 10.8,
    ),
    (
      title: "Pakistan",
      subtitle: "300",
      image: "assets/images/widget_images/country_image/pakisthan.png",
      persentAmount: 35.7,
    ),
    (
      title: "Saudi Arabia",
      subtitle: "1240",
      image: "assets/images/widget_images/country_image/saudi.png",
      persentAmount: 20,
    ),
    (
      title: "USA",
      subtitle: "1500",
      image: "assets/images/widget_images/country_image/us.png",
      persentAmount: 10.8,
    ),
  ];
}
