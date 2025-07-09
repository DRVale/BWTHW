// External packages 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:io';
import 'dart:convert';

// IMPACT CLASS
class Impact {
  static const baseURL = 'https://impact.dei.unipd.it/bwthw/';
  static const pingURL = 'gate/v1/ping/';
  static const tokenURL = 'gate/v1/token/';
  static const refreshURL = 'gate/v1/refresh/';

  // Username: grWTWvehjO
  // Password: 12345678!
  static String username = 'grWTWvehjO';
  static String password = '12345678!';

  // patient username: Jpefaq6m58
  static String patientUsername = 'Jpefaq6m58';

  // URL richiesta dati
  // DISTANCE
  static const distanceURL = 'data/v1/distance/patients/';
  
  // HEART RATE
  static const heartrateURL = 'data/v1/heart_rate/patients/';
  static const restingHR_URL = 'data/v1/resting_heart_rate/patients/'; 
  

  // EXERCISE
  static const exerciseURL = 'data/v1/exercise/patients/';

 

  // oppure posso creare degli URL più lunghi, ex gateURL 

  Future<int> refreshTokens() async {
    final sp = await SharedPreferences.getInstance(); 
    final refresh_token = sp.getString('refresh');

    if(refresh_token != null){
      //final url = 'https://impact.dei.unipd.it/bwthw/gate/v1/token/';
      final url = Impact.baseURL + Impact.refreshURL;
      final uri = Uri.parse(url);
      // NB: creo corpo per la richiesta: Metodo post richiede parametro body CORREGGERE CREDENZIALI
      final body = {'refresh': refresh_token};
      //Richiesta completa di uri e body
      final response = await http.post(uri, body: body);  
      //richiesta token è post: attenzione a inserire user e psw nella richiesta. body come parametro del metodo post
      // Controllo status code
      //print(response.statusCode);

      if(response.statusCode == 200){
        final decodedResponse = jsonDecode(response.body); // conversione formato Json
        //print(decodedResponse['access']);

        //Interrogo SharedPreferences
        final credentials = await SharedPreferences.getInstance();

        // Salvo token d'accesso e di refresh
        credentials.setString('access', decodedResponse['access']); 
        credentials.setString('refresh', decodedResponse['refresh']); 
      }

      return response.statusCode;
    }
    return 401;
  }



  Future<int> loggingIn(String username, String password) async {
    
  //final url = 'https://impact.dei.unipd.it/bwthw/gate/v1/token/';
  final url = Impact.baseURL + Impact.tokenURL;
  final uri = Uri.parse(url);
  // NB: creo corpo per la richiesta: Metodo post richiede parametro body CORREGGERE CREDENZIALI
  final body = {'username': username, 'password': password};
  //Richiesta completa di uri e body
  final response = await http.post(uri, body: body);  
  //richiesta token è post: attenzione a inserire user e psw nella richiesta. body come parametro del metodo post
  // Controllo status code
  //print(response.statusCode);

  if(response.statusCode == 200){
    final decodedResponse = jsonDecode(response.body); // conversione formato Json
    //print(decodedResponse['access']);

    //Interrogo SharedPreferences
    final credentials = await SharedPreferences.getInstance();

    // Salvo token d'accesso e di refresh
    credentials.setString('access', decodedResponse['access']); 
    credentials.setString('refresh', decodedResponse['refresh']);   
  }

  return response.statusCode;
}

  static Future<dynamic> fetchDistanceDataRange(String startTime, String endTime) async{

    // Check access 
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    // If access token is expired, refresh it
    if(JwtDecoder.isExpired(access!)){
      await Impact().refreshTokens();
      access = sp.getString('access');
    }

    //Create the (representative) request
    final url = Impact.baseURL + Impact.distanceURL + Impact.patientUsername + '/daterange/start_date/$startTime/end_date/$endTime/';

    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    // For debug
    print('Calling: $url');

    final response = await http.get(Uri.parse(url), headers: headers);

    var result = null;

    // Check response code
    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
      print('Request successful');
    }
    
    // Return the response body
    return result;
  }

  static Future<dynamic> fetchDistanceData(String day) async{

    // Check access 
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    // If access token is expired, refresh it
    if(JwtDecoder.isExpired(access!)){
      await Impact().refreshTokens();
      access = sp.getString('access');
    }

    //Create the (representative) request
    final url = Impact.baseURL + Impact.distanceURL + Impact.patientUsername + '/day/$day/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    // For debug
    //print('Calling: $url');

    final response = await http.get(Uri.parse(url), headers: headers);

    var result = null;

    // Check response code
    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
    }

    // Return the response body
    return result;
  }

  static Future<dynamic> fetchRestingHRData(String day) async{

    // Check access 
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    // If access token is expired, refresh it
    if(JwtDecoder.isExpired(access!)){
      await Impact().refreshTokens();
      access = sp.getString('access');
    }

    //Create the (representative) request
    final url = Impact.baseURL + Impact.restingHR_URL + Impact.patientUsername + '/day/$day/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    final response = await http.get(Uri.parse(url), headers: headers);

    var result = null;

    // Check response code
    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
    }

    // Return the response body
    return result;
  }

  static Future<dynamic> fetchExerciseData(String day) async{

    // Check access 
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    // If access token is expired, refresh it
    if(JwtDecoder.isExpired(access!)){
      await Impact().refreshTokens();
      access = sp.getString('access');
    }

    //Create the (representative) request
    final url = Impact.baseURL + Impact.exerciseURL + Impact.patientUsername + '/day/$day/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    // For debug
    // print('Calling: $url');

    final response = await http.get(Uri.parse(url), headers: headers);

    var result = null;

    // Check response code
    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
    }
    
    // Return the response body
    return result;
  }


  static Future<dynamic> fetchHeartRateData(String day) async{

    // Check access 
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    // If access token is expired, refresh it
    if(JwtDecoder.isExpired(access!)){
      await Impact().refreshTokens();
      access = sp.getString('access');
    }

    //'{username}/daterange/start_date/{start_date}/end_date/{end_date}/';
    //Create the (representative) request
    final url = Impact.baseURL + Impact.heartrateURL + Impact.patientUsername + '/day/$day/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    // For debug
    // print('Calling: $url');

    final response = await http.get(Uri.parse(url), headers: headers);

    var result = null;

    // Check response code
    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
    }

    // Return the response body
    return result;
  }

  static Future<dynamic> fetchRestingHRData(String day) async{

    // Check access 
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    // If access token is expired, refresh it
    if(JwtDecoder.isExpired(access!)){
      await Impact().refreshTokens();
      access = sp.getString('access');
    }

    //Create the (representative) request
    final url = Impact.baseURL + Impact.restingHR_URL + Impact.patientUsername + '/day/$day/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    final response = await http.get(Uri.parse(url), headers: headers);

    var result = null;

    // Check response code
    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
    }

    // Return the response body

    return result;
  }
}