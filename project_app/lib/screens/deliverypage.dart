import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_app/models/requesteddata.dart';
import 'package:project_app/screens/homepage.dart';
import 'package:project_app/providers/dataprovider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:project_app/widgets/deliverymethod.dart';
import 'package:project_app/utils/firebase.dart';

import 'package:project_app/widgets/deliveryStorage&Counting.dart';

import 'package:url_launcher/url_launcher.dart'; 
import 'dart:convert'; 


class DeliveryPage extends StatefulWidget {

  final String canteen;
  final String address;
  final String packageType;

  const DeliveryPage({
    super.key, 
    required this.canteen,
    required this.address, 
    required this.packageType
  });


  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {

  bool isTextVisible = true;

  Stopwatch _stopwatch = Stopwatch();
  String _elapsedTime = "00:00:00";
  Timer? _timer;
  String? startDate;
  

  @override
  void initState() {
    super.initState();
    //_startTimer();
    _startStopwatch();
    
  }
   

  void _startStopwatch() {
    _stopwatch.start();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime = '0${_stopwatch.elapsed.toString().substring(0, 7)}';
      });
    });

    DateTime start_date = DateTime.now().subtract(Duration(days: 1));
    //startDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$startDate');
    startDate = DateFormat("yyyy-MM-dd hh:mm:ss").format(start_date);
  }

  // void _startTimer() {
  //   _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     setState(() {
  //       _seconds++;
  //     });
  //   });
  //   DateTime start_date = DateTime.now().subtract(Duration(days: 1));
  //   //startDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$startDate');
  //   startDate = DateFormat("yyyy-MM-dd hh:mm:ss").format(start_date);
  // }

  void stop() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // DateTime _timeAcquisition(){
  //   //Prendo momento di inizio 
  //   DateTime startDate = DateTime.now().subtract(Duration(days: 1));
  //   startDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$startDate');
  //   //String start_Date = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
  //   return startDate;
  // }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor:  const Color.fromARGB(255, 250, 250, 238),
    body: Stack(
      children: [
        

        // Contenuto sovrapposto
        Positioned.fill(
          child: SafeArea(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  
                  ),
                
                Expanded(
                  
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                          child: Container(
                            
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black54,
                                width: 2.0,
                              ),
                              color: const Color.fromARGB(255, 250, 250, 238),
                              borderRadius: BorderRadius.all(Radius.circular(40)),                    
                            ),
                            
                            // padding: const EdgeInsets.all(16.0),
                            //padding: const EdgeInsets.symmetric(
                             // horizontal: 16,
                              //vertical: 5
                           // ),
                            child: Column(
                              children: [
                                SizedBox(height: 20,),
                                Icon(Icons.panorama_fisheye_outlined, color: Colors.black54, size:  17, ),
                                SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                  Icon(Icons.fastfood_outlined, color: Colors.black54, size:  17, ),
                                  SizedBox(width: 5),
                                  Text("Time to deliver - your box is waiting", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 17),)
                                ]),
                                SizedBox(height: 40,),
                                Text('Destination: ${widget.address}', style: TextStyle(fontSize: 13, color: Colors.black54, )),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Click to open in Google Maps: ", style: TextStyle(color: Colors.black54,  fontSize: 13),),
                                    SizedBox(width: 5),
                                    IconButton(
                                      icon: Icon(Icons.fmd_good_outlined, color: Colors.black54, size:  20, ),
                                      onPressed: () async => await launchGoogleMapsSearch(context, widget.address),
                                    ),
                                  ]
                                ),

                                
                                const SizedBox(height: 15),
                                Text("Time: $_elapsedTime", style: const TextStyle(fontSize: 17, color: Colors.black54, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 107, 165, 109),
                                  foregroundColor: Colors.black54,),
                                  onPressed: () async {
                                    stop();
                          
                                    // DELETE BOX
                                    // await Provider.of<FirebaseDB>(context, listen: false).removeBox(widget.canteen, widget.address, widget.packageType);
                          
                                    // Va fatto per tutti i dati
                                    //Provider.of<DataProvider>(context, listen: false).clearDistanceData();
                          
                                    DateTime endTime = DateTime.now().subtract(Duration(days: 1));
                                    String endDate = DateFormat("yyyy-MM-dd hh:mm:ss").format(endTime);
                          
                                    // String startDate_prova = '2023-05-13 10:00:00';
                                    // String endDate_prova = '2023-05-13 10:30:00';
                          
                                    // CORSA
                                    String startDate_prova = '2023-05-28 11:45:00';
                                    String endDate_prova = '2023-05-28 12:15:00';
                          
                          
                                    // await Provider.of<DataProvider>(context, listen: false).delivery(startDate!, endDate);
                                    await Provider.of<DataProvider>(context, listen: false).delivery(startDate_prova, endDate_prova);

                                    String deliveryMethod = Provider.of<DataProvider>(context, listen: false).getDeliveryMethod();
                                    
                                    RestingHR deliveryRestingHR = Provider.of<DataProvider>(context, listen: false).restingHR!;
                                    List<Distance> deliveryDistances = Provider.of<DataProvider>(context, listen: false).distances;
                                    List<HeartRate> deliveryHeartRate = Provider.of<DataProvider>(context, listen: false).heartRate;

                                    Delivery newDelivery = Delivery(
                                      canteen: widget.canteen, 
                                      address: widget.address, 
                                      packageType: widget.packageType, 
                                      deliveryMethod: deliveryMethod, 
                                      start: startDate_prova, 
                                      end: endDate_prova, 
                                      distances: deliveryDistances, 
                                      heartRate: deliveryHeartRate, 
                                      restingHR: deliveryRestingHR
                                    );
                                    

                                    int xpIncrement = Provider.of<FirebaseDB>(context, listen: false).updateXPtrimp(newDelivery);
                          
                                    await Provider.of<FirebaseDB>(context, listen: false).addDeliveryDB(newDelivery.canteen, newDelivery.address, newDelivery.packageType, newDelivery.deliveryMethod, newDelivery.start, newDelivery.end, newDelivery.restingHR, newDelivery.distances, newDelivery.heartRate);
                          
                                    // DELIVERY STORAGE: Quando fermo timer richiedo al provider il metodo e richiamo la classe di storage
                                    // String method = Provider.of<DataProvider>(context, listen: false).getDeliveryMethod();
                                    await DeliveryStorage().recordDelivery(deliveryMethod);
                          
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return Consumer<DataProvider>(
                                          builder: (context, data, child) {
                                            return AlertDialog(
                                              backgroundColor: const Color.fromARGB(255, 250, 250, 238),
                                              scrollable: true,
                                              title: Center(child: 
                                              Text("Recap",style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,  ),)),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
<<<<<<< HEAD
                                                  Text("You obtained: $xpIncrement XP", style: TextStyle(color: Colors.black54),),
                                                  // Text("Total covered distance: ${data.sumOfDistances} at ${data.avgSpeed} km/h", style: TextStyle(color: Colors.black54),),
                                                  Text("Total covered distance: ${data.sumOfDistances.toStringAsFixed(1)} km", style: TextStyle(color: Colors.black54),),
                                                  Text("${data.avgSpeed.toStringAsFixed(1)} km/h", style: TextStyle(color: Colors.black54),),
=======

                                                  SizedBox(height: 15,),
                                                  Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        TextSpan(text: 'You obtained: ',style: TextStyle( color: Colors.black54, fontWeight: FontWeight.bold,)),
                                                        TextSpan(text: '$xpIncrement XP', style: TextStyle(  color: Colors.black54)),
                                                      ]
                                                    ),
                                                  ),
                                                  
                                                  SizedBox(height: 13,),
                                                  Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        TextSpan(text: 'Total covered distance: ',style: TextStyle( color: Colors.black54, fontWeight: FontWeight.bold,)),
                                                        TextSpan(text: '${data.sumOfDistances.toStringAsFixed(1)} km', style: TextStyle(  color: Colors.black54)),
                                                      ]
                                                    ),
                                                  ),
                                                  SizedBox(height: 13,),
                                                  Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        TextSpan(text: 'Speed: ',style: TextStyle( color: Colors.black54, fontWeight: FontWeight.bold,)),
                                                        TextSpan(text: '${data.avgSpeed.toStringAsFixed(1)} km/h', style: TextStyle(  color: Colors.black54)),
                                                      ]
                                                    ),
                                                  ),
>>>>>>> 17fe1e3788958a0e52b0cdcb6d6b2038594f1718
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () async => _toHomePage(context),
                                                  child: Text("Confirm", style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold, ),),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    "Stop Timer",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 11,
                                ),
                                Image.asset('assets/PastOn.gif', scale: 1.5, ),
                              ],
                            ),
                          ),
                          
                        ),
                      ),
                    ),
                  
                
              ],
            ),
          ),
        ),
      ],
    ),
    floatingActionButton: Visibility(
      visible: !isTextVisible,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 250, 250, 238),
          borderRadius: BorderRadius.circular(50)
        ),
        
        height: 80,
        width: 80,
        child: Center(
          child: Stack(
            children: [
              Positioned(
                bottom: 35,
                right: 17,
                child: IconButton(
                  onPressed: (){
                    setState(() {
                      isTextVisible = !isTextVisible;
                    });
                  },
                  icon: Icon(
                    Icons.timer,
                    color: Colors.green,
                    size: 28,
                  )
                ),
              ),
              Positioned(
                bottom: 20,
                right: 10,
                child: Text(
                  _elapsedTime,
                  style: TextStyle(
                    // color: Colors.green
                  ),
                )
              )
            ],
          ),
        ),
      ),
    ),
  );
}
}

Future<void> _toHomePage(BuildContext context) async {
  await Provider.of<FirebaseDB>(context, listen: false).fetchDeliveriesDB();  // Get all the deliveries
  await Provider.of<FirebaseDB>(context, listen: false).getTotalXP();
  Provider.of<FirebaseDB>(context, listen: false).getTotalDeliveries();       // Get the number of deliveries
  Provider.of<FirebaseDB>(context, listen: false).getTrimpPerMin(Provider.of<FirebaseDB>(context, listen: false).deliveries[0]);  // Calculate the trimp of the first delivery (for history page)
  Navigator.of(context).pop();                                                // Remove the alertDialog from stack
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
}


Future<void> launchGoogleMapsSearch(BuildContext context, String address) async {

  // Encode address
  final String encodedAddress = Uri.encodeComponent(address);

  // Construct the Google Maps search URL
  // 'api=1' is recommended for launching external maps apps
  final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$encodedAddress';

  final Uri uri = Uri.parse(googleMapsUrl);

  // Check if the URL can be launched
  // if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication); // Opens in browser or maps app
  // } else {
  //   ScaffoldMessenger.of(context)
  //   ..removeCurrentSnackBar()
  //   ..showSnackBar(SnackBar(content: Text('Could not launch Google Maps for: $address')));
  // }
}