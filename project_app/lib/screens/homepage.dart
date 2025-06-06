
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
import 'package:project_app/utils/firebase.dart';


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
  
  bool firstLaunch = true;

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
    _checkFirstLauch();
    _loadDeliveries();
    // Prendere valore progress bar 
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
            title: Text(
              "Welcome to our App!",
              style: TextStyle(
                color: Colors.green
              ),
            ),
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
                  labelStyle: TextStyle(color: Colors.black),
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
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.green
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _toAboutUsPage(context),
                child: Text(
                  "See who we are",
                  style: TextStyle(
                    color: Colors.green
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
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
      )
      :
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<FirebaseDB>(
              builder: (context, data, child) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: data.deliveries.length,
                  itemBuilder: (context, index){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 10,),
                        Container( //Aggiunto container per abbellire i pacchi
                          width: MediaQuery.sizeOf(context).width - 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.all(Radius.circular(20)),                    
                          ),
                          
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${data.deliveries[index].address}, ${data.deliveries[index].packageType}, ${data.deliveries[index].start}'),                          
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                        //SizedBox(height: 60)
                      ],
                    );
                  },
                );
              },
            ),
            
            ElevatedButton(
              onPressed: () async {

                await Provider.of<FirebaseDB>(context, listen: false).fetchDeliveriesDB();

                print(Provider.of<FirebaseDB>(context, listen: false).deliveries[0].toString());
              }, 
              child: Text('Get data from firebase'),
            )
          ],
        )
      ),


      // body: Consumer<XP_notifier>
      
      // BNB and FAB
      bottomNavigationBar: CustomBottomAppBar(
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

            ListTile(
              trailing: Icon(Icons.settings, color: Colors.red, ),
              title: Text(
                'Da togliere (serve per provare)',
                style: TextStyle(color: Colors.red, ),
              ),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => OptionsPage())),
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
