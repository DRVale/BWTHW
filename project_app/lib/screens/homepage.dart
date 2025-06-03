
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:project_app/screens/loginPage.dart';
import 'package:project_app/screens/graphpage.dart';
import 'package:project_app/screens/historypage.dart';
import 'package:project_app/screens/canteenpage.dart';
import 'package:project_app/screens/optionspage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_app/widgets/custombottomappbar.dart';
import 'package:project_app/screens/profilepage.dart';
import 'package:project_app/screens/aboutuspage.dart';
import 'package:project_app/widgets/progressbar.dart';


// PROVA PER PROVIDER
import 'package:provider/provider.dart';
import 'package:project_app/providers/dataprovider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routename = 'Homepage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int bodyIndex = 0;
  
  String _username = '';
  TextEditingController userController = TextEditingController();

  Color  _headerColor = getRandomColor();

  //Inizializzazione lista progress bar 
  double xp = 0;

  bool firstLaunch = true;

  final List<Checkpoint> checkpoints = [
  Checkpoint(xpRequired: 100, icon: Icons.star, label: '100 XP'),
  Checkpoint(xpRequired: 250, icon: Icons.military_tech, label: '250 XP'),
  Checkpoint(xpRequired: 500, icon: Icons.workspace_premium, label: '500 XP'),
  ];

  @override
  void initState(){
    super.initState();
    _checkFirstLauch();
    _loadUsername();
    _loadXP();
    // Prendere valore progress bar 
  }

  Future<void> _loadUsername() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      _username = sp.getString('username') ?? 'User';
    });
  }

  Future<void> _checkFirstLauch() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sp.getBool('FirstLauch') == null? firstLaunch = true : firstLaunch = false;
      // If the value in the SP is not null, then an access was made. 
      // If it is null, then it is the first launch of the app => set firstLaunch to true
    });
    sp.setBool('FirstLauch', false);

    //if(firstLaunch) _toGraphPage(context);
    if(firstLaunch){
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // scrollable: true,
            title: Text("Welcome to our App!"),
            content: Text('Is this the first time using PastOn? Tell us your name'),
            actions: [
              TextField(
                cursorColor: Colors.black,
                textAlign: TextAlign.center,
                controller: userController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    //borderSide: BorderSide(color: Colors.green,width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    //borderSide: BorderSide(color: Colors.green,width: 2.0),
                  ),
                  labelText: 'Username',
                  //labelStyle: TextStyle(color: Colors.green),
                  hintText: 'Enter your username!',
                  //hintStyle: TextStyle(color: Colors.green),
                  //prefixIcon: Icon(Icons.person,color: Colors.green,size: 17,),
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                )
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    _username = userController.text;
                  });

                  SharedPreferences sp = await SharedPreferences.getInstance();
                  sp.setString('username', _username);

                  Navigator.pop(context); // Return to HomePage
                },
                child: Text("OK"),
              ),
              TextButton(
                onPressed: () => _toAboutUsPage(context),
                child: Text("See who we are"),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _loadXP() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    double? storedXP = sp.getDouble('XP');
    double finalXP = storedXP ?? 0;

    await sp.setDouble('XP', finalXP);

    setState(() {
      // If XP is null (it was never initialized in the SP) we set it to zero and save it in the SP
      xp = finalXP;
      //sp.setDouble('XP', xp);
    });

  }

  Future<void> _toLoginPage(BuildContext context) async {
    final logoutReset = await SharedPreferences.getInstance();

    // Ho tolto i remove di Username e XP: rimane salvato il tuo nome alrimenti torna USER,
    // poi rimangono XP altrimenti la barra si azzera quando fai login appena dopo una nuova consegna. 

    //await logoutReset.remove('username');
    await logoutReset.remove('password');
    await logoutReset.remove('access');
    await logoutReset.remove('refresh');
    await logoutReset.remove('XP');
    await logoutReset.remove('FirstLaunch');
    // Vedere se togliere anche firstLaunch

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
      extendBody: true,
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


      body: bodyIndex == 0 ?      
      Center(
        child: Column(
          children: [

            // Check if it is the first launch of the app
            // If it is, tutorial and about us 

            // Check if username is in shared preferences
            // If not, go to profile page and set the name

          
            ElevatedButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => OptionsPage()));
              },
              child: Text('Obtain distance data')
            ),

            Consumer<DataProvider>(builder: (context, data, child) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [ 
                    SizedBox(height: 50),
                    XPProgressBar(
                      currentXP: data.xp ?? xp,
                      maxXP: 500,
                      checkpoints: checkpoints,
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      )
      : // Depends on the index
      Container(color: Colors.amber),      


      // body: Consumer<XP_notifier>
      
      // BNB and FAB
      bottomNavigationBar: 
      // CustomBottomAppBar(
      //        toPage1: () => _toGraphPage(context),
      //        toPage2: () => _toHistoryPage(context),
      //      ),

      CustomBottomAppBar(
        tabnames: ['HOME', 'HISTORY'],
        currentIndex: bodyIndex,
        callback: (idx) => setState(() {
          bodyIndex = idx;
        }),
      ), 

      floatingActionButton: Container(
        height: 100,
        width: 100,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () => _toCanteenPage(context),
            backgroundColor: Colors.green,
            splashColor: Colors.yellow,
            shape: CircleBorder(),
            child: Icon(Icons.add, size: 40, color: Colors.black54,)
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
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
              onTap: () async => await _toLoginPage(context),
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