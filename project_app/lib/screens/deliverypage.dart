import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_app/models/requestedData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_app/utils/impact.dart';
//import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

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

  void _stopTimer() {
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
              onPressed: (){
                _stopTimer;

              },
              child: Text("Ferma Timer"),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Distance>?> requestDate()async{
    List<Distance>? result;

    // //check accesso 
    // final sp = await SharedPreferences.getInstance();
    // var access = sp.getString('access');

    // //If access token is expired, refresh it
    // if(JwtDecoder.isExpired(access!)){
    //   await refreshTokens();
    //   access = sp.getString('access');
    // }//if

    
  }
}
