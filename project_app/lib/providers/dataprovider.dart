import 'package:flutter/material.dart';
import 'package:project_app/models/requesteddata.dart';
import 'package:project_app/utils/impact.dart';
//import 'package:project_app/models/requesteddata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class DataProvider extends ChangeNotifier{

  String canteen = '';
  String address = '';
  String packageType = '';
  String deliveryMethod = '';

  List<Distance> distances = [];
  int sumOfDistances = 0;
  List<Distance> distancesDay = [];
  List<Exercise> exercisedata = [];
  List<HeartRate> heartRate = [];
  RestingHR ?restingHR;

  int totalXP = 0;

  List<Trimp> trimp_per_min = [];

  // variables for TRIMP 
  double ?HRr;
  double HRexe = 0;
  
  double ?xp;
  int xpIncrement = 0;

  // FORSE NON NECESSARIO
  int time = 0; // [s]
  double avgSpeed = 0;

  // Variabile Personal Information
  DateTime ?birthdate;
  String ?first_birthdate;
  String ?surname;
  String ?name;

  Future<void> delivery(String time1, String? time2) async {
    // Devo azzerare la distance list e la heartRate List ogni volta che c'è una nuva consegna 
    if(time2 != null) setTime(time1, time2);
    //clearDistanceData();
    //clearHeartRateData();
    await fetchDistanceData(time1, time2);
    await fetchHeartRateData(time1, time2);
    await fetchRestingHRData(time1);
    calculateSumOfDistances();
    getAvgSpeed();
    // fetchDistanceData(time1, time2); //doppia chiamata?
    
    // await updateXPtrimp();
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


  // Get Distance Data in a day range
  void fetchDistanceDataRange(String startTime, String endTime) async {

    // MODIFICARE LA FUNZIONE:
    // Fare un ifelse, se viene richiesto anche il tempo allora fare tutto il magheggio, 
    // altrimenti popolare la lista come fatto precedentemente.
    
    String startDay = '';
    String endDay = '';

    // Check if the input argument is an entire day or also includes the time
    if(startTime.length > 10) startDay = startTime.substring(0, 10);
    if(endTime.length > 10) endDay = endTime.substring(0, 10);

    final data = await Impact.fetchDistanceDataRange(startDay, endDay);

    if(data != null){
      for(var i = 0; i < data['data'].length; i++){
        for(var j = 0; j < data['data'][i]['data'].length; j++){

          // Compose DateTime (to check whether the current time is after startTime and before endTime)
          DateTime currentDateTime = DateTime.parse('${data['data'][i]['date']} ${data['data'][i]['data'][j]['time']}');

          // This condition checks if the times in the data are between the time range we are interested in
          if(currentDateTime.compareTo(DateTime.parse(startTime)) > 0 && currentDateTime.compareTo(DateTime.parse(endTime)) < 0){
            distances.add(Distance.fromJson(data['data'][i]['date'], data['data'][i]['data'][j]));
          }
        }
      }
      // Dovremo fare un metodo per selezionare solo il tempo di cui abbiamo bisogno
      // Praticamente:
      // La richiesta http accetta solo il formato per il giorno (non possiamo fare richieste per l'ora)
      // Possiamo però chiedere come parametro anche l'ora, tagliare la parte dell'ora per la richiesta e 
      // poi utilizzarla una volta ottenuti i dati per tenere solo i dati che ci interessano
      notifyListeners();
    }
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

  // Provide Exersice Data
  void fetchExerciseData(String time1, String? time2) async {

    String day = time1;
    if(time1.length > 10) day = time1.substring(0, 10);
    
    final data = await Impact.fetchExerciseData(day);

    if(data != null){
      for(var i = 1; i < data['data']['data'].length; i++){
        DateTime currentDateTime = DateTime.parse('${data['data']['date']} ${data['data']['data'][i]['time']}');

        // This condition checks if the times in the data are between the time range we are interested in
        if(time2 != null && currentDateTime.compareTo(DateTime.parse(time1)) > 0 && currentDateTime.compareTo(DateTime.parse(time2)) < 0){
          exercisedata.add(Exercise.fromJson(data['data']['date'], data['data']['data'][i]['averageHeartRate']));
          // exercisedata.add(Exercise.fromJson(data['data']['date'], data['data']['data'][i]['distance']));
          // exercisedata.add(Exercise.fromJson(data['data']['date'], data['data']['data'][i]['speed']));
        }

        if(time2 == null){
          exercisedata.add(Exercise.fromJson(data['data']['date'], data['data']['data'][i]['averageHeartRate']));
          // exercisedata.add(Exercise.fromJson(data['data']['date'], data['data']['data'][i]['distance']));
          // exercisedata.add(Exercise.fromJson(data['data']['date'], data['data']['data'][i]['speed']));
        }
      }
      notifyListeners();
    }
  }

  void getAvgSpeed(){
    avgSpeed = sumOfDistances/time * (3600); // [km/h]
  }

  Future<void> updateXP() async {

    // Initialize variables for XP calculation
    double scoreCamminata = 0;
    double scoreCorsa = 0;
    double scoreBici = 0;
    double distanceWeight = 0;
    double speedWeight = 0;

    // Clear the xpIncrement from previous deliveries
    xpIncrement = 0;

    // calculateSumOfDistances();
    // getAvgSpeed();

    // Consider different ranges for "Corsa", "Camminata", "Bici"
    if(deliveryMethod == 'Camminata'){
      if(sumOfDistances < 1500) distanceWeight = 0.33;
      if(sumOfDistances > 1500 && sumOfDistances < 3000) distanceWeight = 0.66;
      if(sumOfDistances > 3000) distanceWeight = 1;

      if(avgSpeed < 1.5) speedWeight = 0.33;
      if(avgSpeed > 1.5 && avgSpeed < 3) speedWeight = 0.66;
      if(avgSpeed > 3) speedWeight = 1;

      scoreCamminata = distanceWeight * speedWeight;
    }

    if(deliveryMethod == 'Corsa'){
      if(sumOfDistances < 2000) distanceWeight = 1/3;
      if(sumOfDistances > 2000 && sumOfDistances < 5000) distanceWeight = 2/3;
      if(sumOfDistances > 5000) distanceWeight = 1;

      // Convert speed into min/km
      double avgSpeed_minperkm = 60 / avgSpeed;

      if(avgSpeed_minperkm > 8) speedWeight = 1/3;
      if(avgSpeed_minperkm > 5 && avgSpeed_minperkm < 8) speedWeight = 2/3;
      if(avgSpeed_minperkm < 5) speedWeight = 1;

      scoreCorsa = distanceWeight * speedWeight;
    }

    if(deliveryMethod == 'Bici'){
      if(sumOfDistances < 3000) distanceWeight = 1/3;
      if(sumOfDistances > 3000 && sumOfDistances < 6000) distanceWeight = 2/3;
      if(sumOfDistances > 6000) distanceWeight = 1;

      if(avgSpeed < 10) speedWeight = 0.33;
      if(avgSpeed > 10 && avgSpeed < 16) speedWeight = 0.66;
      if(avgSpeed > 16) speedWeight = 1;

      scoreBici = distanceWeight * speedWeight;
    }

    // Get the old XP value
    SharedPreferences sp = await SharedPreferences.getInstance();
    xp = sp.getDouble('XP')!;

    // Calculate the XP gained during the delivery and update the new XP value
    
    xpIncrement = ((scoreCamminata + scoreCorsa * 1.5 + scoreBici) * 100).round();

    //if(xp != 0){
    xp = xpIncrement + xp!;
    //}
    
    // Store the value in the SP
    sp.setDouble('XP', xp!);

    notifyListeners();
  }

  // Future<void> HRrest() async {
  //   double HRr_sum = 0;
  //   for (var i = 0; i < heartRate.length; i++) {
  //     HRr_sum += heartRate[i].value; // Somma cumulata
  //   }
  //   HRr = (HRr_sum / heartRate.length); 
  //   notifyListeners();
  // }

  // Metodo per calcolo TRIMP per definire XP 
  // Servono HR_exe, HR_max, HR_rest
  // HR_rest deve essere calcolato come media di un intervallo a riposo
  // Ipotesi: chiediamo al paziente di caricare un valore medio. 
  // 
  Future<void> updateXPtrimp(Delivery delivery) async {
    
    //HR ESERCIZIO
    double HR_sum = 0;
    for (var i = 0; i < heartRate.length; i++) {
      HR_sum += heartRate[i].value; // Somma cumulativa
    }
    HRexe = HR_sum / heartRate.length; // Calcola la media

    // HR RESTING:
    if (restingHR != null) {
      HRr = restingHR!.value;
    } else {
      HRr = 60; // fallback default
    }


    // HR MAX stimato serve richiesta età da salvare nelle sharedPreferences 
    // Inserire nel peak_date il calcolo age. 
    SharedPreferences sp = await SharedPreferences.getInstance();
    // double ?age;
    // age = sp.getDouble('age')!;
    double HRmax = 220 - 24;

  
    // Tempo d'esercizio = time
    if (time == 0) {
      time = 1800; // esempio: fallback 30 minuti (1800 sec)
    }

    // calcolo TRIMP e TRIMP normalizzato 
    double TRIMP = time * ((HRexe - HRr!)/(HRmax-HRr!))*0.64*math.exp(1.92*((HRexe - HRr!)/(HRmax-HRr!)));
    double TRIMP_N = TRIMP/time;

    xp = sp.getDouble('XP') ?? 0;

    if(TRIMP_N < 1){
      xpIncrement = 15;
    }
    else if(TRIMP_N > 1 && TRIMP_N < 2){
      xpIncrement = 30;
    }
    else if(TRIMP_N > 2){
      xpIncrement = 45;
    }
    xp = xpIncrement + xp!;
    
    // Store the value in the SP
    sp.setDouble('XP', xp!);

    // Quando calcolo un nuovo xpIncrement poi azzero la distanza percorsa 

    notifyListeners();
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

  //birthdate2 = date.toString();
  notifyListeners();
  }

  Future<void> setSurname(BuildContext context, String surnameInput) async{
    final sp = await SharedPreferences.getInstance();
    surname = surnameInput; 
    surname ??= sp.getString('surname') ?? 'Unknown';  //se surname è null vado a prenderlo dalle SP 
    notifyListeners();
  }

  Future<void> setName(BuildContext context, String nameInput) async{
    final sp = await SharedPreferences.getInstance();
    name = nameInput; 
    name ??= sp.getString('username') ?? 'Unknown';  //se username è null vado a prenderlo dalle SP
    notifyListeners();
  }

  Future<void> setBirthdate(BuildContext context) async{
    //birthdate = dateInput; //formato Datetime
    //first_birthdate = birthdate.toString(); //converto per visualizzare formato stringa 
    notifyListeners();
  }
}