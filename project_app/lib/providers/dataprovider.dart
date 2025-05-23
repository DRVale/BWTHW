import 'package:flutter/material.dart';
import 'package:project_app/utils/impact.dart';
import 'package:project_app/models/requesteddata.dart';

class DataProvider extends ChangeNotifier{

  List<Distance> distances = [];
  double ? XP;
  List<Exercise> exercisedata = [];
  List<HeartRate> heartRate = [];

  // Provide Distance data
  void fetchDistanceData(String day) async {
    final data = await Impact.fetchDistanceData(day);

    if(data != null){
      for(var i = 1; i < data['data']['data'].length; i++){
        distances.add(Distance.fromJson(data['data']['date'], data['data']['data'][i]));
      }
      notifyListeners();
    }
  }

  void fetchHeartRateData(String startDate, String endDate) async {

    final data = await Impact.fetchHeartRateData(startDate, endDate);

    if(data != null){
      for(var i = 1; i < data['data']['data'].length; i++){
        distances.add(Distance.fromJson(data['data']['date'], data['data']['data'][i]));
      }
      notifyListeners();
    }
  }

  // Delete Distance data
  void clearDistanceData(){
    distances.clear();
    notifyListeners();
  }

  // Provide Exersice Data
  void fetchExerciseData(String day) async {
    final data = await Impact.fetchExerciseData(day);

    if(data != null){
      // for(var i = 1; i < data['data']['data'].length; i++){
      //   exercisedata.add(Exercise.fromJson(data['data']['date'], data['data']['data'][i]));
      // }
      exercisedata.add(Exercise.fromJson(data['data']['date'], data['data']['data']['averageHeartRate']));
      exercisedata.add(Exercise.fromJson(data['data']['date'], data['data']['data']['distance']));
      exercisedata.add(Exercise.fromJson(data['data']['date'], data['data']['data']['speed']));
      notifyListeners();
    }
  }


  void updateXP(String deliveryMethod, List<Distance> distance, double speed){

    double scoreCamminata = 0;
    double scoreCorsa = 0;
    double scoreBici = 0;
    double distanceWeight = 0;
    double speedWeight = 0;

    int dataLength = distance.length;
    int distances = 0;
      for(var i = 0; i < dataLength; i++){
        distances = distances + distance[i].value;
      }

    // Consider different ranges for "Corsa", "Camminata", "Bici"
    if(deliveryMethod == 'Camminata'){
      if(distances < 1500) distanceWeight = 0.33;
      if(distances > 1500 && distances < 3000) distanceWeight = 0.66;
      if(distances > 3000) distanceWeight = 1;

      if(speed < 1.5) speedWeight = 0.33;
      if(speed > 1.5 && speed < 3) speedWeight = 0.66;
      if(speed > 3) speedWeight = 1;

      scoreCamminata = distanceWeight * speedWeight;
    }

    if(deliveryMethod == 'Corsa'){
      if(distances < 2000) distanceWeight = 0.33;
      if(distances > 2000 && distances < 5000) distanceWeight = 0.66;
      if(distances > 5000) distanceWeight = 1;

      // Convert speed into min/km
      speed = 60 / speed;

      if(speed > 8) speedWeight = 0.33;
      if(speed > 5 && speed < 8) speedWeight = 0.66;
      if(speed < 5) speedWeight = 1;

      scoreCorsa = distanceWeight * speedWeight;
    }

    if(deliveryMethod == 'Bici'){
      if(distances < 3000) distanceWeight = 0.33;
      if(distances > 3000 && distances < 6000) distanceWeight = 0.66;
      if(distances > 6000) distanceWeight = 1;

      if(speed < 10) speedWeight = 0.33;
      if(speed > 10 && speed < 16) speedWeight = 0.66;
      if(speed > 16) speedWeight = 1;

      scoreBici = distanceWeight * speedWeight;
    }

    XP = scoreCamminata + scoreCorsa * 1.5 + scoreBici;
    notifyListeners();
    
  }

  int getTotalDistance(List<Distance> distance){
    int dataLength = distance.length;
    int totaldistance = 0;
      for(var i = 0; i < dataLength; i++){
        totaldistance = totaldistance + distance[i].value;
      }
    return totaldistance;
  }

}