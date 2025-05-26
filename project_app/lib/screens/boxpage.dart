import 'package:flutter/material.dart';
import 'package:project_app/widgets/box.dart';
import 'package:project_app/widgets/deliverymethod.dart';
import 'package:project_app/screens/deliverypage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';


class BoxPage extends StatefulWidget {

  final String mensa;

  const BoxPage({
    super.key, 
    required this.mensa,
  });

  @override
  State<BoxPage> createState() => _BoxPageState();
}

class _BoxPageState extends State<BoxPage> {

  bool isBikeSelected = false;
  bool isFootSelected = false;
  bool isRunningSelected = false;
  List<Box> box_list = [
    Box(address: 'Via Roma 6', packageType: 'Small'),
    Box(address: 'Via Gradenigo', packageType: 'Large'),
    Box(address: 'Via Ugo Bassi', packageType: 'Huge'),
    Box(address: 'Piazza Garibaldi', packageType: 'Medium'),
  ];

  @override
  Widget build(BuildContext context) {

    // List<Box> box_list = [
    //   Box(address: '1', packageType: ''),
    //   Box(address: '2', packageType: ''),
    //   Box(address: '3', packageType: ''),
    //   Box(address: '4', packageType: ''),
    // ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 238),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 250, 238),
        title: Text('Selected: ${widget.mensa}',style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold),)
      ),
      body: Column(
        children: [
          SizedBox(height: 13,),
          Text('Chose a box for your new delivery: ', style: TextStyle(color: Colors.black54, fontSize: 15,fontWeight: FontWeight.normal),),
          SizedBox(height: 7,),
          Expanded(
            child:
            ListView.builder(
          
          itemCount: box_list.length,
          // itemBuilder: (context, index) => box_list[index],
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
                      box_list[index],

                      SizedBox(height: 10),
                    ],
              ),
                ),
               //SizedBox(height: 60)
              ],
        );
          
          },
          ),
        
        ),
      
    ],
      ));
  }

  void _toDeliveryPage(BuildContext context, {required String address, required String packageType}){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DeliveryPage(address: address,packageType: packageType,)));
  }
}

class XP_notifier extends ChangeNotifier{
  double ?xp;

  double? get totalxp => xp;

  void updateXP(double newXP){
    xp = newXP;
    notifyListeners();
  }
}


// class DeliveryMethodNotifier extends ChangeNotifier{
//   String ?_selectedMethod;

//   String? get selectedDeliveryMethod => _selectedMethod;

//   void updateMethod(String? method){
//     _selectedMethod = method;
//     notifyListeners();
//   }
// }