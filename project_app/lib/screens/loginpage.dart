import 'package:flutter/material.dart';
import 'package:project_app/screens/homepage.dart';
//import 'package:project_app/screens/HomePage.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_app/utils/impact.dart';
//import 'dart:convert';


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
      backgroundColor: const Color.fromARGB(255, 249, 244, 197),
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.only(
                left: 70, right: 70, top: 15, bottom: 15),
              child: TextField(
                textAlign: TextAlign.center,
                controller: userController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: Colors.green,width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green,width: 2.0),
                  ),
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.green),
                  hintText: 'Enter valid email ',
                  hintStyle: TextStyle(color: Colors.green),
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                )
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
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: Colors.green,width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green,width: 2.0),
                  ),
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.green),
                  // label: Center(
                  //   child: Text('Password')
                  // ),
                  hintText: 'Enter password',
                  hintStyle: TextStyle(color: Colors.green),
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                ),
              ),
            ),

            Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 107, 165, 109),
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final loginCode = await Impact().loggingIn(userController.text, passwordController.text); //await
                  if(loginCode == 200){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                  }else{
                    ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text('Wrong username or password')));
                  }
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
}
