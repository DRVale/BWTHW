import 'package:intl/intl.dart';

class Distance{

  final DateTime time;
  final int value;

  Distance({required this.time,required this.value,});

  //Costruttore che elabora il Json della risposta, per l'output
  Distance.fromJson(String date, Map<String, dynamic> json) :
    time = DateFormat('yyyy-MM-dd hh:mm:ss').parse('$date ${json["time"]}'),
    value = int.parse(json["value"]);
  
  @override
  String toString() {
    return 'Distance(time: $time, value: $value)';
  } //toString

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
  final RestingHR restingHR;

  Delivery({
    required this.canteen,
    required this.address,
    required this.packageType,
    required this.deliveryMethod,
    required this.start, 
    required this.end,
    required this.distances,
    required this.heartRate,
    required this.restingHR
  });
    
  @override
  String toString() {
    return 'Delivery started at $start and ended at $end. First values of HR and Distance: ${heartRate[0].value}, ${distances[0].value}';
  } //toString
}

class Exercise{
  /* 
  "activityName": "Camminata",
  "averageHeartRate": 101,
  "calories": 323,
  "duration": 2508000.0,
  "activeDuration": 2508000.0,
  "steps": 3084,
  "logType": "auto_detected",
  "heartRateZones": [
      {
          "name": "Fuori zona",
          "min": 30,
          "max": 107,
          "minutes": 25,
          "caloriesOut": 181.81334999999999
      },
      {
          "name": "Grassi bruciati",
          "min": 107,
          "max": 135,
          "minutes": 16,
          "caloriesOut": 140.95353000000003
      },
      {
          "name": "Attivita aerobica",
          "min": 135,
          "max": 169,
          "minutes": 0,
          "caloriesOut": 0
      },
      {
          "name": "Picco",
          "min": 169,
          "max": 220,
          "minutes": 0,
          "caloriesOut": 0
      }
  ],
  "elevationGain": 6.096,
  "time": "09:42:18"
  */
  final DateTime time;
  final double averageHeartRate; // vedere se è double
  // final int distance;
  // final double speed;

  Exercise({
    required this.time,
    required this.averageHeartRate,
    // required this.distance, 
    // required this.speed
  });

  Exercise.fromJson(String date, Map<String, dynamic> json) :
    time = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
    averageHeartRate = json["averageHeartRate"];
    // distance = json["distance"],
    // speed = double.parse(json["speed"]);

  @override
  String toString() {
    return 'Distance(time: $time, value: $averageHeartRate)';
  } //toString

}

class HeartRate{
  final DateTime time;
  final int value;
  // final int confidence;

  HeartRate({
    required this.time, 
    required this.value,
    // required this.confidence
  });

  HeartRate.fromJson(String date, Map<String, dynamic> json) :
    time = DateFormat('yyyy-MM-dd hh:mm:ss').parse('$date ${json["time"]}'),
    value = json["value"];
    // confidence = int.parse(json["confidence"]);
    
  @override
  String toString() {
    return 'HeartRate(time: $time, value: $value)';
  } //toString
}


class Trimp{
  final DateTime time;
  final double value;

  Trimp({
    required this.time, 
    required this.value,
  });
    
  @override
  String toString() {
    return 'TRIMP(time: $time, value: $value)';
  } //toString
}

class RestingHR{
  final DateTime time;
  final double value;

  RestingHR({
    required this.time, 
    required this.value,
  });
    
  @override
  String toString() {
    return 'Resting HR(time: $time, value: $value)';
  } //toString
}


