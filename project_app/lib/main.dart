import 'package:flutter/material.dart';
import 'package:project_app/screens/splash.dart';
import 'package:provider/provider.dart';
import 'package:project_app/providers/dataprovider.dart';
import 'package:project_app/utils/firebase.dart';

// For DB
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
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
  }
}