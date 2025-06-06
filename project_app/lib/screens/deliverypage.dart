import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_app/screens/homepage.dart';
import 'package:project_app/providers/dataprovider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:project_app/widgets/deliverymethod.dart';
import 'package:project_app/utils/firebase.dart';

class DeliveryPage extends StatefulWidget {

  final String address;
  final String packageType;

  const DeliveryPage({super.key, required this.address, required this.packageType});

  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {

  Stopwatch _stopwatch = Stopwatch();
  String _elapsedTime = "00:00:00";
  Timer? _timer;
  String? startDate;
  String _backgroundImage = 'assets/dei_maps.jpg';

  @override
  void initState() {
    super.initState();
    //_startTimer();
    _startStopwatch();
    _updateBackground(widget.address);
  }
   void _updateBackground(String address){
    setState(() {
      if (address =='Via Orto Botanico 11 35123 Padova'){
        _backgroundImage = 'assets/dei_maps.jpg';
    } else if(address =='Via Tiziano Minio, 15 - 35134 Padova' ){
        _backgroundImage = '';
        }else if(address == 'Via S.massimo, 49, 35129 Padova' ){
        _backgroundImage = '';
        }else if(address =='Via Giovanni Boccaccio, 96, 35128 Padova' ){
        _backgroundImage = '';
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
                        child: Container(
                          color: const Color.fromARGB(255, 250, 250, 238).withOpacity(0.6),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [Row(
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

                                  // Va fatto per tutti i dati
                                  //Provider.of<DataProvider>(context, listen: false).clearDistanceData();

                                  DateTime endTime = DateTime.now().subtract(Duration(days: 1));
                                  String endDate = DateFormat("yyyy-MM-dd hh:mm:ss").format(endTime);

                                  // String startDate_prova = "2023-05-13 00:00:00";
                                  // String endDate_prova = "2023-05-13 23:59:59";

                                  await Provider.of<DataProvider>(context, listen: false).delivery(startDate!, endDate);

                                  // DELIVERY STORAGE: Quando fermo timer richiedo al provider il metodo e richiamo la classe di storage
                                  String method = Provider.of<DataProvider>(context, listen: false).getDeliveryMethod();
                                  await DeliveryStorage().recordDelivery(method);


                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Consumer<DataProvider>(
                                        builder: (context, data, child) {
                                          var current_distance = data.distances;
                                          var current_sumOfDistances = data.sumOfDistances;
                                          return AlertDialog(
                                            backgroundColor: const Color.fromARGB(255, 250, 250, 238),
                                            scrollable: true,
                                            title: Center(child: 
                                            Text("Recap",style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold ),)),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text("You obtained: ${data.xpIncrement} XP", style: TextStyle(color: Colors.black54),),
                                                // Text("Total covered distance: ${data.sumOfDistances} at ${data.avgSpeed} km/h", style: TextStyle(color: Colors.black54),),
                                                Text("Total covered distance: ${data.sumOfDistances}", style: TextStyle(color: Colors.black54),),
                                                Text("${data.avgSpeed} km/h", style: TextStyle(color: Colors.black54),),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => _toHomePage(context),
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
                            ],
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
  );
}
}

void _toHomePage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
  }