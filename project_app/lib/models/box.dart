//import 'dart:math';
import 'package:flutter/material.dart';
import 'package:project_app/models/expandibletilelist.dart';
import 'package:project_app/models/deliverymethod.dart';

class Box extends StatefulWidget {

  final String address;

  final String packageType;

  const Box({
    super.key,
    required this.address,
    required this.packageType,
  });

  @override
  State<Box> createState() => _BoxState();
}

class _BoxState extends State<Box> {

  bool isBikeSelected = false;
  bool isFootSelected = false;
  bool isRunningSelected = false;

  String selectedMethod = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ExpandableListTile(
          packageType: widget.packageType,
          address: widget.address,
          actions: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   spacing: 0,
            //   children: [
            //     Text('Address'),
            //     Text('Modalità'),
            //   ],
            // ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                InkWell(
                  onTap: () => setState(() async {
                    isBikeSelected = !isBikeSelected;
                    isFootSelected = false;
                    isRunningSelected = false;

                    selectedMethod = 'Bici';
                    
                    // Salvare l'opzione nelle shared_preferences per utilizzarla quando si pescano i dati
                    // OPPURE si può passare il valore di selectedMethod alla pagina successiva tramite navigator.
                    // In questo modo si può salvare tutto nelle shared preferences dopo.
                  }),
                  child: DeliveryMethod(
                    isSelected: isBikeSelected, 
                    iconType: Icons.pedal_bike, 
                    method: 'Bike'
                  ),
                ),
                InkWell(
                  onTap: () => setState((){
                    isBikeSelected = false;
                    isFootSelected = !isFootSelected;
                    isRunningSelected = false;

                    selectedMethod = 'Camminata';
                  }),
                  child: DeliveryMethod(
                    isSelected: isFootSelected, 
                    iconType: Icons.man, 
                    method: 'On Foot'
                  ),
                ),
                InkWell(
                  onTap: () => setState((){
                    isBikeSelected = false;
                    isFootSelected = false;
                    isRunningSelected = !isRunningSelected;

                    selectedMethod = 'Corsa';
                  }),
                  child: DeliveryMethod(
                    isSelected: isRunningSelected, 
                    iconType: Icons.run_circle_outlined, 
                    method: 'Running'
                  ),
                )
              ]
            ),
          ],
        ),
      ]
    );
  }
}