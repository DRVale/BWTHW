import 'package:flutter/material.dart';
import 'package:project_app/models/requesteddata.dart';
import 'package:project_app/utils/impact.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataProvider extends ChangeNotifier{

  String canteen = '';
  String address = '';
  String packageType = '';
  String deliveryMethod = '';

  List<Distance> distances = [];
  int sumOfDistances = 0;
  List<Distance> distancesDay = [];
  List<HeartRate> heartRate = [];
  RestingHR ?restingHR;

  int totalXP = 0;

  List<Trimp> trimp_per_min = [];

  // variables for TRIMP 
  double ?HRr;
  double HRexe = 0;
  
  double ?xp;
  int xpIncrement = 0;

  int time = 0; // [s]
  double avgSpeed = 0;

  // Variabile Personal Information
  DateTime ?birthdate;
  String ?first_birthdate;
  String ?surname;
  String ?name;

  Future<void> delivery(String time1, String? time2) async {
    if(time2 != null) setTime(time1, time2);
    await fetchDistanceData(time1, time2);
    await fetchHeartRateData(time1, time2);
    await fetchRestingHRData(time1);
    calculateSumOfDistances();
    getAvgSpeed();
  }

  void setTime(String time1, String time2){

    // Transform Strings into DateTimes
    DateTime startTime = DateTime.tryParse(time1)!;
    DateTime endTime = DateTime.tryParse(time2)!;

    // Compute the difference between dates
    Duration difference = endTime.difference(startTime);

    // Save time as the difference in seconds
    time = difference.inSeconds;
  }

  // GETTERS AND SETTERS

  // canteen
  void setCanteen(String newCanteen){
    canteen = newCanteen;
  }
  String getCanteen(){
    return canteen;
  }

  // address
  void setAddress(String newAddress){
    address = newAddress;
  }
  String getAddress(){
    return address;
  }

  // packageType
  void setPackageType(String newPackageType){
    packageType = newPackageType;
  }
  String getPackageType(){
    return packageType;
  }

  // deliveryMethod
  void setDeliveryMethod(String newDeliveryMethod){
    deliveryMethod = newDeliveryMethod;
  }
  String getDeliveryMethod(){
    return deliveryMethod;
  }

  Future<void> fetchRestingHRData(String day) async {
    if(day.length > 10) day = day.substring(0, 10);
    final data = await Impact.fetchRestingHRData(day);

    if(data != null){
      DateTime time = DateTime.parse('${data['data']['date']} ${data['data']['data']['time']}');
      double value = data['data']['data']['value'];
      restingHR = RestingHR(time: time, value: value);
    }
    notifyListeners();
  }

  // Get Distance Data of a whole day
  Future<void> fetchDistanceData(String time1, String? time2) async {

    String day = time1;

    // Check if the input argument is an entire day or also includes the time
    if(time1.length > 10) day = time1.substring(0, 10);

    final data = await Impact.fetchDistanceData(day);

    if(data != null){
      for(var i = 1; i < data['data']['data'].length; i++){
        DateTime currentDateTime = DateTime.parse('${data['data']['date']} ${data['data']['data'][i]['time']}');

        // This condition checks if the times in the data are between the time range we are interested in
        if(time2 != null && currentDateTime.compareTo(DateTime.parse(time1)) >= 0 && currentDateTime.compareTo(DateTime.parse(time2)) <= 0){
          distances.add(Distance.fromJson(data['data']['date'], data['data']['data'][i]));
        }

        // If we do not include a second date, then the whole day is added to the list
        if(time2 == null){
          distances.add(Distance.fromJson(data['data']['date'], data['data']['data'][i]));
        }
      }
      notifyListeners();
    }
  }

  void calculateSumOfDistances(){
    if(sumOfDistances == 0){
      for(var i = 0; i < distances.length; i++){
        sumOfDistances = sumOfDistances + distances[i].value;
      }
      sumOfDistances = (sumOfDistances / 100000).round();
    }
  }

  Future<void> fetchHeartRateData(String time1, String? time2) async {

    clearHeartRateData();
    String day = time1;
    if(time1.length > 10) day = time1.substring(0, 10);

    final data = await Impact.fetchHeartRateData(day);

    if(data != null){
      for(var i = 0; i < data['data']['data'].length; i++){
        DateTime currentDateTime = DateTime.parse('${data['data']['date']} ${data['data']['data'][i]['time']}');

        // This condition checks if the times in the data are between the time range we are interested in
        if(time2 != null && currentDateTime.compareTo(DateTime.parse(time1)) >= 0 && currentDateTime.compareTo(DateTime.parse(time2)) <= 0){
          heartRate.add(HeartRate.fromJson(data['data']['date'], data['data']['data'][i]));
        }

        if(time2 == null){
          heartRate.add(HeartRate.fromJson(data['data']['date'], data['data']['data'][i]));
        }
      }
      notifyListeners();
    }
  }


  // Delete Distance data
  void clearDistanceData(){
    distances.clear();
    notifyListeners();
  }

  // Delete HR data
  void clearHeartRateData(){
    heartRate.clear;
    notifyListeners();
  }


  void getAvgSpeed(){
    avgSpeed = sumOfDistances/time * (3600); // [km/h]
  }


  Future<void> pickDate(BuildContext context) async{
    DateTime? date = await showDatePicker(context: context, firstDate: DateTime(1900), lastDate: DateTime.now(), initialDate: DateTime(2000),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: Colors.green,
          colorScheme: ColorScheme.light(
            primary: Colors.green,
            onPrimary: Colors.white,
            surface: Color.fromARGB(255, 250, 250, 238),
            onSurface: Colors.black54,
          ),
          dialogBackgroundColor: Color.fromARGB(255, 250, 250, 238),
        ),
        child: child!
      );
    }
  );

  birthdate = date;

  if (date != null) {
      first_birthdate = "${date.day}/${date.month}/${date.year}";
    }

  notifyListeners();
  }

  Future<void> setSurname(BuildContext context, String surnameInput) async{
    final sp = await SharedPreferences.getInstance();
    surname = surnameInput; 
    surname ??= sp.getString('surname') ?? 'Unknown'; 
    notifyListeners();
  }

  Future<void> setName(BuildContext context, String nameInput) async{
    final sp = await SharedPreferences.getInstance();
    name = nameInput; 
    name ??= sp.getString('username') ?? 'Unknown';
    notifyListeners();
  }

  Future<void> setBirthdate(BuildContext context) async{
    notifyListeners();
  }
}