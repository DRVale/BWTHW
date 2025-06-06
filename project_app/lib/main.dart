import 'package:flutter/material.dart';
//import 'package:project_app/screens/optionspage.dart';
//import 'package:project_app/screens/loginpage.dart';
//import 'package:project_app/screens/homepage.dart';
import 'package:project_app/screens/splash.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:project_app/providers/dataprovider.dart';
import 'package:project_app/utils/firebase.dart';

// For DB
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // demoProjectId: "demo-project-id",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DataProvider>(create: (context) => DataProvider()),
        ChangeNotifierProvider<FirebaseDB>(create: (context) => FirebaseDB()),
      ],
      child: MaterialApp(
        home: Splash(),
      ),
    );



    // return ChangeNotifierProvider(
    //   create: (context) => DataProvider(),
    //   child: 
    // );
    
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