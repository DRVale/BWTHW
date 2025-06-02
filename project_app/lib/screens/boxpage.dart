import 'package:flutter/material.dart';
import 'package:project_app/widgets/box.dart';



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

  bool isExpanded = false;

  bool isBikeSelected = false;
  bool isFootSelected = false;
  bool isRunningSelected = false;
  

  @override
  Widget build(BuildContext context) {

    List<Box> boxList = [
    Box(address: 'Via Orto Botanico, 11 - 35123 Padova', packageType: 'Small', mensa: widget.mensa),
    Box(address: 'Via Tiziano Minio, 15 - 35134 Padova', packageType: 'Large', mensa: widget.mensa),
    Box(address: 'Via S.massimo, 49 - 35129 Padova', packageType: 'Huge', mensa: widget.mensa),
    Box(address: 'Via Giovanni Boccaccio, 96 - 35128 Padova', packageType: 'Medium', mensa: widget.mensa),
  ];

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
              itemCount: boxList.length,
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
                          boxList[index],                          
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    //SizedBox(height: 60)
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