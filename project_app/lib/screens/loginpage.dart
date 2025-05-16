import 'package:flutter/material.dart';
import 'package:project_app/screens/homepage.dart';
//import 'package:project_app/screens/HomePage.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_app/utils/impact.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      backgroundColor: const Color.fromARGB(255, 250, 250, 238),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Image.asset('assets/logo_nome.png', scale: 1, ),
            SizedBox(height: 30,),
            Text('Welcome', textAlign: TextAlign.left, style: TextStyle(color: Colors.green),),
            SizedBox(height: 5,),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.only(
                left: 70, right: 70, top: 15, bottom: 15),
              child: TextField(
                cursorColor: Colors.black,
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
                  prefixIcon: Icon(Icons.person,color: Colors.green,size: 17,),
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                )
              ),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.only(
                left: 70, right: 70, top: 15, bottom: 15),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: 
              TextField(
                cursorColor: Colors.black,
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
                  prefixIcon: Icon(Icons.password,color: Colors.green,size: 17,),
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 107, 165, 109),
                  foregroundColor: Colors.black54,
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
                child: Row(
                  children: [
                    Text('Login', style: TextStyle(fontSize: 13),),
                    SizedBox(width: 2 ),
                    Icon(Icons.login,size: 14,),
                  ],
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
