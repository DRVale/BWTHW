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
                } else {
                  // return DistanceDataPlot(distanceData: data.distancesDay);
                  var distance_debug = data.distances;
                  var exercise_debug = data.exercisedata;
                  var heart_rate_debug = data.heartRate;
        
                  // For debug
                  print('Done');
                  return DistanceDataPlot(distanceData: data.distances);
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
                onPressed: () async {

                  String canteen = 'Piovego';

                  String address1 = 'Via Orto Botanico, 11 - 35123 Padova';
                  String address2 = 'Via Tiziano Minio, 15 - 35134 Padova';
                  String address3 = 'Via S.massimo, 49 - 35129 Padova';
                  String address4 = 'Via Giovanni Boccaccio, 96 - 35128 Padova';
                  
                  String packageType = 'Small';
                  String deliveryMethod = 'Bici';
        
                  String startTime = '2023-05-13 00:00:00';
                  String endTime = '2023-05-13 23:20:00';
        
                  await Provider.of<DataProvider>(context, listen: false).delivery(startTime, endTime);


                  final distances = Provider.of<DataProvider>(context, listen: false).distances;
                  final heartRate = Provider.of<DataProvider>(context, listen: false).heartRate;

                  // Per aggiungere le box
                  // addLotsOfBoxes(context);

                  // final fire = new FirebaseDB();
                  // await fire.addDeliveryDB(canteen, address, packageType, deliveryMethod, startTime, endTime, distances, heartRate);
                  
                  // addDeliveryDB(startTime, endTime, distances, heartRate);

                  //db.collection("deliveries").add(data);

                  print('Aggiunto elemento al database');
                    
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


  void addLotsOfBoxes(BuildContext context){
    String address1 = 'Via Orto Botanico, 11 - 35123 Padova';
    String address2 = 'Via Tiziano Minio, 15 - 35134 Padova';
    String address3 = 'Via S.massimo, 49 - 35129 Padova';
    String address4 = 'Via Giovanni Boccaccio, 96 - 35128 Padova';

    Provider.of<FirebaseDB>(context, listen: false).addBox('Piovego', address1, 'Small');
    Provider.of<FirebaseDB>(context, listen: false).addBox('Murialdo', address1, 'Medium');
    Provider.of<FirebaseDB>(context, listen: false).addBox('Pio X', address1, 'Large');
    Provider.of<FirebaseDB>(context, listen: false).addBox('Piovego', address1, 'Large');
    Provider.of<FirebaseDB>(context, listen: false).addBox('Belzoni', address1, 'Large');
    Provider.of<FirebaseDB>(context, listen: false).addBox('Piovego', address1, 'Large');
    Provider.of<FirebaseDB>(context, listen: false).addBox('Murialdo', address1, 'Small');
    Provider.of<FirebaseDB>(context, listen: false).addBox('Piovego', address2, 'Small');
    Provider.of<FirebaseDB>(context, listen: false).addBox('Belzoni', address2, 'Medium');
    Provider.of<FirebaseDB>(context, listen: false).addBox('Piovego', address2, 'Medium');
    Provider.of<FirebaseDB>(context, listen: false).addBox('Belzoni', address2, 'Large');
    Provider.of<FirebaseDB>(context, listen: false).addBox('Pio X', address2, 'Large');
    Provider.of<FirebaseDB>(context, listen: false).addBox('Piovego', address3, 'Medium');
    Provider.of<FirebaseDB>(context, listen: false).addBox('Murialdo', address3, 'Medium');
    Provider.of<FirebaseDB>(context, listen: false).addBox('Pio X', address3, 'Medium');
    Provider.of<FirebaseDB>(context, listen: false).addBox('Piovego', address3, 'Medium');
    Provider.of<FirebaseDB>(context, listen: false).addBox('Belzoni', address3, 'Large');
    Provider.of<FirebaseDB>(context, listen: false).addBox('Piovego', address4, 'Large');
    Provider.of<FirebaseDB>(context, listen: false).addBox('Belzoni', address4, 'Medium');
    Provider.of<FirebaseDB>(context, listen: false).addBox('Murialdo', address4, 'Medium');
    Provider.of<FirebaseDB>(context, listen: false).addBox('Piovego', address4, 'Medium');
    Provider.of<FirebaseDB>(context, listen: false).addBox('Pio X', address4, 'Medium');
    Provider.of<FirebaseDB>(context, listen: false).addBox('Piovego', address4, 'Small');
  }
}