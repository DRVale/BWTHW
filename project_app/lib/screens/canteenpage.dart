import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_app/screens/boxpage.dart';
import 'package:project_app/utils/firebase.dart';
import 'package:provider/provider.dart';

class CanteenPage extends StatelessWidget {
  CanteenPage({super.key});

  final List<Canteen> canteen_list = [
    Canteen(canteenAndress: 'Viale Giuseppe Colombo, 1', canteenName: 'Piovego'),
    Canteen(canteenAndress: 'Via Antonio Grassi, 42', canteenName: 'Murialdo'),
    Canteen(canteenAndress: 'Via Antonio Francesco Bonporti, 20', canteenName: 'Pio X'),
    Canteen(canteenAndress: 'Via Gianbattista Belzoni, 146', canteenName: 'Belzoni'),
  ];

  QuerySnapshot ?boxes;

  @override
  Widget build(BuildContext context) {

    return Scaffold( 
      backgroundColor: const Color.fromARGB(255, 250, 250, 238),
      appBar: AppBar(
        backgroundColor:const Color.fromARGB(255, 250, 250, 238),
        title: Text('Pick a canteen ',style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold), ),
      ),
      body: Column(
        children: [
          SizedBox(height: 13,),
          Text('Chose a canteen for your new delivery: ', style: TextStyle(color: Colors.black54, fontSize: 15,fontWeight: FontWeight.normal),),
          SizedBox(height: 7,),
          Expanded(
            child: ListView.builder( 
              itemCount: canteen_list.length,
              itemBuilder: (context, index){
                final canteen = canteen_list[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 6),
                    Container(
                      width: MediaQuery.sizeOf(context).width - 50,
                      child: ListTile(
                        shape:  RoundedRectangleBorder( 
                          side: const BorderSide(color: Colors.black54, width: 1.0), 
                          borderRadius: BorderRadius.circular(20),
                        ),
                        leading: const Icon(
                          Icons.add_home, 
                          color: Colors.green, 
                          size: 20
                        ),
                        title: Text(
                          'Canteen: ${canteen.canteenName}',
                          style: const TextStyle(color: Colors.black54, fontSize: 16)
                        ),
                        subtitle: Text(
                          'Address: ${canteen.canteenAndress}',
                          style: const TextStyle(fontSize: 12, color: Colors.black54)
                        ),
                        trailing: const Icon(
                          Icons.keyboard_arrow_right, 
                          color: Colors.green
                        ),
                        onTap: () async {
                          await fetchBoxes(context, canteen.canteenName);
                          _toBoxPage(context, canteen: canteen.canteenName, boxes: boxes!);
                        },
                      ),
                    ),
                    SizedBox(height: 6),
                  ],
                );
              },
            ),
          )
        ],
      )
    );
  }

  void _toBoxPage(BuildContext context, {required String canteen, required QuerySnapshot boxes}){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => BoxPage(canteen: canteen, boxes: boxes,)));
  }
  
  Future<void> fetchBoxes(BuildContext context, String canteen) async {
    boxes = await Provider.of<FirebaseDB>(context, listen: false).fetchBoxes(canteen);
  }
}

class Canteen{
  final String canteenName;
  final String canteenAndress;
  const Canteen({required this.canteenName,required this.canteenAndress,});
}