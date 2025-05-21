//import 'dart:math';
import 'package:flutter/material.dart';
import 'package:project_app/widgets/expandablelisttile.dart';
import 'package:project_app/widgets/deliverymethod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:project_app/screens/boxpage.dart';
import 'package:project_app/screens/deliverypage.dart';

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

  bool isExpanded = false;

  String selectedMethod = '';
  bool isBikeSelected = false;
  bool isFootSelected = false;
  bool isRunningSelected = false;

  @override
  Widget build(BuildContext context) {

    //final deliveryMethodNotifier = Provider.of<DeliveryMethodNotifier>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            ListTile(
              leading: SizedBox(width: 50),
              title: Center(child: Text(widget.address + ' - ' + widget.packageType)),
              trailing: IconButton(
                icon: Icon(isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
            if(isExpanded)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => setState((){                           
                            isBikeSelected = !isBikeSelected;
                            isFootSelected = false;
                            isRunningSelected = false;

                            if(isBikeSelected) selectedMethod = 'Bici';
                            if(!isBikeSelected) selectedMethod = '';
                    
                            // if (isBikeSelected) {
                            //   deliveryMethodNotifier.updateMethod('Bici');
                            // } else if (!isFootSelected && !isRunningSelected) {
                            //   deliveryMethodNotifier.updateMethod(null); // Or some default value
                            // }
                            
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

                            if(isFootSelected) selectedMethod = 'Camminata';
                            if(!isFootSelected) selectedMethod = '';

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

                            if(isRunningSelected) selectedMethod = 'Corsa';
                            if(!isRunningSelected) selectedMethod = '';
                          }),
                          child: DeliveryMethod(
                            isSelected: isRunningSelected, 
                            iconType: Icons.run_circle_outlined, 
                            method: 'Running'
                          ),
                        )
                      ]
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final sp = await SharedPreferences.getInstance();
                        sp.setString('deliveryMethod', selectedMethod); 

                        if(selectedMethod == 'Bici' || selectedMethod == 'Camminata' || selectedMethod == 'Corsa'){
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                scrollable: true,
                                title: Center(child: Text("Recap")),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('${widget.address} - ${widget.packageType}'),
                                    Text(selectedMethod),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => _toDeliveryPage(context, address: widget.address, packageType: widget.packageType),
                                    child: Text("Confirm"),
                                  ),
                                ],
                              );
                            },
                          );

                        } else {
                          ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(SnackBar(content: Text('You must select a delivery method')));
                        }
                      },
                      child: Text('Conferma'),
                      style: ElevatedButton.styleFrom(
                        // textStyle: TextStyle(
                        //   color: Colors.green
                        // ),
                        // backgroundColor: Color.fromARGB(10, 0, 255, 0),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green

                      )
                    ),
                  ],
                ),
              ),
          ],
        ),
      ]
    );
  }  

  void _toDeliveryPage(BuildContext context, {required String address, required String packageType}){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DeliveryPage(address: address,packageType: packageType,)));
  }

  
}