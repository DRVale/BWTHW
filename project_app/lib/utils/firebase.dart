// External packages 
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:io';
import 'dart:convert';

// Models
import 'package:project_app/models/requesteddata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



// Firebase class
class Firebase {

  static final db = FirebaseFirestore.instance;

  final deliveries = db.collection("deliveries");
  // final delivery1 = <String, dynamic>{
  //   "start": ,
  //   "end": ,
  //   "distances": ,
  //   "heartRate": ,
  // };

  String startDate_prova = "2023-05-13 00:00:00";
  String endDate_prova = "2023-05-13 23:59:59";

  final delivery_prova = {
    "start": "2023-05-13 00:00:00",
    "end": "2023-05-13 23:59:59",
    "distances": [1, 2, 3, 4, 5, 6, 7],
    "heartRate": [10, 20, 30, 40, 50, 60, 70],
  };

  Future<dynamic> addDeliveryDB(String startDate, String endDate, List<dynamic> distances, List <dynamic> heartRate) async {

    final data = {
      "start": startDate,
      "end": endDate,
      "distances": distances,
      "heartRate": heartRate
    };
    
    db.collection("deliveries").add(data);
  }
  
  
  static Future<dynamic> getDistanceDB(String start, String end) async{
    final distanceDB = await FirebaseFirestore.instance.collection('distance').get();
    // db.collection("deliveries").add(data1);
    return distanceDB;
  }
  
}