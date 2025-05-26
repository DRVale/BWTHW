import 'package:flutter/material.dart';
import 'package:project_app/utils/impact.dart';
import 'package:project_app/models/requesteddata.dart';

class DataProvider extends ChangeNotifier{

  List<Distance> distances = [];
  int sumOfDistances = 0;
  List<Distance> distancesDay = [];
  double ? xp;
  List<Exercise> exercisedata = [];
  List<HeartRate> heartRate = [];

  // Get Distance Data in a day range
  void fetchDistanceDataRange(String startTime, String endTime) async {

    // MODIFICARE LA FUNZIONE:
    // Fare un ifelse, se viene richiesto anche il tempo allora fare tutto il magheggio, 
    // altrimenti popolare la lista come fatto precedentemente.
    
    String startDay = '';
    String endDay = '';

    // Check if the input argument is an entire day or also includes the time
    if(startTime.length > 10) startDay = startTime.substring(0, 10);
    if(endTime.length > 10) endDay = endTime.substring(0, 10);

    final data = await Impact.fetchDistanceDataRange(startDay, endDay);

    if(data != null){
      for(var i = 0; i < data['data'].length; i++){
        for(var j = 0; j < data['data'][i]['data'].length; j++){

          // Compose DateTime (to check whether the current time is after startTime and before endTime)
          DateTime currentDateTime = DateTime.parse('${data['data'][i]['date']} ${data['data'][i]['data'][j]['time']}');

          // This condition checks if the times in the data are between the time range we are interested in
          if(currentDateTime.compareTo(DateTime.parse(startTime)) > 0 && currentDateTime.compareTo(DateTime.parse(endTime)) < 0){
            distances.add(Distance.fromJson(data['data'][i]['date'], data['data'][i]['data'][j]));
          }
        }
      }
      // Dovremo fare un metodo per selezionare solo il tempo di cui abbiamo bisogno
      // Praticamente:
      // La richiesta http accetta solo il formato per il giorno (non possiamo fare richieste per l'ora)
      // Possiamo però chiedere come parametro anche l'ora, tagliare la parte dell'ora per la richiesta e 
      // poi utilizzarla una volta ottenuti i dati per tenere solo i dati che ci interessano
      notifyListeners();
    }
  }

  // Get Distance Data of a whole day
  void fetchDistanceData(String time1, String? time2) async {

    String day = '';

    // Check if the input argument is an entire day or also includes the time
    if(time1.length > 10) day = time1.substring(0, 10);

    final data = await Impact.fetchDistanceDataDay(day);

    if(data != null){
      for(var i = 1; i < data['data']['data'].length; i++){
        DateTime currentDateTime = DateTime.parse('${data['data']['date']} ${data['data']['data'][i]['time']}');

        // This condition checks if the times in the data are between the time range we are interested in
        if(time2 != null && currentDateTime.compareTo(DateTime.parse(time1)) > 0 && currentDateTime.compareTo(DateTime.parse(time2)) < 0){
          distances.add(Distance.fromJson(data['data']['date'], data['data']['data'][i]));
        }
      }
      notifyListeners();
    }
  }
  void getSumOfDistances(){
    for(var i = 0; i < distances.length; i++){
      sumOfDistances = sumOfDistances + distances[i].value;
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

    xp = scoreCamminata + scoreCorsa * 1.5 + scoreBici;
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