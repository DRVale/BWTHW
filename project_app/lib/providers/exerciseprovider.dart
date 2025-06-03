// import 'package:flutter/material.dart';
// import 'package:project_app/utils/impact.dart';
// import 'package:project_app/models/requesteddata.dart';

// class ExerciseProvider extends ChangeNotifier{
//     List<Exercise> exercisedata = [];

//     void fetchExerciseData(String day) async {
//     final data = await Impact.fetchExerciseData(day);

//     if(data != null){
//       // for(var i = 1; i < data['data']['data'].length; i++){
//       //   exercisedata.add(Exercise.fromJson(data['data']['date'], data['data']['data'][i]));
//       // }
//       exercisedata.add(Exercise.fromJson(data['data']['date'], data['data']['data']['averageHeartRate']));
//       exercisedata.add(Exercise.fromJson(data['data']['date'], data['data']['data']['distance']));
//       exercisedata.add(Exercise.fromJson(data['data']['date'], data['data']['data']['speed']));
//       notifyListeners();
//     }
//   }
// }