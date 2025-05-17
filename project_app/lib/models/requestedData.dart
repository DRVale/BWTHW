import 'package:intl/intl.dart';

class Distance{
  final DateTime timestamp;
  final int value;

  Distance({required this.timestamp,required this.value,});

  //Costruttore che elabora il Json della risposta, per l'output
  Distance.fromJson(String date, Map<String, dynamic> json) :
      timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
      value = int.parse(json["value"]);
  
  @override
  String toString() {
    return 'Distance(time: $timestamp, value: $value)';
  }//toString
  

  // int getTotalDistance(List<Distance> result){
  //   return 0 ;
  // }
}



