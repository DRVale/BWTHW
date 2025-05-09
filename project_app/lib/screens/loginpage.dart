import 'package:flutter/material.dart';
import 'package:project_app/screens/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_app/utils/impact.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: userController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: 70, right: 70, top: 15, bottom: 15),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: 
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100)
                  ),
                  labelText: 'Password',
                  // label: Center(
                  //   child: Text('Password')
                  // ),
                  hintText: 'Enter password',
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                ),
              ),
            ),

            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                onPressed: () {
                  loggingIn();
                },
                child: Text(
                  'Login',
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
          ],
        ),
      ),
    );
  }

  void loggingIn()async{
    //final url = 'https://impact.dei.unipd.it/bwthw/gate/v1/token/';
    final url = Impact.baseURL + Impact.tokenURL;
    final uri = Uri.parse(url);
    // NB: creo corpo per la richiesta: Metodo post richiede parametro body CORREGGERE CREDENZIALI
    final body = {'username': userController.text, 'password': passwordController.text};
    //Richiesta completa di uri e body
    final response = await http.post(uri, body: body);  
    //richiesta token è post: attenzione a inserire user e psw nella richiesta. body come parametro del metodo post
    // Controllo status code
    print(response.statusCode);

    if(response.statusCode == 200){

      final decodedResponse = jsonDecode(response.body); // conversione formato Json
      //print(decodedResponse['access']);

      //Interrogo SharedPreferences
      final credentials = await SharedPreferences.getInstance();

      // Salvo le credenziali
      credentials.setString('username', userController.text); 
      credentials.setString('password', passwordController.text); 

      // Salvo token d'accesso e di refresh
      credentials.setString('access', decodedResponse['access']); 
      credentials.setString('refresh', decodedResponse['refresh']); 

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    }
    else{
      ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Wrong email/password')));
    }
  }
}
