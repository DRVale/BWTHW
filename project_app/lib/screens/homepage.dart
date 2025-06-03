
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
import 'package:project_app/widgets/deliverymethod.dart';


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
  String _username = '';
  Color  _headerColor = getRandomColor();

  //Inizializzazione lista progress bar 
  double xp = 0;
  final List<Checkpoint> checkpoints = [
  Checkpoint(xpRequired: 100, icon: Icons.star, label: '100 XP'),
  Checkpoint(xpRequired: 250, icon: Icons.military_tech, label: '250 XP'),
  Checkpoint(xpRequired: 500, icon: Icons.workspace_premium, label: '500 XP'),
  ];

  //Inizializzazione counter consegne; utilizzo una mappa dove memorizzo metodo-count
  int total = 0;
  Map<String, int> methodCounts = {};
  final methods = ['bici', 'corsa', 'camminata'];


  @override
  void initState(){
    super.initState();
    _loadUsername();
    _loadXP();
    _loadDeliveries();
    // Prendere valore progress bar 
  }

  Future<void> _loadUsername() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      _username = sp.getString('username') ?? 'User';
    });
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
    //await logoutReset.remove('XP');

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

  // Metodo per gestire, con le SP, il count delle consegne. Esiste una classe apposita, in deliverymethod
  Future<void> _loadDeliveries() async {
    final service = DeliveryStorage();
    final totalCount = await service.getTotalDeliveries();
    final methodMap = await service.getMethodCounts(methods);
    setState(() {
      total = totalCount;
      methodCounts = methodMap;
    });
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

      body: Center(
        child: 
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column( 
              children: [
              
                // ElevatedButton(
                //   onPressed: (){
                //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => OptionsPage()));
                //   },
                //   child: Text('Obtain distance data')
                // ),
            
                Consumer<DataProvider>(builder: (context, data, child) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [ 
                        SizedBox(height: 50),
                        XPProgressBar(
                          currentXP: 300, //data.xp ?? xp,
                          maxXP: 500,
                          checkpoints: checkpoints,
                        ),
                      ],
                    ),
                  );
                }),
            
                //Inserimento Counter delle corse: 
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red, // Colore del bordo
                      width: 2,           // Spessore del bordo
                    )
                  ),
                  height: 130,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('📦 Consegne totali: $total',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  
                      const SizedBox(height: 8),
                      ...methodCounts.entries.map((entry) => Text(
                            '${entry.key}: ${entry.value}',
                            style: const TextStyle(fontSize: 16),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),

      // body: Consumer<XP_notifier>
      
      // BNB and FAB
      bottomNavigationBar: CustomBottomAppBar(
             toPage1: () => _toGraphPage(context),
             toPage2: () => _toHistoryPage(context),
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