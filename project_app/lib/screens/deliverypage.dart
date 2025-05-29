import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_app/screens/homepage.dart';
import 'package:project_app/providers/dataprovider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
     backgroundColor:   const Color.fromARGB(255, 250, 250, 238),
      appBar: AppBar(
         backgroundColor:   const Color.fromARGB(255, 250, 250, 238),
        title: Text("Consegna")),
     
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Tempo trascorso: $_elapsedTime", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),

            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 0.5,
                )
              ),
              child: Image.asset('dei_maps.jpg', scale: 1.5, ), // Togliere anche da pubspec se non mettiamo gli screen
            ),

            SizedBox(height: 20),
            Text('Indirizzo di consegna: ${widget.address}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                stop();

                // First of all, DELETE ALL DATA IN THE PROVIDER (non si sa mai cosa ci sia dentro)
                // ESEMPIO: se facciamo due consegne in una volta, gli xp vanno a puttane (non so perché)

                Provider.of<DataProvider>(context, listen: false).clearDistanceData();
                // Provider.of<DataProvider>(context, listen: false).clearDistanceData();
                // Provider.of<DataProvider>(context, listen: false).clearDistanceData();


                DateTime endTime = DateTime.now().subtract(Duration(days: 1));
                String endDate = DateFormat("yyyy-MM-dd hh:mm:ss").format(endTime);

                // CHIAMATE RIMPIAZZATE CON LA NUOVA FUNZIONE delivery()
                //Provider.of<DataProvider>(context, listen: false).fetchHeartRateData(startDate!, endDate);
                // Provider.of<DataProvider>(context, listen: false).fetchDistanceData(startDate!, endDate);

                // Provider.of<DataProvider>(context, listen: false).updateXP();


                Provider.of<DataProvider>(context, listen: false).delivery(startDate!, endDate);

                print('sumOfDistances: ${Provider.of<DataProvider>(context, listen: false).sumOfDistances}');
                print('time: ${Provider.of<DataProvider>(context, listen: false).time}');
                print('xpIncrement: ${Provider.of<DataProvider>(context, listen: false).xpIncrement}');

                // Qua ritorna null non so perché
                print('XP: ${Provider.of<DataProvider>(context, listen: false).xp}');

                
                showDialog(
                  context: context,
                  builder: (context) {
                    return Consumer<DataProvider>(builder: (context, data, child) {
                        return AlertDialog(
                      // scrollable: true,
                          title: Text("Recap"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("You obtained ${data.xpIncrement} XP"),
                              Text("Total covered distance: ${data.sumOfDistances} at ${data.avgSpeed} km/h"),
                              //Text("$avgSpeed average speed"),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>_toHomePage(),
                              child: Text("Confirm"),
                            ),
                          ],
                        );
                    });
                  },
                );
              },
              child: Text("Ferma Timer"),
            ),
          ],
        ),
      ),
    );
  }

  void _toHomePage(){
    // VEDERE STACK DEGLI SCREEN
    // Navigator.pop(context);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
  }
}
