import 'package:flutter/material.dart';
import 'package:project_app/models/box.dart';
import 'package:project_app/models/deliverymethod.dart';
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
      body: Center(
        child:

        ListView.builder(
          itemCount: box_list.length,
          // itemBuilder: (context, index) => box_list[index],
          itemBuilder: (context, index){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container( //Aggiunto container per abbellire i pacchi
                  width: MediaQuery.sizeOf(context).width - 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(20)),                    
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      box_list[index],

                      // QUESTO NON SERVE PIU
                      // ElevatedButton(
                      //   onPressed: () async {
                  
                      //     final selectedMethod = Provider.of<DeliveryMethodNotifier>(context, listen: false).selectedDeliveryMethod;
                  
                      //     // NON NECESSARIO SALVARE NELLE SP, basta interrogare il provider
                      //     final sp = await SharedPreferences.getInstance();
                      //     sp.setString('deliveryMethod', selectedMethod!); 
                  
                      //     //saveDeliveryMethod(box_list[index].)
                      //     //_toDeliveryPage(context, address: box_list[index].address, packageType: box_list[index].packageType);
                  
                      //     print(sp.getString('deliveryMethod'));
                  
                      //     showDialog(
                      //       context: context,
                      //       builder: (context) {
                      //         return AlertDialog(
                      //           scrollable: true,
                      //           title: Text("Recap"),
                      //           content: Column(
                      //             mainAxisSize: MainAxisSize.min,
                      //             children: [
                      //               Text("• Option 1"),
                      //               Text("• Option 2"),
                  
                      //             ],
                      //           ),
                      //           actions: [
                      //             TextButton(
                      //               onPressed: () => _toDeliveryPage(context, address: box_list[index].address, packageType: box_list[index].packageType),
                      //               child: Text("Confirm"),
                      //             ),
                      //           ],
                      //         );
                      //       },
                      //     );
                      //   },
                      //   child: Text('Conferma')
                      // ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                SizedBox(height: 10)
              ],
            );
          
          },
          ),
        )
    );
  }

  void _toDeliveryPage(BuildContext context, {required String address, required String packageType}){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DeliveryPage(address: address,packageType: packageType,)));
  }
}


// class DeliveryMethodNotifier extends ChangeNotifier{
//   String ?_selectedMethod;

//   String? get selectedDeliveryMethod => _selectedMethod;
  
//   // String? getDeliveryMethod(){
//   //   return _selectedMethod;
//   // }

//   void updateMethod(String? method){
//     _selectedMethod = method;
//     notifyListeners();
//   }
// }