import 'package:flutter/material.dart';
import 'package:project_app/screens/loginpage.dart';
import 'package:project_app/screens/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Serve creare un Future method per controllare le credenziali:
  // Se restituisce TRUE, eseguo un build con Homepage, altrimenti con LoginPage
  
  Future<bool> logincheck()async{
      final credentialscheck = await SharedPreferences.getInstance();
      final usercheck = credentialscheck.getString('username');
      final pswcheck = credentialscheck.getString('password');
      if(usercheck != null && pswcheck != null){
        return true;
      }
      else{
        return false;
      }
  }

  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // invece di un builder normale utilizzo un future builder
      home: FutureBuilder(
        future: logincheck(), 
        builder: (context, snapshot){
          if (snapshot.hasData && snapshot.data == true) {
            return HomePage(); // Vai alla home se già loggato
          } else {
            return LoginPage(); // Altrimenti login
          }
        }
        ),
    );
  }

}
