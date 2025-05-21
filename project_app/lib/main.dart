import 'package:flutter/material.dart';
//import 'package:project_app/screens/optionspage.dart';
//import 'package:project_app/screens/loginpage.dart';
//import 'package:project_app/screens/homepage.dart';
import 'package:project_app/screens/splash.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:project_app/screens/boxpage.dart';
import 'package:project_app/providers/dataprovider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: MaterialApp(
        home: Splash(),
      ),
    );
    
    // return MaterialApp(

    //   home: ChangeNotifierProvider(
    //     create: (context) => DataProvider(),
    //     child: Splash()
    //   )

    //   // Username: grWTWvehjO
    //   // Password: 12345678!
    // );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return ChangeNotifierProvider<XP_notifier>(
  //     create: (context) => XP_notifier(),
  //     child: Consumer<XP_notifier>(
  //       builder: (context, themeProvider, child) => MaterialApp(
  //     // invece di un builder normale utilizzo un future builder
  //         home: Splash()

  //     // Username: grWTWvehjO
  //     // Password: 12345678!
  //       )
  //     )
  //   );
  // }
}