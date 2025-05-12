import 'package:flutter/material.dart';
import 'package:project_app/screens/homepage.dart';
import 'package:project_app/screens/loginpage.dart';
import 'package:project_app/utils/impact.dart';


class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () => _checkLogin(context));
    return Scaffold(
        body: Center(
            child: Column(
              children: [
                Image.asset('assets/PastOn.png',scale: 4,),
                Text('Loading')
              ]
            ) 
            )
            );
  }

  // Method for navigation SplashPage -> ExposurePage
  void _toHomePage(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
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