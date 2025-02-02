import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../../generated/l10n.dart' as l;

class TopSellingCategoriesChat extends StatefulWidget {
  const TopSellingCategoriesChat({super.key});

  @override
  State<TopSellingCategoriesChat> createState() =>
      _TopSellingCategoriesChatState();
}

class _TopSellingCategoriesChatState extends State<TopSellingCategoriesChat> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    super.initState();
    data = [
      _ChartData(
        'Shoes',
        20,
        Color(0xff0FAC62),
      ),
      _ChartData(
        'Watch',
        28,
        Color(0xff6AD4D4),
      ),
      _ChartData(
        'Mobile',
        30,
        Color(0xffFED126),
      ),
      _ChartData(
        'Woman Fashion\'s',
        40,
        Color(0xff5BA6FF),
      ),
      _ChartData(
        'Man Fashion\'s',
        48,
        Color(0xff8757ED),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _lang = l.S.of(context);
    _tooltip = _tooltip = TooltipBehavior(
      enable: true,
      color: _theme.colorScheme.primaryContainer,
      textStyle: _theme.textTheme.bodyMedium?.copyWith(
        color: _theme.colorScheme.onPrimaryContainer,
      ),
    );
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        isVisible: false,
      ),
      primaryYAxis: NumericAxis(
        minimum: 10,
        maximum: 50,
        interval: 10,
        labelFormat: r'${value}k',
        axisLine: const AxisLine(width: 0),
        majorGridLines: MajorGridLines(
          color: _theme.colorScheme.outline,
          dashArray: [5, 5],
        ),
      ),
      tooltipBehavior: _tooltip,
      series: <CartesianSeries<_ChartData, String>>[
        BarSeries<_ChartData, String>(
          width: 0.15,
          dataSource: data,
          xValueMapper: (_ChartData data, _) => data.x,
          yValueMapper: (_ChartData data, _) => data.y,
          pointColorMapper: (_ChartData data, _) => data.color,
          dataLabelMapper: (_ChartData data, _) => data.x,
          dataLabelSettings: DataLabelSettings(
            offset: Offset(
              0,
              25,
            ),
            margin: EdgeInsets.zero,
            isVisible: true, // Enable labels
            labelAlignment: ChartDataLabelAlignment.bottom,
            alignment: ChartAlignment.far,
            labelPosition: ChartDataLabelPosition.outside,
            textStyle: _theme.textTheme.bodyLarge,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(6),
          ),
          enableTooltip: true,
          name: _lang.topSellingCategories,
          color: Color.fromRGBO(
            8,
            142,
            255,
            1,
          ),
        ),
      ],
    );
  }
}

class _ChartData {
  _ChartData(
    this.x,
    this.y,
    this.color,
  );
  final Color color;
  final String x;
  final double y;
}
