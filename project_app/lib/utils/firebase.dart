// External packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Models
import 'package:project_app/models/requesteddata.dart';


// Firebase class
class FirebaseDB extends ChangeNotifier{

  List<Delivery> deliveries = [];

  static final db = FirebaseFirestore.instance;

  Future<dynamic> addDeliveryDB(
    String canteen,
    String address,
    String packageType,
    String deliveryMethod,
    String startDate, 
    String endDate, 
    List<Distance> distances, 
    List <HeartRate> heartRate
  ) async {

    List<int> distancesValue = [];
    List<String> distancesTime = [];

    List<int> heartRateValue = [];
    List<String> heartRateTime = [];

    for(var i = 0; i < distances.length; i++){
      distancesValue.add(distances[i].value);
      distancesTime.add(DateFormat("yyyy-MM-dd hh:mm:ss").format(distances[i].time));
    }

    for(var i = 0; i < heartRate.length; i++){
      heartRateValue.add(heartRate[i].value);
      heartRateTime.add(DateFormat("yyyy-MM-dd hh:mm:ss").format(heartRate[i].time));
    }

    final data = {
      "canteen": canteen,
      "address": address,
      "packageType": packageType,
      "deliveryMethod": deliveryMethod,
      "start": startDate,
      "end": endDate,
      "distances": {
        "time": distancesTime,
        "value": distancesValue
      },
      "heartRate": {
        "time": heartRateTime,
        "value": heartRateValue
      }
    };
    
    await db.collection("deliveries").add(data);
  }


  Future<void> fetchDeliveriesDB() async {

    final queryResult = await db.collection('deliveries').get();

    for (var doc in queryResult.docs) {

      final data = doc.data(); // Extract data from each document in the result of the query

      // Extract start and end times
      final canteen = data["canteen"];
      final address = data["address"];
      final packageType = data["packageType"];
      final deliveryMethod = data["deliveryMethod"];
      final start = data["start"];
      final end = data["end"];

      // Inizialize data lists
      List<Distance> distances = [];
      List<HeartRate> heartRate = [];

      // Store the Distance and HeartRate elements inside their lists
      for(var i = 0; i < data["distances"]["time"].length; i++){ // Loop across all elements of distances contained in the document
        distances.add(  // Add the single Distance element (time and value) in the distances list
          Distance(
            time: DateTime.parse(data["distances"]["time"][i]), 
            value: data["distances"]["value"][i]
          )
        );
      }

      for(var i = 0; i < data["heartRate"]["time"].length; i++){ // Loop across all elements of distances contained in the document
        heartRate.add( // Add the single HeartRate element (time and value) in the distances list
          HeartRate(
            time: DateTime.parse(data["heartRate"]["time"][i]), 
            value: data["heartRate"]["value"][i]
          )
        );
      }

      // Add the resulting Delivery to the list of deliveries 
      deliveries.add(
        Delivery(
          canteen: canteen,
          address: address,
          packageType: packageType,
          deliveryMethod: deliveryMethod,
          start: start, 
          end: end, 
          distances: distances,
          heartRate: heartRate
        )
      );
    }
    notifyListeners();
  }

  Future<QuerySnapshot> fetchBoxes(String canteen) async {
    final res = await db.collection('boxes').where("canteen", isEqualTo: canteen).get();
    return res;
  }


  // Just to add boxes to the database
  Future<dynamic> addBox(String canteen, String address, String packageType) async {
    final data = {
      "canteen": canteen,
      "address": address,
      "packageType": packageType,
    };
    
    await db.collection("boxes").add(data);
  }
}


class Delivery{ // Move it into models folder

  final String canteen;
  final String address;
  final String packageType;
  final String deliveryMethod;
  final String start;
  final String end;
  final List<Distance> distances;
  final List<HeartRate> heartRate;

  Delivery({
    required this.canteen,
    required this.address,
    required this.packageType,
    required this.deliveryMethod,
    required this.start, 
    required this.end,
    required this.distances,
    required this.heartRate
  });
    
  @override
  String toString() {
    return 'Delivery started at $start and ended at $end. First values of HR and Distance: ${heartRate[0].value}, ${distances[0].value}';
  } //toString
}