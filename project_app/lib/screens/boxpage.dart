import 'package:flutter/material.dart';
import 'package:project_app/widgets/box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BoxPage extends StatefulWidget {

  final String canteen;
  final QuerySnapshot boxes;

  const BoxPage({
    super.key, 
    required this.canteen,
    required this.boxes,
  });

  @override
  State<BoxPage> createState() => _BoxPageState();
}

class _BoxPageState extends State<BoxPage> {

  bool isExpanded = false;

  bool isBikeSelected = false;
  bool isFootSelected = false;
  bool isRunningSelected = false;

  @override
  Widget build(BuildContext context) {

    // Invece che mettere boxList, si puo:
    // Fare una chiamata limitandosi alla mensa selezionata salvando il risultato in queryResult
    // Fare il builder della lunghezza di queryResult.docs e creare di volta in volta una box nuova

    // List<Box> boxList = [
    //   Box(address: 'Via Orto Botanico, 11 - 35123 Padova', packageType: 'Small', canteen: widget.canteen),
    //   Box(address: 'Via Tiziano Minio, 15 - 35134 Padova', packageType: 'Large', canteen: widget.canteen),
    //   Box(address: 'Via S.massimo, 49 - 35129 Padova', packageType: 'Huge', canteen: widget.canteen),
    //   Box(address: 'Via Giovanni Boccaccio, 96 - 35128 Padova', packageType: 'Medium', canteen: widget.canteen),
    // ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 238),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 250, 238),
        title: Text('Selected: ${widget.canteen}',style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold),)
      ),
      body: Column(
        children: [
          SizedBox(height: 13,),
          Text('Chose a box for your new delivery: ', style: TextStyle(color: Colors.black54, fontSize: 15,fontWeight: FontWeight.normal),),
          SizedBox(height: 7,),
          Expanded(
            child:
            ListView.builder(
              itemCount: widget.boxes.docs.length,
              itemBuilder: (context, index){
                dynamic data = widget.boxes.docs[index].data();
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 6),
                    Container(
                      width: MediaQuery.sizeOf(context).width - 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.all(Radius.circular(20)),                    
                      ),
                      
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          

                          Box(
                            canteen: data["canteen"],
                            address: data["address"],
                            packageType: data["packageType"],
                          ),
                          
                          // boxList[index],
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    SizedBox(height: 6),
                  ],
                );

              },
            ),  
          )
        ]
      )
    );
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