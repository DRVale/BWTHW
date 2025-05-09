// Classe impact 
// variabili statiche si riferiscono alla classe non all'oggetto 
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Impact {
  static const baseURL = 'https://impact.dei.unipd.it/bwthw/';
  static const pingURL = 'gate/v1/ping/';
  static const tokenURL = 'gate/v1/token/';
  static const refreshURL = 'gate/v1/refresh/';

  // oppure posso creare degli URL più lunghi, ex gateURL 

  Future<int> refreshTokens()async{
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



Future<int> loggingIn(String username, String password)async{
    
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
}