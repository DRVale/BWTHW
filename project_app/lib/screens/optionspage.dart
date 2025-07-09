import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:project_app/providers/dataprovider.dart';
import 'package:project_app/widgets/line_plot.dart';
import 'package:project_app/utils/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class OptionsPage extends StatelessWidget {
  const OptionsPage({Key? key}) : super(key: key);

  static const routename = 'OptionsPage';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('OptionsPage'),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
        
              // Data plot of distance
              Consumer<DataProvider>(builder: (context, data, child) {
                if (data.distances.length == 0) {
                  return Text('Nothing to display, press the button to fetch the data');
                }//if
                else {
                  // return DistanceDataPlot(distanceData: data.distancesDay);
                  var distance_debug = data.distances;
                  var exercise_debug = data.exercisedata;
                  var heart_rate_debug = data.heartRate;
        
                  // For debug
                  print('Done');
                  return DistanceDataPlot(distanceData: []);
                }//else
              }),
        
              // Data plot of Heart Rate
              // Consumer<DataProvider>(builder: (context, data, child) {
              //   if (data.heartRate.length == 0) {
              //     return Text('No Heart Rate Data to display');
              //   }//if
              //   else {
              //     var distance_debug = data.distances;
              //     var exercise_debug = data.exercisedata;
              //     var heart_rate_debug = data.heartRate;
        
              //     // For debug
              //     print('Done');
        
              //     return HeartRateDataPlot(heartRateData: data.heartRate);
              //   }//else
              // }),
              ElevatedButton(
                onPressed: (){
        
                  String startTime = '2023-05-13 00:00:00';
                  String endTime = '2023-05-13 23:59:59';
        
                  // Provider.of<DataProvider>(context, listen: false).delivery(startTime, endTime);
                  // Firebase fire = new Firebase();

                  final db = FirebaseFirestore.instance;

                  final delivery_prova = {
                    "start": "2023-05-13 00:00:00",
                    "end": "2023-05-13 23:59:59",
                    "distances": [1, 2, 3, 4, 5, 6, 7],
                    "heartRate": [10, 20, 30, 40, 50, 60, 70],
                  };

                  db.collection("deliveries").add(delivery_prova);
                    
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
      ),
    );
  }
}