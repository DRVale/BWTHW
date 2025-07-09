import 'package:flutter/material.dart';
import 'package:project_app/screens/homepage.dart';
import 'package:project_app/screens/loginpage.dart';
import 'package:project_app/utils/impact.dart';


class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Future.delayed(const Duration(seconds: 15), () => _checkLogin(context));
    Future.delayed(const Duration(seconds: 1), () => _checkLogin(context));
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 238),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/PastOn.gif', scale: 1.5, ),
            SizedBox(height: 2,),
            Text(
              'PastOn',
              style: TextStyle(
                color: Colors.green,
                fontSize: 50,
                fontWeight:FontWeight.bold, 
                fontFamily: 'Roboto' 
              ),
            ),
            SizedBox(height: 20,),
            Text(
              'Loading...', 
              style: TextStyle(
                color: Colors.green,
                fontSize: 11, 
              )
            )
          ]
        ) 
      )
    );
  }

  // Method for navigation SplashPage -> ExposurePage
  void _toHomePage(BuildContext context)  {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  HomePage()));
  }

  // Method for navigation SplashPage -> LoginPage
  void _toLoginPage(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => LoginPage())));
  } 

  // Method for checking if the user has still valid tokens
  // If yes, navigate to Homepage, if not, navigate to LoginPage
  void _checkLogin(BuildContext context) async {
    final result = await Impact().refreshTokens();
    if (result == 200) {
      _toHomePage(context);
    } else {
    _toLoginPage(context);
    }
  } //_checkLogin

}