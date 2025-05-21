import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_app/screens/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_app/utils/impact.dart';

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

  @override
  void initState() {
    super.initState();
    _startTimer(); // Parte appena si entra nella pagina
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void stop() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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

                int sumOfDistances = 15000;
                double avgSpeed = 14;

                double xp = getXP(deliveryMethod, sumOfDistances, avgSpeed);
                double totalXP = sp.getDouble('XP')!;

                totalXP = totalXP + xp;
                sp.setDouble('XP', totalXP); 

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      // scrollable: true,
                      title: Text("Recap"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("You obtained $xp XP"),
                          Text("$sumOfDistances distance "),
                          Text("$avgSpeed average speed"),

                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>_toHomePage(),
                          child: Text("Confirm"),
                        ),
                      ],
                    );
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
