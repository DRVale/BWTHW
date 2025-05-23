import 'package:intl/intl.dart';

class Distance{

  final DateTime time;
  final int value;

  Distance({required this.time,required this.value,});

  //Costruttore che elabora il Json della risposta, per l'output
  Distance.fromJson(String date, Map<String, dynamic> json) :
    time = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
    value = int.parse(json["value"]);
  
  @override
  String toString() {
    return 'Distance(time: $time, value: $value)';
  } //toString

}

class Exercise{
  final DateTime time;
  final double averageHeartRate;
  final double distance;
  final double speed;

  Exercise({required this.time,required this.averageHeartRate,required this.distance, required this.speed});

  Exercise.fromJson(String date, Map<String, dynamic> json) :
    time = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
    averageHeartRate = double.parse(json["averageHeartRate"]),
    distance = double.parse(json["distance"]),
    speed = double.parse(json["speed"]);

  @override
  String toString() {
    return 'Distance(time: $time, value: $averageHeartRate, value: $distance, value: $speed)';
  } //toString

}

class HeartRate{
  final DateTime time;
  final int value;

  HeartRate({required this.time,required this.value,});

  HeartRate.fromJson(String date, Map<String, dynamic> json) :
    time = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
    value = int.parse(json["value"]);
  
  @override
  String toString() {
    return 'HeartRate(time: $time, value: $value)';
  } //toString
}



