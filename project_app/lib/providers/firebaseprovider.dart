import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_app/models/requesteddata.dart';

class FirebaseProvider extends ChangeNotifier{

  List<Distance> distancesDB = [];

  void getDistanceDB(String start, String end) async {
    // await FirebaseFirestore.instance.collection('distance').get()
  }

  Future<void> addDistance(List<Distance> distances) async {

    for(var i = 0; i < distances.length; i++){
      await FirebaseFirestore.instance.collection('distance').add({
        'time': distances[i].time,
        'value': distances[i].value,
      });
    }
  }

}