import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:project_app/models/requesteddata.dart';


class TrimpDataPlot extends StatelessWidget {
  TrimpDataPlot({Key? key, required this.trimpData}) : super(key: key);

  final List<Trimp> trimpData;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      palette: [Colors.green],
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: 'Activity TRIMP'),
      primaryXAxis: const DateTimeAxis(majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: const NumericAxis(
          labelFormat: '{value}',
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(color: Colors.transparent)),
      series: _getTrimpDataSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<LineSeries<Trimp, DateTime>> _getTrimpDataSeries() {
    return <LineSeries<Trimp, DateTime>>[
      LineSeries<Trimp, DateTime>(
          dataSource: trimpData,
          xValueMapper: (data, _) => data.time,
          yValueMapper: (data, _) => data.value,
          name: 'TRIMP',
          markerSettings: const MarkerSettings(isVisible: true))
    ];
  }

}