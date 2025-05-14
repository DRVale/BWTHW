import 'package:flutter/material.dart';
//import 'package:project_app/screens/counterpage.dart';
import 'package:project_app/screens/loginPage.dart';
import 'package:project_app/screens/graphpage.dart';
import 'package:project_app/screens/historypage.dart';
import 'package:project_app/screens/canteenpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_app/models/customnavigationbar.dart';

class HomePage extends StatelessWidget {
  
  const HomePage({Key? key,}) : super(key: key);

  static const routename = 'Homepage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 250, 250, 238),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 250, 238),
        title: Center(
          child:
          Row(
            children: [
              Text('Ciao,  ', style: TextStyle(fontSize: 30, fontFamily: 'Roboto',fontWeight: FontWeight.bold, color: Colors.green,),),
              SizedBox(width: 5,),
              Icon(Icons.handshake_outlined, color: Colors.yellow,)
            ],
          )
          
        ),
      ),
      
      
      body: Container(
        child: CustomNavigationBar(
          goToPage1: () => _toGraphPage(context), 
          goToPage2: () => _toHistoryPage(context),
        ),
      ),
      floatingActionButton: ElevatedButton(
        child: Icon(Icons.add,size: 30,),
        onPressed: ()=> _toCanteenPage(context),
        onLongPress: (){
          ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('Go to delivery page')));
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          iconSize: 27,
          iconColor: Colors.white,
          backgroundColor: Colors.green,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 250, 250, 238),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container( // Refactored into a container so we can adjust the size of the header
              //height: 70,
              child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('Menu'),
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
              trailing: Icon(
                Icons.logout,
                color: Colors.red, 
                size: 15, weight: 10,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                ),
              ),
              onTap: () => _toLoginPage(context),
            ),
          ],
        ),
      ),
     
      // CAMIARE CON CLASSE CUSTOM
      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: (value) {
      //     print('Funziona');
      //   },
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.auto_graph),
      //       label: 'Graphs'
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.add),
      //       label: 'New delivery'
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.history),
      //       label: 'History'
      //     ),
      //   ]
      // ),
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

  void _toGraphPage(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => GraphPage()));
  }
  void _toHistoryPage(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HistoryPage()));
  }
  void _toCanteenPage(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CanteenPage()));
  }

} //HomePage