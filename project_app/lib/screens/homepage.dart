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
          child: Text('')
        ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container( // Refactored into a container so we can adjust the size of the header
              //height: 70,
              child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('Drawer_name'),
                  // INCLUDERE IMMAGINE DEL PROFILO O QUALCOSA CHE CENTRI CON L'UTENTE
                ),
            ),
            
            ListTile(
              //leading: Icon(Icons.plus_one),
              title: Text('Counterpage'),
              trailing: Icon(Icons.arrow_left),
              onTap: () => _toCounterPage(context),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red
                ),
              ),
              onTap: () => _toLoginPage(context),
            ),
          ],
        ),
      ),
    );
  } //build

  void _toLoginPage(BuildContext context) async {

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
    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Counterpage(title: 'maracaibo')));
  }//_toCalendarPage


} //HomePage