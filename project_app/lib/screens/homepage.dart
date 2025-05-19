
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:project_app/screens/loginPage.dart';
import 'package:project_app/screens/graphpage.dart';
import 'package:project_app/screens/historypage.dart';
import 'package:project_app/screens/canteenpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_app/models/customnavigationbar.dart';
import 'package:project_app/screens/profilepage.dart';
import 'package:project_app/screens/aboutuspage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routename = 'Homepage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _username = '';
  Color  _headerColor = getRandomColor();

  @override
  void initState() {
    super.initState();
    _loadUsername();

    // Prendere valore progress bar 
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'User';
    });
  }

  void _toLoginPage(BuildContext context) async {
    final logoutReset = await SharedPreferences.getInstance();
    await logoutReset.remove('username');
    await logoutReset.remove('password');
    await logoutReset.remove('access');
    await logoutReset.remove('refresh');

    Navigator.pop(context);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void _toProfilePage(BuildContext context) async {
    Navigator.pop(context);
    final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>  ProfilePage()),); 
    if(result == true) {
      _loadUsername();
    }
  }

  void _toGraphPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => GraphPage()));
  }

  void _toHistoryPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HistoryPage()));
  }

  void _toCanteenPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CanteenPage()));
  }

   void _toAboutUsPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutUsPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 238),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 250, 238),
        title: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Hello, $_username',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Roboto',
                  
                  color: Colors.green,
                ),
              ),
              SizedBox(width: 5),
              Icon(Icons.handshake_outlined, color: Colors.yellow),
            ],
          ),
        ),
      ),
      body: 
          //Consumer<XP_notifier>
          CustomNavigationBar(
            goToPage1: () => _toGraphPage(context),
            goToPage2: () => _toHistoryPage(context),
          ),
        
      
      // FARE CUSTOM BOTTOM NAVIGATION BAR
      floatingActionButton: ElevatedButton(

        child: Icon(Icons.add, size: 40, color: Colors.black54,),
        onPressed: () => _toCanteenPage(context),
        onLongPress: () {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text('Go to delivery page')));
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
          backgroundColor: Colors.green,
          
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 250, 250, 238),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: _headerColor),
              child: Center(
                child: 
                Text(_username.isNotEmpty ? _username[0].toUpperCase(): '',
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                )
              )
              
            ),
            ListTile(
              title: Text('Profile',style: TextStyle(color: Colors.black54),),
              trailing: Icon(Icons.person, color: Colors.black54,),
              onTap: () => _toProfilePage(context),
            ),
            ListTile(
              title: Text('About us',style: TextStyle(color: Colors.black54),),
              trailing: Icon(Icons.group,color: Colors.black54,),
              onTap: () => _toAboutUsPage(context),
            ),
            ListTile(
              trailing: Icon(Icons.logout, color: Colors.black54, ),
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.black54, ),
              ),
              onTap: () => _toLoginPage(context),
            ),
            
            
          ],
        ),
      ),
    );
  }
}

Color getRandomColor(){
  final random = Random();
  return Color.fromARGB(255,
  random.nextInt(256),
  random.nextInt(256),
  random.nextInt(256),
  );
}

double getXP(String deliveryMethod, int distance, double speed){

  double scoreCamminata = 0;
  double scoreCorsa = 0;
  double scoreBici = 0;
  double distanceWeight = 0;
  double speedWeight = 0;

  // Consider different ranges for "Corsa", "Camminata", "Bici"
  if(deliveryMethod == 'Camminata'){
    if(distance < 1500) distanceWeight = 0.33;
    if(distance > 1500 && distance < 3000) distanceWeight = 0.66;
    if(distance > 3000) distanceWeight = 1;

    if(speed < 1.5) speedWeight = 0.33;
    if(speed > 1.5 && speed < 3) speedWeight = 0.66;
    if(speed > 3) speedWeight = 1;

    scoreCamminata = distanceWeight * speedWeight;
  }

  if(deliveryMethod == 'Corsa'){
    if(distance < 2000) distanceWeight = 0.33;
    if(distance > 2000 && distance < 5000) distanceWeight = 0.66;
    if(distance > 5000) distanceWeight = 1;

    // Convert speed into min/km
    speed = 60 / speed;

    if(speed > 8) speedWeight = 0.33;
    if(speed > 5 && speed < 8) speedWeight = 0.66;
    if(speed < 5) speedWeight = 1;

    scoreCorsa = distanceWeight * speedWeight;
  }

  if(deliveryMethod == 'Bici'){
    if(distance < 3000) distanceWeight = 0.33;
    if(distance > 3000 && distance < 6000) distanceWeight = 0.66;
    if(distance > 6000) distanceWeight = 1;

    if(speed < 10) speedWeight = 0.33;
    if(speed > 10 && speed < 16) speedWeight = 0.66;
    if(speed > 16) speedWeight = 1;

    scoreBici = distanceWeight * speedWeight;
  }

  double xp = scoreCamminata + scoreCorsa * 1.5 + scoreBici;
  return xp;
}
