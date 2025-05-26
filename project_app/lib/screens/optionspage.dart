import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:project_app/providers/dataprovider.dart';
import 'package:project_app/models/requesteddata.dart';
import 'package:project_app/widgets/line_plot.dart';
import 'dart:async';

class OptionsPage extends StatelessWidget {
  const OptionsPage({Key? key}) : super(key: key);

  static const routename = 'OptionsPage';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('OptionsPage'),
      ),

      body: Center(
        child: Column(
          children: [

            // Data plot of distance
            // Consumer<DataProvider>(builder: (context, data, child) {
            //   if (data.distances.length == 0) {
            //     return Text('Nothing to display, press the button to fetch the data');
            //   }//if
            //   else {
            //     // return DistanceDataPlot(distanceData: data.distancesDay);
            //     var distance_debug = data.distances;
            //     var exercise_debug = data.exercisedata;
            //     var heart_rate_debug = data.heartRate;

            //     // For debug
            //     print('Done');
            //     return DistanceDataPlot(distanceData: data.distances);
            //   }//else
            // }),

            // Data plot of Heart Rate
            Consumer<DataProvider>(builder: (context, data, child) {
              if (data.heartRate.length == 0) {
                return Text('No Heart Rate Data to display');
              }//if
              else {
                var distance_debug = data.distances;
                var exercise_debug = data.exercisedata;
                var heart_rate_debug = data.heartRate;

                // For debug
                print('Done');
                return HeartRateDataPlot(heartRateData: data.heartRate);
              }//else
            }),
            ElevatedButton(
              onPressed: (){
                // Provider.of<DataProvider>(context, listen: false).fetchHeartRateData('2023-05-12', '2023-05-13');
                // Provider.of<DataProvider>(context, listen: false).fetchDistanceDataDay('2023-05-13');
                // var distancesDay = Provider.of<DataProvider>(context, listen: false).distancesDay;

                // Provider.of<DataProvider>(context, listen: false).fetchDistanceData('2023-05-13 10:00:00', '2023-05-13 12:00:00');
                Provider.of<DataProvider>(context, listen: false).fetchHeartRateData('2023-05-13 00:00:00', '2023-05-13 12:00:00');

                // PER GLI EXERCISE SERVONO INDICI PARTICOLARI
                //Provider.of<DataProvider>(context, listen: false).fetchExerciseData('2023-05-13 00:00:00', '2023-05-13 20:00:00');

                //var distances = Provider.of<DataProvider>(context, listen: false).distances;
                // for debug
                //print('Done');
              },
              
              child: Text('Prendi i dati'),
            ),

            // Consumer<DataProvider>(builder: (context, data, child) {
            //   if (data.distances.length == 0) {
            //     return Text('');
            //   }else{
            //     int dataLength = data.distances.length;
            //     int totalDistance = 0;
            //     for(var i = 0; i < dataLength; i++){
            //       totalDistance = totalDistance + data.distances[i].value;
            //     }
                
            //     return Text('The total distance is $totalDistance');
            //   }//else
            // }),


          ],
        ),
      ),
    );
  }
}