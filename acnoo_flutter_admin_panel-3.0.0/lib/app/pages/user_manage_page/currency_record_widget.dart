// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/currency/currency_record_service.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/user_manage_page/chip_record_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../core/helpers/helpers.dart';
import '../../core/theme/_app_colors.dart';
import '../../widgets/widgets.dart';
import '../projects_page/demo data/project_model.dart';
import 'coin_record_widget.dart';
import 'diamond_record_widget.dart';

class CurrencyRecordWidget extends StatefulWidget {
  const CurrencyRecordWidget({super.key, required this.userId});

  final int userId;

  @override
  State<CurrencyRecordWidget> createState() =>
      _CurrencyRecordWidgetState();
}

class _CurrencyRecordWidgetState extends State<CurrencyRecordWidget> with SingleTickerProviderStateMixin {
  ///_____________________________________________________________________Variables_______________________________
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  ///_____________________________________________________________________View_Details_____________________________

    int _selectedTitle = 0;

  List<String> get _title => [
        //"CHIP",
        l.S.current.chip,
        //"COIN",
        l.S.current.coin,
        //"DIAMOND",
        l.S.current.diamond,
      ];

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
                      //tab_bar
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
                          unselectedLabelColor: theme.colorScheme.onTertiary,
                          onTap: (value) => setState(() {
                            _selectedTitle = value;
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
                    ],
                  ),
                  Divider(
                    thickness: 0.3,
                    height: 0,
                    color: theme.colorScheme.outline,
                  )
                ],
              ),
              child: _getSelectedWidget(constraints),
            ),
          );
        },
      ),
    );
  }

  Widget _getSelectedWidget(BoxConstraints constraints) {
    switch (_selectedTitle) {
      case 0:
        return ChipRecordWidget(userId: widget.userId, constraints: constraints);
      case 1:
        return CoinRecordWidget(userId: widget.userId, constraints: constraints);
      case 2:
        return DiamondRecordWidget(userId: widget.userId, constraints: constraints);
      default:
        return Container();
    }
  }
}
