// External packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_app/screens/deliverypage.dart';
import 'dart:math' as math;

// Models
import 'package:project_app/models/requesteddata.dart';

// Providers
import 'package:provider/provider.dart';
import 'package:project_app/providers/dataprovider.dart';



// Firebase class
class FirebaseDB extends ChangeNotifier{

  List<Delivery> deliveries = [];
  List<Trimp> trimp_per_min = [];

  int totalDeliveries = 0;
  int bikeDeliveries = 0;
  int footDeliveries = 0;
  int runningDeliveries = 0;

  int totalXP = 0;
  int historyXP = 0;  // Store the value of all the XP that has been obtained

  void getTotalDeliveries(){
    totalDeliveries = deliveries.length;
  }

  // AGGIUNGERE CONTEGGIO DELIVERIES

  Future<void> getTotalXP() async { // From all the deliveries, get one at a time. Then, calculate the xp increment related to the delivery
    
    totalXP = 0; // Before computing the total, clear the past value

    for(var i = 0; i < deliveries.length; i++){
      totalXP = totalXP + updateXPtrimp(deliveries[i]);
    }

    historyXP = totalXP;
    totalXP = totalXP % 500;  // If the totalXP is above 500, get the remainder of the division  
  }

    
  int updateXPtrimp(Delivery delivery){

    int xpIncrement = 0;
      
    //HR ESERCIZIO
    double HR_sum = 0;
    for (var i = 0; i < delivery.heartRate.length; i++) {
      HR_sum += delivery.heartRate[i].value; // Somma cumulativa
    }
    double HRexe = HR_sum / delivery.heartRate.length; // Calcola la media

    // HR MAX stimato serve richiesta età da salvare nelle sharedPreferences 
    // Inserire nel peak_date il calcolo age. 
    // SharedPreferences sp = await SharedPreferences.getInstance();
    // double ?age;
    // age = sp.getDouble('age')!;
    double HRmax = 220 - 24;

    DateTime start = DateTime.parse(delivery.start);
    DateTime end = DateTime.parse(delivery.end);

    Duration deliveryTime = end.difference(start);
    int time = deliveryTime.inSeconds;

    // Calculate TRIMP and normalized TRIMP 
    double TRIMP = time * ((HRexe - delivery.restingHR.value)/(HRmax - delivery.restingHR.value))*0.64*math.exp(1.92*((HRexe - delivery.restingHR.value)/(HRmax - delivery.restingHR.value)));
    double TRIMP_N = TRIMP / time;

    if(TRIMP_N < 1){
      xpIncrement = 15;
    }
    else if(TRIMP_N > 1 && TRIMP_N < 2){
      xpIncrement = 30;
    }
    else if(TRIMP_N > 2){
      xpIncrement = 45;
    }  
    return xpIncrement;
  }

  void getTrimpPerMin(Delivery delivery){
    trimp_per_min.clear();
    DateTime startTime = delivery.heartRate[0].time;
    DateTime endTime = delivery.heartRate[delivery.heartRate.length-1].time;

    DateTime currentTime = startTime;

    // var user;
    var age = 35;

    while(endTime.difference(currentTime) >= Duration.zero){

      double trimp = 0;  // trimp temporary variable to store the total trimp in a minute
      int counter = 0; // counter to check how many times I sum a trimp in a minute

      // Loop across all HR values
      for(var i = 0; i < delivery.heartRate.length; i++){

        // Check if the current index of the time is in the considered minute
        if(delivery.heartRate[i].time.difference(currentTime) > Duration.zero  && delivery.heartRate[i].time.difference(currentTime.add(Duration(minutes: 1))) < Duration.zero){

          // Calculate the trimp and update the counter
          // trimp = T * (HRex - HRrest) / (HRmax - HRrest) * 0.64 * exp(1.92 * (HRex - HRrest) / (HRmax - HRrest))
          // where 𝑇: duration of the workout (min) 
          // 𝐻𝑅𝑒𝑥: average heart rate during the workout (bpm) 
          // 𝐻𝑅𝑚𝑎𝑥: maximal heart rate (bpm) - estimated as (220 – age)
          // 𝐻𝑅𝑟𝑒𝑠𝑡: resting heart rate (bpm)
          trimp = trimp + (delivery.heartRate[i].value - delivery.restingHR.value)/(220 - age - delivery.restingHR.value) * 0.64 * exp(1.92 * (delivery.heartRate[i].value - delivery.restingHR.value) / (220 - age - delivery.restingHR.value));
          // trimp = trimp + delivery.heartRate[i].value;
          counter = counter + 1;
        }
      }

      // Calculate the average trimp
      double trimpAvg = trimp / counter;

      // Add the value to the Trimp list
      trimp_per_min.add(Trimp(time: currentTime, value: trimpAvg));

      // Update the current minute for the next loop iteration
      currentTime = currentTime.add(Duration(minutes: 1));
    }
    // 1) Get the total minutes of the delivery
    // 2) loop across the minutes
    // 3) for each minute, calculate the trimp, sum it and divide by the number of measures in the time span
    // 4) add the value (time + value) to the trimp_per_min list
    notifyListeners();
  }

  static final db = FirebaseFirestore.instance;

  Future<dynamic> addDeliveryDB(
    String canteen,
    String address,
    String packageType,
    String deliveryMethod,
    String startDate, 
    String endDate, 
    RestingHR restingHR,
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
      "restingHR": restingHR.value,
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


  Future<void> fetchDeliveriesDB({String? deliveryMethod}) async {

    deliveries.clear();

    final queryResult = deliveryMethod == null? 
      await db.collection('deliveries').get() // Get all the deliveries
      : 
      await db.collection('deliveries').where("deliveryMethod", isEqualTo: deliveryMethod).get(); // Get only the deliveries made with the selected deliveryMethod


    for (var doc in queryResult.docs) {

      final data = doc.data(); // Extract data from each document in the result of the query

      // Extract start and end times
      final canteen = data["canteen"];
      final address = data["address"];
      final packageType = data["packageType"];
      final deliveryMethod = data["deliveryMethod"];
      final start = data["start"];
      final end = data["end"];
      final restingHR = RestingHR(time: DateTime.parse(data["start"]) , value: data["restingHR"]);

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
          heartRate: heartRate,
          restingHR: restingHR
        )
      );
    }
    notifyListeners();
  }

  Future<QuerySnapshot> fetchBoxes(String canteen) async {
    final res = await db.collection("boxes").where("canteen", isEqualTo: canteen).get();
    return res;
  }

  Future<void> removeBox(String canteen, String address, String packageType) {
  WriteBatch batch = FirebaseFirestore.instance.batch(); // Better for multiple write operations as a single batch that can contain any combination of set, update, or delete operations

  return db.collection("boxes")
    .where("canteen", isEqualTo: canteen) // Define which box we want to delete
    .where("address", isEqualTo: address)
    .where("packageType", isEqualTo: packageType)
    .limit(1) // Since we only want to delete 1 box
    .get()    // Get the reference to the box
    .then((querySnapshot) {

      querySnapshot.docs.forEach((document){
        batch.delete(document.reference);
        print('Box $canteen, $address, $packageType removed');
      });

      return batch.commit();
    });
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
