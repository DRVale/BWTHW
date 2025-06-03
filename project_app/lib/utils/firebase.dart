// External packages 
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

  // final data = {
  //   "start": ,
  //   "end": ,
  //   "distances": ,
  //   "heartRate": ,
  // }

  Future<dynamic> addDeliveryDB(var data) async {
    db.collection("deliveries").add(data);
  }
  
  
  static Future<dynamic> getDistanceDB(String start, String end) async{
    final distanceDB = await FirebaseFirestore.instance.collection('distance').get();
    // db.collection("deliveries").add(data1);
    return distanceDB;
  }
  
}