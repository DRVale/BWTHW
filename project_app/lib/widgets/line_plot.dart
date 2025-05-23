import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:project_app/models/requesteddata.dart';

/// Local import

///Renders default line series chart
class HeartRateDataPlot extends StatelessWidget {
  ///Creates default line series chart
  HeartRateDataPlot({Key? key, required this.HeartRateData}) : super(key: key);

  final List<HeartRate> HeartRateData;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: 'Yesterday Distance'),
      primaryXAxis: const DateTimeAxis(majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: const NumericAxis(
          labelFormat: '{value} meters',
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(color: Colors.transparent)),
      series: _getHRDataSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// The method returns line series to chart.
  List<LineSeries<HeartRate, DateTime>> _getHRDataSeries() {
    return <LineSeries<HeartRate, DateTime>>[
      LineSeries<HeartRate, DateTime>(
          dataSource: HeartRateData,
          xValueMapper: (data, _) => data.time,
          yValueMapper: (data, _) => data.value,
          name: 'HeartRate',
          markerSettings: const MarkerSettings(isVisible: true))
    ];
  }//_getDistanceDataSeries

}//DistanceDataPlot