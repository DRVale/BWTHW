import 'package:intl/intl.dart';

class Distance{

  final DateTime time;
  final int value;

  Distance({required this.time,required this.value,});

  Distance.fromJson(String date, Map<String, dynamic> json) :
    time = DateFormat('yyyy-MM-dd hh:mm:ss').parse('$date ${json["time"]}'),
    value = int.parse(json["value"]);
  
  @override
  String toString() {
    return 'Distance(time: $time, value: $value)';
  }

}

class Delivery{

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
  } 
}


class HeartRate{
  final DateTime time;
  final int value;

  HeartRate({
    required this.time, 
    required this.value,
  });

  HeartRate.fromJson(String date, Map<String, dynamic> json) :
    time = DateFormat('yyyy-MM-dd hh:mm:ss').parse('$date ${json["time"]}'),
    value = json["value"];    
  @override
  String toString() {
    return 'HeartRate(time: $time, value: $value)';
  }
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
  }
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
  }
}


