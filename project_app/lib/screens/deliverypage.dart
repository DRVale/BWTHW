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
  String _backgroundImage = 'assets/Piovego-OrtoBontanico.png';

  @override
  void initState() {
    super.initState();
    //_startTimer();
    _startStopwatch();
    _updateBackground(widget.address);
  }
   void _updateBackground(String address){
    setState(() {
      if (address =='Via Orto Botanico, 11 - 35123 Padova' && widget.canteen == 'Piovego'){
        _backgroundImage = 'assets/Piovego-OrtoBontanico.png';
    } else if(address =='Via Orto Botanico, 11 - 35123 Padova' && widget.canteen == 'Murialdo' ){
        _backgroundImage = 'assets/Murialdo-OrtoBotanico.png';
        }
        else if(address =='Via Orto Botanico, 11 - 35123 Padova' && widget.canteen == 'Pio X' ){
        _backgroundImage = 'assets/Pio-ortobotonico.png';
        }
        else if(address =='Via Orto Botanico, 11 - 35123 Padova' && widget.canteen == 'Belzoni' ){
        _backgroundImage = 'assets/Belzoni-ortobotanico.png';
        }
        else if(address =='Via Tiziano Minio, 15 - 35134 Padova' && widget.canteen == 'Piovego' ){
        _backgroundImage = 'assets/piovego-TizianoMinio.png';
        }
        else if(address =='Via Tiziano Minio, 15 - 35134 Padova' && widget.canteen == 'Murialdo' ){
        _backgroundImage = 'assets/Murialdo-Tiziano.png';
        }
        else if(address =='Via Tiziano Minio, 15 - 35134 Padova' && widget.canteen == 'Pio X' ){
        _backgroundImage = 'assets/Pio-Tiziano.png';
        }
        else if(address =='Via Tiziano Minio, 15 - 35134 Padova' && widget.canteen == 'Belzoni' ){
        _backgroundImage = 'assets/Belzoni-tiziano.png';
        }
        else if(address == 'Via S.massimo, 49, 35129 Padova' && widget.canteen == 'Piovego' ){
        _backgroundImage = 'assets/Piovego-SanMassimo.png';
        }
        else if(address == 'Via S.massimo, 49, 35129 Padova' && widget.canteen == 'Murialdo' ){
        _backgroundImage = 'assets/Murialdo-SanMassimo.png';
        }
         else if(address == 'Via S.massimo, 49, 35129 Padova' && widget.canteen == 'Pio X' ){
        _backgroundImage = 'assets/Pio-SanMassimo.png';
        }
        else if(address == 'Via S.massimo, 49, 35129 Padova' && widget.canteen == 'Belzoni' ){
        _backgroundImage = 'assets/Belzoni-Massimo.png';
        }
        else if(address =='Via Giovanni Boccaccio, 96, 35128 Padova' && widget.canteen == 'Piovego' ){
        _backgroundImage = 'assets/Piovego-Boccaccio.png';
        }
        else if(address =='Via Giovanni Boccaccio, 96, 35128 Padova' && widget.canteen == 'Murialdo' ){
        _backgroundImage = 'assets/Murialdo-Boccaccio.png';
        }
        else if(address =='Via Giovanni Boccaccio, 96, 35128 Padova' && widget.canteen == 'Pio X' ){
        _backgroundImage = 'assets/Pio-Boccaccio.png';
        }
         else if(address =='Via Giovanni Boccaccio, 96, 35128 Padova' && widget.canteen == 'Belzoni' ){
        _backgroundImage = 'assets/Belzoni-Boccaccio.png';
        }
    });
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
    body: Stack(
      children: [
        // Immagine di sfondo che riempie TUTTO
        Positioned.fill(
          child: Image.asset(
            _backgroundImage,
            fit: BoxFit.cover,
          ),
        ),

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
                  child: SingleChildScrollView(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Visibility(
                          visible: isTextVisible,
                          child: Container(
                            color: const Color.fromARGB(255, 250, 250, 238),
                            // padding: const EdgeInsets.all(16.0),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 5
                            ),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.minimize,
                                      color: Colors.black,
                                    ),
                                    tooltip: 'Minimize',
                                    onPressed: () {
                                      setState(() {
                                        isTextVisible = false; // Hide the container with the text
                                      });
                                    },
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                  Icon(Icons.fastfood_outlined, color: Colors.black54, size:  20, ),
                                  SizedBox(width: 5),
                                  Text("Time to deliver - your box is waiting", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 20),)
                                ]),
                                SizedBox(height: 20,),
                                Text('Go to: ${widget.address}', style: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 20),
                                Text("Tempo trascorso: $_elapsedTime", style: const TextStyle(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.bold)),
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
                                              Text("Recap",style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold ),)),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text("You obtained: $xpIncrement XP", style: TextStyle(color: Colors.black54),),
                                                  // Text("Total covered distance: ${data.sumOfDistances} at ${data.avgSpeed} km/h", style: TextStyle(color: Colors.black54),),
                                                  Text("Total covered distance: ${data.sumOfDistances}", style: TextStyle(color: Colors.black54),),
                                                  Text("${data.avgSpeed} km/h", style: TextStyle(color: Colors.black54),),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () async => _toHomePage(context),
                                                  child: Text("Confirm"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Text("Ferma Timer"),
                                ),
                                SizedBox(
                                  height: 11,
                                )
                              ],
                            ),
                          ),
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
                    size: 28,
                  )
                ),
              ),
              Positioned(
                bottom: 20,
                right: 10,
                child: Text(_elapsedTime)
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

