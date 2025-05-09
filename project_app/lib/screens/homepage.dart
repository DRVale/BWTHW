import 'package:flutter/material.dart';
//import 'package:project_app/screens/counterpage.dart';
import 'package:project_app/screens/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_app/models/expandibletilelist.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routename = 'Homepage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(HomePage.routename),
        ),
      ),
      
      body: Center(
        child: ListView(
          children: [
            ExpandableListTile(
              packageType: "Piccolo",
              address: 'Via Roma 2',
              actions: [
                Text('Ciao'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 100,
                  children: [
                    Text('Address'),
                    Text('Modalità'),
                  ],
                ),
                ElevatedButton(onPressed: () {}, child: Text("Action 2")),
              ],
            ),
            ExpandableListTile(
              packageType: "Grande",
              address: 'Via Roma 15',
              actions: [
                ElevatedButton(onPressed: () {}, child: Text("Edit")),
                ElevatedButton(onPressed: () {}, child: Text("Delete")),
              ],
            ),
          ],
        )
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
              title: Text('Profile'),
              trailing: Icon(Icons.person),
              onTap: () => _toProfilePage(context),
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

      
      // CAMIARE CON CLASSE CUSTOM
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          print('Funziona');
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph),
            label: 'Graphs'
            
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'New delivery'
                        
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History'
            
          ),
          
        ]
      ),
    );
  } //build

  void _toLoginPage(BuildContext context) async {

    final logoutReset = await SharedPreferences.getInstance();
    await logoutReset.remove('username');
    await logoutReset.remove('password');
    await logoutReset.remove('access');
    await logoutReset.remove('refresh');

    //Pop the drawer first 
    Navigator.pop(context);
    //Then pop the HomePage
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }//_toCalendarPage

  void _toProfilePage(BuildContext context){
    //Pop the drawer first 
    Navigator.pop(context);
    //Then pop the HomePage
    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Counterpage(title: 'maracaibo')));
  }//_toCalendarPage


} //HomePage