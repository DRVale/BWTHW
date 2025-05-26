import 'package:flutter/material.dart';
import 'package:project_app/screens/boxpage.dart';

class CanteenPage extends StatelessWidget {
   CanteenPage({super.key});

List<Canteen> canteen_list = [
    Canteen(canteenAndress: 'Via Roma 6', canteenName: 'Piovegio'),
    Canteen(canteenAndress: 'Via Gradenigo', canteenName: 'Murialdo'),
    Canteen(canteenAndress: 'Via Ugo Bassi', canteenName: 'Pio X'),
    Canteen(canteenAndress: 'Piazza Garibaldi', canteenName: 'Belzoni'),
  ];
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
          SizedBox(height: 16,),
          Text('Chose a canteen for your new delivery: ', style: TextStyle(color: Colors.black54, fontSize: 15,fontWeight: FontWeight.normal),),
          SizedBox(height: 40,),
          Expanded(
            child: 
                    ListView.builder(
                  
                  itemCount: canteen_list.length,
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
                              canteen_list[index],

                              SizedBox(height: 10),
                            ],
                      ),
                        ),
                      //SizedBox(height: 60)
                      ],
                );
                  
                  },
          ),
            
            
            /*
              ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.add_home, color: Colors.green, size: 20),
                    title: Text('Canteen: Piovego',style: TextStyle(
                        color: Colors.black54
                      ),),
                      subtitle: Text('Address: Viale Giuseppe Colombo, 1, 35131 Padova PD',style: TextStyle(fontSize: 9),),
                    trailing: Icon(Icons.arrow_right_sharp, color: Colors.black54,),
                    onTap: (){
                      final String id_mensa = 'Piovego';
                      _toBoxPage(context,mensa: id_mensa);
                    },
                  ),
                  SizedBox(height: 20,),
                  ListTile(
                    leading: Icon(Icons.add_home,color: Colors.green,size: 20,),
                    title: Text('Canteen: Murialdo', style: TextStyle(
                        color: Colors.black54
                      ),),
                      subtitle: Text('Address: Via Antonio Grassi, 42, 35129 Padova PD',style: TextStyle(fontSize: 9),),
                    trailing: Icon(Icons.arrow_right_sharp, color: Colors.black54,),
                    onTap: (){
                      final String id_mensa = 'Murialdo';
                      _toBoxPage(context,mensa: id_mensa);
                    },
                  ),
                  SizedBox(height: 20,),

                  ListTile(
                    leading: Icon(Icons.add_home,color: Colors.green, size: 20),
                    title: Text('Canteen: PioX',
                      style: TextStyle(
                        color: Colors.black54
                      ),
                    ),
                    subtitle: Text('Address: Via Antonio Francesco Bonporti, 20, 35141 Padova PD',style: TextStyle(fontSize: 9),),
                    trailing: Icon(Icons.arrow_right_sharp, color:Colors.black54),
                    onTap: (){
                      final String id_mensa = 'PioX';
                      _toBoxPage(context,mensa: id_mensa);
                    },
                  ),
                  SizedBox(height: 20,),

                  ListTile(
                    leading: Icon(Icons.add_home,color: Colors.green, size: 20),
                    title: Text('Canteen: Belzoni',
                      style: TextStyle(
                        color: Colors.black54
                      ),
                    ),
                    subtitle: Text('Address: Via Giambattista Belzoni, 146, 35121 Padova PD',style: TextStyle(fontSize: 9),),
                    trailing: Icon(Icons.arrow_right_sharp, color:Colors.black54),
                    onTap: (){
                      final String id_mensa = 'Belzoni';
                      _toBoxPage(context, mensa: id_mensa);
                    },
                  ),
                ]
              )
          ),
          */
      )
      ],
        
      )
    );
  }

  void _toBoxPage(BuildContext context, {required String mensa}){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => BoxPage(mensa: mensa)));
  }

}

class Canteen{
  //final String addess;
  final String canteenName;
  final String canteenAndress;

  const Canteen({
    
    required this.canteenName,
    required this.canteenAndress,
    
  });



}


// class CanteenPage extends StatefulWidget {
//   const CanteenPage({super.key});

//   @override
//   State<CanteenPage> createState() => _CanteenPageState();

// }

// class _CanteenPageState extends State<CanteenPage> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold( 
//       backgroundColor: const Color.fromARGB(255, 250, 250, 238),
//       appBar: AppBar(

//         backgroundColor:const Color.fromARGB(255, 250, 250, 238),
//         title: Text('Pick a canteen ',style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold), ),
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: 16,),
//           Text('Chose a canteen for your new delivery: ', style: TextStyle(color: Colors.black54, fontSize: 15,fontWeight: FontWeight.normal),),
//           SizedBox(height: 40,),
//           Expanded(
//             child:
//               ListView(
//                 children: [
//                   ListTile(
//                     leading: Icon(Icons.add_home, color: Colors.green, size: 20),
//                     title: Text('Canteen: Piovego',style: TextStyle(
//                         color: Colors.black54
//                       ),),
//                       subtitle: Text('Address: Viale Giuseppe Colombo, 1, 35131 Padova PD',style: TextStyle(fontSize: 9),),
//                     trailing: Icon(Icons.arrow_right_sharp, color: Colors.black54,),
//                     onTap: (){
//                       final String id_mensa = 'Piovego';
//                       _toBoxPage(context,mensa: id_mensa);
//                     },
//                   ),
//                   SizedBox(height: 20,),
//                   ListTile(
//                     leading: Icon(Icons.add_home,color: Colors.green,size: 20,),
//                     title: Text('Canteen: Murialdo', style: TextStyle(
//                         color: Colors.black54
//                       ),),
//                       subtitle: Text('Address: Via Antonio Grassi, 42, 35129 Padova PD',style: TextStyle(fontSize: 9),),
//                     trailing: Icon(Icons.arrow_right_sharp, color: Colors.black54,),
//                     onTap: (){
//                       final String id_mensa = 'Murialdo';
//                       _toBoxPage(context,mensa: id_mensa);
//                     },
//                   ),
//                   SizedBox(height: 20,),

//                   ListTile(
//                     leading: Icon(Icons.add_home,color: Colors.green, size: 20),
//                     title: Text('Canteen: PioX',
//                       style: TextStyle(
//                         color: Colors.black54
//                       ),
//                     ),
//                     subtitle: Text('Address: Via Antonio Francesco Bonporti, 20, 35141 Padova PD',style: TextStyle(fontSize: 9),),
//                     trailing: Icon(Icons.arrow_right_sharp, color:Colors.black54),
//                     onTap: (){
//                       final String id_mensa = 'PioX';
//                       _toBoxPage(context,mensa: id_mensa);
//                     },
//                   ),
//                   SizedBox(height: 20,),

//                   ListTile(
//                     leading: Icon(Icons.add_home,color: Colors.green, size: 20),
//                     title: Text('Canteen: Belzoni',
//                       style: TextStyle(
//                         color: Colors.black54
//                       ),
//                     ),
//                     subtitle: Text('Address: Via Giambattista Belzoni, 146, 35121 Padova PD',style: TextStyle(fontSize: 9),),
//                     trailing: Icon(Icons.arrow_right_sharp, color:Colors.black54),
//                     onTap: (){
//                       final String id_mensa = 'Belzoni';
//                       _toBoxPage(context, mensa: id_mensa);
//                     },
//                   ),
//                 ]
//               )
//           ),
//       ],
        
//       )
//     );
//   }
// }