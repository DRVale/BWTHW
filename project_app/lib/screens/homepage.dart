import 'package:flutter/material.dart';
//import 'package:project_app/screens/counterpage.dart';
import 'package:project_app/screens/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routename = 'Homepage';

  @override
  Widget build(BuildContext context) {

    print('${HomePage.routename} built');

    return Scaffold(
      appBar: AppBar(
        title: Text(HomePage.routename),
      ),
      
      body: Center(
          child: Text('login_flow'),
        ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('login_flow'),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () => _toLoginPage(context),
            ),
            ListTile(
              leading: Icon(Icons.plus_one),
              title: Text('Counterpage'),
              onTap: () => _toCounterPage(context),
            ),
          ],
        ),
      ),
    );
  } //build

  void _toLoginPage(BuildContext context)async{

    final logoutReset = await SharedPreferences.getInstance();
    await logoutReset.remove('username');
    await logoutReset.remove('password');

    //Pop the drawer first 
    Navigator.pop(context);
    //Then pop the HomePage
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }//_toCalendarPage

  void _toCounterPage(BuildContext context){
    //Pop the drawer first 
    Navigator.pop(context);
    //Then pop the HomePage
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Counterpage(title: 'maracaibo')));
  }//_toCalendarPage

  // ciao
} //HomePage