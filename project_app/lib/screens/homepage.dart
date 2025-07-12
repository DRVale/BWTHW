
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:project_app/screens/loginPage.dart';
import 'package:project_app/screens/canteenpage.dart';
import 'package:project_app/screens/optionspage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_app/widgets/custombottomappbar.dart';
import 'package:project_app/screens/profilepage.dart';
import 'package:project_app/screens/aboutuspage.dart';
import 'package:project_app/widgets/progressbar.dart';
import 'package:project_app/widgets/deliverymethod.dart';
import 'package:project_app/utils/firebase.dart';
import 'package:project_app/widgets/line_plot.dart';
import 'package:project_app/widgets/deliveryStorage&Counting.dart';
import 'package:intl/intl.dart';
import 'package:project_app/models/requesteddata.dart';


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
  int selected_delivery_idx = 0;

  Delivery? selectedDelivery;
  // Delivery selectedDelivery = list_of_deliveries[0];  IN FUTURO SARA' COSI'

  String _username = '';
  String surname = '';
  TextEditingController userController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();

  Color _headerColor = getRandomColor();
  
  bool firstLaunch = true;

  //PROGRESS BAR VARIABLES
  double xp = 0;

  final List<Checkpoint> checkpoints = [
  Checkpoint(xpRequired: 100, icon: Icons.icecream_outlined, label: '100 XP'),
  Checkpoint(xpRequired: 250, icon: Icons.dining_outlined, label: '250 XP'),
  Checkpoint(xpRequired: 500, icon: Icons.dining, label: '500 XP'),
  ];


  // DELIVERY COUNT 
  // Utilizzo una mappa dove memorizzo metodo-count
  int total = 0;
  Map<String, int> methodCounts = {};
  final methods = ['Bici', 'Corsa', 'Camminata'];
  final methods_en = ['Bike', 'Running', 'On Foot'];


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
      sp.getBool('FirstLauch') == null? firstLaunch = true : firstLaunch = true;
      // If the value in the SP is not null, then an access was made. 
      // If it is null, then it is the first launch of the app => set firstLaunch to true
    });
    sp.setBool('FirstLauch', true); 

  
    //if(firstLaunch) _toGraphPage(context);
    if(firstLaunch == true){
      showDialog(
       
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 250, 250, 238),
            title: Center(
              child: Text(
                "Welcome to our App!",
                style: TextStyle(
                  color: Colors.green
                ),
              ),
            ),
            //content: Center(child: Text('Is this the first time using PastOn? Tell us your personal information')),
            actions: [
              //SizedBox(height: 10,),
              Center(child: Text('Is this the first time using PastOn? Tell us your personal information',)),
              SizedBox(height: 30,),
              TextField(
                cursorColor: Colors.black54,
                textAlign: TextAlign.center,
                controller: userController,
                // onTap: ()async{
                //     await Provider.of<DataProvider>(context, listen: false).setName(context,userController.text);
                //   },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: Colors.black54,width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    //borderSide: BorderSide(color: Colors.green,width: 2.0),
                  ),
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.black54),
                  hintText: 'Enter your name!',
                  //hintStyle: TextStyle(color: Colors.green),
                  //prefixIcon: Icon(Icons.person,color: Colors.green,size: 17,),
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                )
              ),
              SizedBox(height: 10,),
              TextField(
                cursorColor: Colors.black54,
                textAlign: TextAlign.center,
                controller: surnameController,
                // onTap: ()async{
                //     await Provider.of<DataProvider>(context, listen: false).setSurname(context,surnameController.text);
                //   },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: Colors.black54,width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    //borderSide: BorderSide(color: Colors.green,width: 2.0),
                  ),
                  labelText: 'Surname',
                  labelStyle: TextStyle(color: Colors.black54),
                  hintText: 'Enter your surname!',
                  //hintStyle: TextStyle(color: Colors.green),
                  //prefixIcon: Icon(Icons.person,color: Colors.green,size: 17,),
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                )
              ),
              SizedBox(
                height: 10,
              ),

               Consumer<DataProvider>(builder: (context, data, child) {
                return
              TextField(
                  cursorColor: Colors.black54,
                  textAlign: TextAlign.center,
                  controller: birthdateController,
                  //readOnly: true,
                  onTap: ()async{
                    await Provider.of<DataProvider>(context, listen: false).pickDate(context);
                    birthdateController.text = data.first_birthdate!;
                  },
                  decoration: InputDecoration(
                    labelText: 'birthdate',//data.first_birthdate ?? birthdateController.text,
                    hintText: 'Insert your birthdate',
                    labelStyle: TextStyle(color: Colors.black54),
                    enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: Colors.black54,width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    //borderSide: BorderSide(color: Colors.green,width: 2.0),
                  ),
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  ),
              );
              }),

              SizedBox(height: 10,),
              
              TextButton(
                onPressed: () async {
                  if(userController.text.isNotEmpty && surnameController.text.isNotEmpty && birthdateController.text.isNotEmpty){
                    String birthdate = birthdateController.text;
                    SharedPreferences sp = await SharedPreferences.getInstance();
                    await sp.setString('username', userController.text);
                    await sp.setString('surname', surnameController.text);
                    await sp.setString('birthdate', birthdate);

                    setState(() {
                      _username = userController.text;                      
                  });

                  Navigator.pop(context); // Return to HomePage

                  }else{
                    ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text('All fields must be filled!')));
                  }
                },
                child: Text(
                  "Confirm",
                  style: TextStyle(
                    color: Colors.green
                  ),
                ),
              ),
            ],
          );
        },
      );

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 250, 250, 238),
            content: Container(
              width: 1000,
              child: AboutUsPage().build(context),
            ),
            
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

    // double? storedXP = sp.getDouble('XP');
    // double finalXP = storedXP ?? 0;
    double finalXP = sp.getDouble('XP') ?? 0;

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
    await logoutReset.remove('FirstLaunch');
    // Vedere se togliere anche firstLaunch (Per me si può rimuovere - Lorenz)

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
      // SE DA' PROBLEMI TOGLIERE
      resizeToAvoidBottomInset: false,
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
      
       SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column( 
            children: [
              SizedBox(height: 50),
              Center(child: DeliveryCounterPanel(total: Provider.of<FirebaseDB>(context, listen: false).totalDeliveries, perMethod: methodCounts)),
              SizedBox(height: 50,),
              Consumer<FirebaseDB>(builder: (context, data, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [ 
                    XPProgressBar(
                      currentXP: data.totalXP,
                      maxXP: 500,
                      checkpoints: checkpoints,
                    ),
                  ],
                );
              }),
              SizedBox(height: 10),
              Center(
                child: Row(
                  children: [
                    Container(
                      child: Text('Your Progress',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      )
                    ),
                    SizedBox(height: 10,),
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      iconSize: 40,
                      color: Colors.black54,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Rewards"),
                              content: Container(
                                width: double.maxFinite,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Riga 1
                                    Row(
                                      children: const [
                                        Icon(Icons.icecream, color: Colors.black54, size: 40,),
                                        SizedBox(width: 10),
                                        Text("100 XP: FREE dessert or coffee!"),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    // Riga 2
                                    Row(
                                      children: const [
                                        Icon(Icons.dining_outlined, color: Colors.black54, size: 40,),
                                        SizedBox(width: 10),
                                        Text("250 XP: FREE Small meal!"),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    // Riga 3
                                    Row(
                                      children: const [
                                        Icon(Icons.dining, color: Colors.black54, size: 40,),
                                        SizedBox(width: 10),
                                        Text("500 XP: FREE Complete meal!",)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text("Close",style: TextStyle(color: Colors.green),),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),   
            ],
          ),
        ),
      )
      :

      Consumer<FirebaseDB>(

        builder: (context, data, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Text('Select a delivery'),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    // shrinkWrap: true,
                    itemCount: methods_en.length,
                    itemBuilder: (context, index){
        
                      String selectedDeliveryMethod = '';
        
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 10),
                          InkWell(
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black54),
                                borderRadius: BorderRadius.all(Radius.circular(20)),                    
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  methods_en[index],
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            onTap: () async {
                              // Provider.of<FirebaseDB>(context, listen: false).getTrimpPerMin(data.deliveries[index]);
                              selectedDeliveryMethod = methods_en[index];
                              selected_delivery_idx = 0;

                              // Remove existing data
                              data.deliveries.clear();

                              await Provider.of<FirebaseDB>(context, listen: false).fetchDeliveriesDB(deliveryMethod: selectedDeliveryMethod);
                              Provider.of<FirebaseDB>(context, listen: false).getTrimpPerMin(data.deliveries[0]);
                            },
                          ),
                          SizedBox(width: 10),
                          //SizedBox(height: 60)
                        ],
                      );
                    },  
                  ),
                ),
                  
        
             
                  
                    Container(
                      width: MediaQuery.sizeOf(context).width - 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        
                        children: [
                          // Left Arrow Button
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selected_delivery_idx == 0? Colors.grey : Colors.green,
                              ),
                              borderRadius: BorderRadius.circular(50)
                            ),
                            child: IconButton(
                              iconSize: 20,
                              color: Color.fromARGB(255, 250, 250, 238),
                              onPressed: selected_delivery_idx > 0 ? (){
                                setState(() {
                                  if (selected_delivery_idx > 0) {
                                    selected_delivery_idx--;
                                  }
                                  selectedDelivery = data.deliveries[selected_delivery_idx];
                                  Provider.of<FirebaseDB>(context, listen: false).getTrimpPerMin(selectedDelivery!);
                                });
                              } : null, // Disable if at first item
                              icon: Icon(
                                Icons.arrow_back_ios_new,
                                color: selected_delivery_idx == 0? Colors.grey : Colors.green,
                              ),
                            ),
                          ),
                          // SizedBox(width: 20),
                      
                          Container(
                            // width: MediaQuery.sizeOf(context).width - 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green),
                              borderRadius: BorderRadius.all(Radius.circular(20)),                    
                            ),
                      
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: 
                              Text(
                                '${data.deliveries[selected_delivery_idx].address.split(',')[0]}, ${formatDateTime(data.deliveries[selected_delivery_idx].start)}',
                                style: TextStyle(
                                  color: Colors.black54
                                ),
                              ),
                            ),
                          ),
                      
                          // const SizedBox(width: 40),
                      
                          // Right Arrow Button
                      
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selected_delivery_idx == data.deliveries.length-1? Colors.grey : Colors.green,
                              ),
                              borderRadius: BorderRadius.circular(50)
                            ),
                            child: IconButton(
                              color: Color.fromARGB(255, 250, 250, 238),
                              // foregroundColor: Colors.green,
                              onPressed: selected_delivery_idx < data.deliveries.length - 1 ? (){
                                setState(() {
                                  if (selected_delivery_idx < data.deliveries.length - 1) {
                                    selected_delivery_idx++;
                                  }
                                  selectedDelivery = data.deliveries[selected_delivery_idx];
                                  Provider.of<FirebaseDB>(context, listen: false).getTrimpPerMin(selectedDelivery!);
                                });
                              } : null, // Disable if at first item
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: selected_delivery_idx == data.deliveries.length-1? Colors.grey : Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 250,
                        child: TrimpDataPlot(trimpData: data.trimp_per_min)
                      ),
                    ),
                  
        
              
              
              
              // builder: (context, data, child) {

              //   int selected_delivery_idx = 0;

              //   return Column(
              //     children: [
              //       SizedBox(
              //         height: 50,
              //         width: double.infinity,
              //         child: ListView.builder(
              //           scrollDirection: Axis.horizontal,
              //           shrinkWrap: true,
              //           itemCount: data.deliveries.length,
              //           itemBuilder: (context, index){
              //             return Row(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 InkWell(
              //                   child: Container( //Aggiunto container per abbellire i pacchi
              //                     // width: MediaQuery.sizeOf(context).width - 50,
              //                     decoration: BoxDecoration(
              //                       border: Border.all(color: Colors.black54),
              //                       borderRadius: BorderRadius.all(Radius.circular(20)),                    
              //                     ),

              //                     child: Padding(
              //                       padding: const EdgeInsets.all(8.0),
              //                       child: 
              //                       Text('${data.deliveries[index].address.split(',')[0]}, ${formatDateTime(data.deliveries[index].start)}'),
              //                     ),
              //                   ),
              //                   onTap: (){
              //                     // Provider.of<FirebaseDB>(context, listen: false).getTrimpPerMin(data.deliveries[index]);
              //                     selected_delivery_idx = index;
              //                     print(data.deliveries[selected_delivery_idx].start);

              //                     // CAMBIARE QUA, però in linea di massima funziona.

              //                     selectedDelivery = data.deliveries[index];
              //                     Provider.of<FirebaseDB>(context, listen: false).getTrimpPerMin(selectedDelivery!);
              //                     // Now make the firebase query to get the data of a specific delivery

                    
                    
              //                     // Select the appropriate delivery or specific delivery data
              //                   },
              //                 ),
              //                 SizedBox(
              //                   width: 20,
              //                 ),
              //                 //SizedBox(height: 60)
              //               ],
              //             );
              //           },
              //         ),
              //       ),
              //       Container(
              //         // color: Colors.amber,
              //         height: 250,
              //         child: TrimpDataPlot(trimpData: data.trimp_per_min),
              //       )
              //     ],
              //   );
          ],
        )
      );
        },),


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
            onPressed: (){
              _toCanteenPage(context);
            },
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

String formatDateTime(String dateString){

  DateTime date = DateTime.parse(dateString);

  // Get month and year
  final monthYearFormatter = DateFormat('MMMM yyyy');
  final monthYear = monthYearFormatter.format(date);

  // Get the day 
  final day = date.day;

  String ordinalSuffix = '';

  switch (day % 10) {
    case 1:
      ordinalSuffix = 'st';
    case 2:
      ordinalSuffix = 'nd';
    case 3:
      ordinalSuffix = 'rd';
    default:
      ordinalSuffix = 'th';
  }
  if (day >= 11 && day <= 13) {
    ordinalSuffix = 'th';
  }


  return '${monthYear.split(' ')[0]} ${day}$ordinalSuffix ${monthYear.split(' ')[1]}';

}



