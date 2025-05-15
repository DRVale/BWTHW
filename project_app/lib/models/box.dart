//import 'dart:math';
import 'package:flutter/material.dart';
import 'package:project_app/models/expandibletilelist.dart';
import 'package:project_app/models/deliverymethod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:project_app/screens/boxpage.dart';

class Box extends StatefulWidget {

  final String address;
  final String packageType;

  const Box({
    super.key,
    required this.address,
    required this.packageType,
    bool? isSelected,
  });

  String setMethod(String method){
    String selectedMethod = method;
    return selectedMethod;
  } 

  @override
  State<Box> createState() => _BoxState();
}

class _BoxState extends State<Box> {

  String selectedMethod = '';

  

  bool isBikeSelected = false;
  bool isFootSelected = false;
  bool isRunningSelected = false;

  @override
  Widget build(BuildContext context) {

    final deliveryMethodNotifier = Provider.of<DeliveryMethodNotifier>(context, listen: false);


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ExpandableListTile(
          packageType: widget.packageType,
          address: widget.address,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                InkWell(
                  onTap: () => setState((){
                    isBikeSelected = !isBikeSelected;
                    isFootSelected = false;
                    isRunningSelected = false;

                    if (isBikeSelected) {
                      deliveryMethodNotifier.updateMethod('Bici');
                    } else if (!isFootSelected && !isRunningSelected) {
                      deliveryMethodNotifier.updateMethod(null); // Or some default value
                    }
                    
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

                    if (isFootSelected) {
                      deliveryMethodNotifier.updateMethod('Camminata');
                    } else if (!isBikeSelected && !isRunningSelected) {
                      deliveryMethodNotifier.updateMethod(null); // Or some default value
                    }
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

                    if (isRunningSelected) {
                      deliveryMethodNotifier.updateMethod('Corsa');
                    } else if (!isFootSelected && !isBikeSelected) {
                      deliveryMethodNotifier.updateMethod(null); // Or some default value
                    }
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