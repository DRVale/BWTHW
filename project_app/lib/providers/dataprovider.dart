import 'package:flutter/material.dart';
import 'package:project_app/utils/impact.dart';
import 'package:project_app/models/requesteddata.dart';

class DataProvider extends ChangeNotifier{

  List<Distance> distances = [];

  void fetchDistanceData(String day) async {
    final data = await Impact.fetchDistanceData(day);

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

}