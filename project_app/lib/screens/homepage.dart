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
                'Ciao, $_username',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(width: 5),
              Icon(Icons.handshake_outlined, color: Colors.yellow),
            ],
          ),
        ),
      ),
      body: CustomNavigationBar(
        goToPage1: () => _toGraphPage(context),
        goToPage2: () => _toHistoryPage(context),
      ),
      floatingActionButton: ElevatedButton(
        child: Icon(Icons.add, size: 30, color: Colors.white,),
        onPressed: () => _toCanteenPage(context),
        onLongPress: () {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text('Go to delivery page')));
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
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
              title: Text('Profile'),
              trailing: Icon(Icons.person),
              onTap: () => _toProfilePage(context),
            ),
            ListTile(
              title: Text('About us'),
              trailing: Icon(Icons.group),
              onTap: () => _toAboutUsPage(context),
            ),
            ListTile(
              trailing: Icon(Icons.logout, color: Colors.red, size: 15),
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.red, fontSize: 15),
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
/*
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

} //HomePage */