import 'package:flutter/material.dart';
import 'package:project_app/screens/loginPage.dart';
import 'package:project_app/screens/canteenpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_app/widgets/custombottomappbar.dart';
import 'package:project_app/screens/profilepage.dart';
import 'package:project_app/screens/aboutuspage.dart';
import 'package:project_app/widgets/progressbar.dart';
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

  String _username = '';
  String surname = '';
  TextEditingController userController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();
  
  bool firstLaunch = true;

  //PROGRESS BAR VARIABLES
  // double xp = 0;

  final List<Checkpoint> checkpoints = [
  Checkpoint(xpRequired: 100, icon: Icons.icecream_outlined, label: '100 XP'),
  Checkpoint(xpRequired: 250, icon: Icons.dining_outlined, label: '250 XP'),
  Checkpoint(xpRequired: 500, icon: Icons.dining, label: '500 XP'),
  ];


  // DELIVERY COUNT 
  int total = 0;
  final methods = ['Bici', 'Corsa', 'Camminata'];
  final methods_en = ['Bike', 'Running', 'On Foot'];


  @override
  void initState(){
    super.initState();
    _loadUsername();
    _checkFirstLauch();
  }

  Future<void> _checkFirstLauch() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sp.getBool('FirstLauch') == null? firstLaunch = true : firstLaunch = false;
      // If the value in the SP is not null, then an access was made. 
      // If it is null, then it is the first launch of the app => set firstLaunch to true
    });
    sp.setBool('FirstLauch', false); 

  
    if(firstLaunch){
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          String? errorMessage;

          return StatefulBuilder(
            builder: (context, setStateDialog) {
              return AlertDialog(
                backgroundColor: const Color.fromARGB(255, 250, 250, 238),
                title: Center(
                  child: Text(
                    "Welcome to our App!",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                actions: [
                  Center(
                    child: Text(
                      'Is this the first time using PastOn? Tell us your personal information',
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    cursorColor: Colors.black54,
                    textAlign: TextAlign.center,
                    controller: userController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: const BorderSide(color: Colors.black54, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(),
                      labelText: 'Name',
                      labelStyle: const TextStyle(color: Colors.black54),
                      hintText: 'Enter your name!',
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    cursorColor: Colors.black54,
                    textAlign: TextAlign.center,
                    controller: surnameController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: const BorderSide(color: Colors.black54, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(),
                      labelText: 'Surname',
                      labelStyle: const TextStyle(color: Colors.black54),
                      hintText: 'Enter your surname!',
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Consumer<DataProvider>(
                    builder: (context, data, child) {
                      return TextField(
                        cursorColor: Colors.black54,
                        textAlign: TextAlign.center,
                        controller: birthdateController,
                        onTap: () async {
                          await Provider.of<DataProvider>(context, listen: false).pickDate(context);
                          birthdateController.text = data.first_birthdate!;
                        },
                        decoration: InputDecoration(
                          labelText: 'Birthdate',
                          hintText: 'Insert your birthdate',
                          labelStyle: const TextStyle(color: Colors.black54),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: const BorderSide(color: Colors.black54, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(),
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                        ),
                      );
                    },
                  ),
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () async {
                      if (userController.text.isNotEmpty &&
                          surnameController.text.isNotEmpty &&
                          birthdateController.text.isNotEmpty) {
                        String birthdate = birthdateController.text;
                        SharedPreferences sp = await SharedPreferences.getInstance();
                        await sp.setString('username', userController.text);
                        await sp.setString('surname', surnameController.text);
                        await sp.setString('birthdate', birthdate);

                        setState(() {
                          _username = userController.text;
                        });

                        Navigator.pop(context); // Pop the dialog

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Saved!')),
                        );
                      } else {
                        setStateDialog(() {
                          errorMessage = "All fields must be filled!";
                        });
                      }
                    },
                    child: const Text(
                      "Confirm",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              );
            },
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


  Future<void> _toLoginPage(BuildContext context) async {
    final logoutReset = await SharedPreferences.getInstance();

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

  void _toCanteenPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CanteenPage()));
  }

   void _toAboutUsPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutUsPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              SizedBox(height: 30),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text('Your Progress',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      )
                    ),
                    SizedBox(height: 10,),
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      iconSize: 30,
                      color: Colors.black54,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: const Color.fromARGB(255, 250, 250, 238),
                              title: Center(child: const Text("Rewards", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold))),
                              content: Container(
                                width: double.maxFinite,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 15),
                                    Row(
                                      children: const [
                                        Icon(Icons.icecream, color: Color.fromARGB(255, 235, 255, 59), size: 25,),
                                        SizedBox(width: 10),
                                        Text("FREE dessert or coffee!"),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    Row(
                                      children: const [
                                        Icon(Icons.dining_outlined, color: Color.fromARGB(255, 146, 236, 44), size: 25,),
                                        SizedBox(width: 10),
                                        Text("FREE small meal!"),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    Row(
                                      children: const [
                                        Icon(Icons.dining, color: Color.fromARGB(255, 31, 206, 19), size: 25,),
                                        SizedBox(width: 10),
                                        Text("FREE complete meal!",)
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
              SizedBox(height: 20,),
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
              SizedBox(height: 30),
              Center(child: DeliveryCounterPanel(total: Provider.of<FirebaseDB>(context, listen: false).totalDeliveries)),
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
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            'Select a delivery',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          iconSize: 25,
                          color: Colors.black54,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: const Color.fromARGB(255, 250, 250, 238),
                                  title: Center(child: Text("TRIMP legend", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold))),
                                  content: Container(
                                    width: double.maxFinite,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(text: 'TRIMP < 1: ',style: TextStyle( color: Colors.black54, fontWeight: FontWeight.bold,)),
                                              TextSpan(text: 'Low intensity', style: TextStyle(  color: Colors.black54)),
                                            ]
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(text: '1 < TRIMP < 2: ',style: TextStyle( color: Colors.black54, fontWeight: FontWeight.bold,)),
                                              TextSpan(text: 'Medium intensity', style: TextStyle(  color: Colors.black54)),
                                            ]
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(text: '2 < TRIMP: ',style: TextStyle( color: Colors.black54, fontWeight: FontWeight.bold,)),
                                              TextSpan(text: 'High intensity', style: TextStyle(  color: Colors.black54)),
                                            ]
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text("Close",style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold,), ),
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
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 50,
                  child: Row( 
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(methods_en.length, (index){
                    String selectedDeliveryMethod = '';
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                              selectedDeliveryMethod = methods_en[index];
                              selected_delivery_idx = 0;

                              // Remove existing data
                              data.deliveries.clear();

                              await Provider.of<FirebaseDB>(context, listen: false).fetchDeliveriesDB(deliveryMethod: selectedDeliveryMethod);
                              if(Provider.of<FirebaseDB>(context, listen: false).deliveries.length > 0) Provider.of<FirebaseDB>(context, listen: false).getTrimpPerMin(data.deliveries[0]);
                            },
                          ),
                          SizedBox(width: 10),
                        ],
                      );
                    },  
                  ),
                ),
              ),

              SizedBox(height: 20),
                  Container(
                    width: MediaQuery.sizeOf(context).width - 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,                        
                      children: [
                        // Left Arrow Button
                        Container(
                          height: 38,
                          width: 38,
                          child: IconButton(
                            iconSize: 25,
                            color: Color.fromARGB(255, 250, 250, 238),
                            onPressed: selected_delivery_idx > 0 ? (){
                              setState(() {
                                if (selected_delivery_idx > 0) {
                                  selected_delivery_idx--;
                                }
                                selectedDelivery = data.deliveries[selected_delivery_idx];
                                Provider.of<FirebaseDB>(context, listen: false).getTrimpPerMin(selectedDelivery!);
                              });
                            } : null,
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              color: selected_delivery_idx == 0? Colors.grey : Colors.green,
                            ),
                          ),
                        ),
                        Container(
                          width: 225,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.all(Radius.circular(20)),                    
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(data.deliveries.length == 0? '' :
                                  '${data.deliveries[selected_delivery_idx].address.split(',')[0]},',
                                  style: TextStyle(
                                    color: Colors.black54
                                  ),
                                ),
                                Text(data.deliveries.length == 0? '' :
                                  formatDateTime(data.deliveries[selected_delivery_idx].start),
                                  style: TextStyle(
                                    color: Colors.black54
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Right Arrow Button
                        Container(
                          height: 38,
                          width: 38,
                          child: IconButton(
                            iconSize: 25,
                            color: Color.fromARGB(255, 250, 250, 238),
                            onPressed: selected_delivery_idx < data.deliveries.length - 1 ? (){
                              setState(() {
                                if (selected_delivery_idx < data.deliveries.length - 1) {
                                  selected_delivery_idx++;
                                }
                                selectedDelivery = data.deliveries[selected_delivery_idx];
                                Provider.of<FirebaseDB>(context, listen: false).getTrimpPerMin(selectedDelivery!);
                              });
                            } : null,
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: selected_delivery_idx == data.deliveries.length-1? Colors.grey : Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 250,
                      child: TrimpDataPlot(trimpData: data.deliveries.length > 0? data.trimp_per_min : [])
                    ),
                  ),
                ],
              )
            );
          },
        ),

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
              decoration: BoxDecoration(color: Colors.green),
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
              trailing: Icon(Icons.logout, color: Colors.red, ),
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.red, ),
              ),
              onTap: () async => await _toLoginPage(context),
            ),

            ListTile(
              trailing: Icon(Icons.settings, color: Colors.black54, ),
              title: Text(
                'DEBUG: remove 1 delivery',
                style: TextStyle(color: Colors.black54, ),
              ),
              onTap: () {
                Provider.of<FirebaseDB>(context, listen: false).removeDeliveries();
                // delete one delivery
              },
            ),
          ],
        ),
      ),
    );
  }
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



