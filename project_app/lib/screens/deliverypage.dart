import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_app/models/requesteddata.dart';
import 'package:project_app/screens/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_app/utils/impact.dart';
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
  Timer? _timer;
  int _seconds = 0;
  String ?start_Date;
  

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
    DateTime startDate = DateTime.now().subtract(Duration(days: 1));
    //startDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$startDate');
    start_Date = DateFormat("yyyy-MM-dd hh:mm:ss").format(startDate);
  }

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
      appBar: AppBar(title: Text("Consegna")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Tempo trascorso: $_seconds s", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text('Indirizzo di consegna: '),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                stop();

                //await???????
                // Future<List<Distance>?> listOfDistances = requestDate();
                // int sumOfDistances = getTotalDistance(listOfDistances);

                final sp = await SharedPreferences.getInstance();
                String deliveryMethod = sp.getString('deliveryMethod')!;

                DateTime endDate = DateTime.now().subtract(Duration(days: 1));
                endDate = DateFormat('yyyy-MM-dd').parse('$endDate');
                String end_Date = DateFormat("yyyy-MM-dd hh:mm:ss").format(endDate);

                

                Provider.of<DataProvider>(context, listen: false).fetchHeartRateData(start_Date!,end_Date);
                Provider.of<DataProvider>(context, listen: false).updateXP(deliveryMethod, Provider.of<DataProvider>(context, listen: false).distances, 15);
                
                

                // int sumOfDistances = 15000;
                // double avgSpeed = 14;
                
                
                //double xp = Provider.of<DataProvider>(context, listen: false).getXP(deliveryMethod,distance,speed);
                //getXP(deliveryMethod, sumOfDistances, avgSpeed);
                // double totalXP = sp.getDouble('XP')!;

                // totalXP = totalXP + xp;
                // sp.setDouble('XP', totalXP); 
                
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
                              Text("You obtained ${data.XP} XP"),
                              Text("Total covered distance: ${data.getTotalDistance(data.distances)}"),
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

  

  // Future<int> _getFileLength(Future<List<Distance>> result) async {
  //   return await result.then((value) {
  //    return value.length;
  //  });
  // }


  // int getTotalDistance(Future<List<Distance>?> result){
  //   int sum = 0;
  //   for(int i = 0; i < _getFileLength(); i++){
  //     sum = sum + result[i].value;
  //   }
  //   return sum;
  // }

  void _toHomePage(){
    // VEDERE STACK DEGLI SCREEN
    // Navigator.pop(context);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
  }
}
