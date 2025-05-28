import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:project_app/models/requesteddata.dart';

/// Local import

///Renders default line series chart
class HeartRateDataPlot extends StatelessWidget {
  ///Creates default line series chart
  HeartRateDataPlot({Key? key, required this.heartRateData}) : super(key: key);

  final List<HeartRate> heartRateData;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: 'Heart Rate Data'),
      primaryXAxis: const DateTimeAxis(majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: const NumericAxis(
          labelFormat: '{value} bpm',
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
          dataSource: heartRateData,
          xValueMapper: (data, _) => data.time,
          yValueMapper: (data, _) => data.value,
          name: 'HeartRate',
          markerSettings: const MarkerSettings(isVisible: true))
    ];
  }//_getDistanceDataSeries

}//DistanceDataPlot

class DistanceDataPlot extends StatelessWidget {
  ///Creates default line series chart
  DistanceDataPlot({Key? key, required this.distanceData}) : super(key: key);

  final List<Distance> distanceData;

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
      series: _getDistanceDataSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// The method returns line series to chart.
  List<LineSeries<Distance, DateTime>> _getDistanceDataSeries() {
    return <LineSeries<Distance, DateTime>>[
      LineSeries<Distance, DateTime>(
          dataSource: distanceData,
          xValueMapper: (data, _) => data.time,
          yValueMapper: (data, _) => data.value,
          name: 'Distance',
          markerSettings: const MarkerSettings(isVisible: true))
    ];
  }//_getDistanceDataSeries

}//DistanceDataPlot