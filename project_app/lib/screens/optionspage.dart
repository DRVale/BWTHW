import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:project_app/providers/dataprovider.dart';
import 'package:project_app/models/requesteddata.dart';
import 'package:project_app/widgets/line_plot.dart';

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
            Consumer<DataProvider>(builder: (context, data, child) {
              if (data.distances.length == 0) {
                return Text('Nothing to display, press the button to fetch the data');
              }//if
              else {
                return DistanceDataPlot(distanceData: data.distances);
              }//else
            }),
            ElevatedButton(
              onPressed: () {
                Provider.of<DataProvider>(context, listen: false).fetchDistanceData('2023-05-13');

                // for debug
                print('Done');
              },
              
              child: Text('Prendi i dati'),
            ),

            Consumer<DataProvider>(builder: (context, data, child) {
              if (data.distances.length == 0) {
                return Text('');
              }else{
                int dataLength = data.distances.length;
                int totalDistance = 0;
                for(var i = 0; i < dataLength; i++){
                  totalDistance = totalDistance + data.distances[i].value;
                }
                
                return Text('The total distance is $totalDistance');
              }//else
            }),

          ],
        ),
      ),
    );
  }
}