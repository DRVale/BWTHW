import 'package:flutter/material.dart';
import 'package:project_app/models/deliverymethod.dart';
import 'package:project_app/models/expandibletilelist.dart';

class BoxPage extends StatefulWidget {

  final String mensa;
  
  const BoxPage({super.key, required this.mensa});

  @override
  State<BoxPage> createState() => _BoxPageState();
}

class _BoxPageState extends State<BoxPage> {

  bool isBikeSelected = false;
  bool isFootSelected = false;
  bool isRunningSelected = false;


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: Text('Mensa: ${widget.mensa}')),
      body: Center(
        child: ListView(
          children: [
            ExpandableListTile(
              packageType: "Piccolo",
              address: 'Via Roma 2',
              actions: [
                Text('Ciao'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 0,
                  children: [
                    Text('Address'),
                    Text('Modalità'),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    InkWell(
                      onTap: () => setState(() {
                        isBikeSelected = !isBikeSelected;
                        isFootSelected = false;
                        isRunningSelected = false;
                        // Salvare l'opzione nelle shared_preferences per utilizzarla quando si pescano i dati
                      }),
                      child: DeliveryMethod(
                        isSelected: isBikeSelected, 
                        icon: Icon(Icons.pedal_bike), 
                        method: 'Bike'
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() {
                        isBikeSelected = false;
                        isFootSelected = !isFootSelected;
                        isRunningSelected = false;
                      }),
                      child: DeliveryMethod(
                        isSelected: isFootSelected, 
                        icon: Icon(Icons.man), 
                        method: 'On Foot'
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() {
                        isBikeSelected = false;
                        isFootSelected = false;
                        isRunningSelected = !isRunningSelected;
                      }),
                      child: DeliveryMethod(
                        isSelected: isRunningSelected, 
                        icon: Icon(Icons.run_circle_outlined), 
                        method: 'Running'
                      ),
                    )
                  ]
                ),

                ElevatedButton(onPressed: () {}, child: Text("Action 2")),
              ],
            ),
            ExpandableListTile(
              packageType: "Grande",
              address: 'Via Roma 15',
              actions: [
                ElevatedButton(onPressed: () {}, child: Text("Edit")),
                ElevatedButton(onPressed: () {}, child: Text("Delete")),
              ],
            ),
          ],
        )



        ,
      ),
    );
  }
}
