import 'package:flutter/material.dart';
import 'package:project_app/widgets/deliverymethod.dart';
import 'package:provider/provider.dart';
import 'package:project_app/screens/deliverypage.dart';
import 'package:project_app/providers/dataprovider.dart';

class Box extends StatefulWidget {

  final String address;
  final String packageType;
  final String canteen;

  const Box({
    super.key,
    required this.address,
    required this.packageType,
    required this.canteen,
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
    return Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
        Column(
          children: [
            ListTile(
              leading: Icon(Icons.fmd_good_outlined, color: Colors.green,), 
              title: Center(
                child: Text(widget.address + ' - ' + widget.packageType,style: TextStyle(fontSize: 16, color: Colors.black54) ,),
              ),
              trailing: IconButton(
                icon: Icon(isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, color: Colors.green,),
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
                padding:  EdgeInsets.symmetric(horizontal: 16.0),
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

                            if(isBikeSelected) selectedMethod = 'Bike';
                            if(!isBikeSelected) selectedMethod = '';

                            Provider.of<DataProvider>(context, listen: false).setDeliveryMethod(selectedMethod);
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

                            if(isFootSelected) selectedMethod = 'On Foot';
                            if(!isFootSelected) selectedMethod = '';

                            Provider.of<DataProvider>(context, listen: false).setDeliveryMethod(selectedMethod);
                          }),
                          child: DeliveryMethod(
                            isSelected: isFootSelected, 
                            iconType: Icons.directions_walk, 
                            method: 'On Foot'
                          ),
                        ),
                        InkWell(
                          onTap: () => setState((){
                            isBikeSelected = false;
                            isFootSelected = false;
                            isRunningSelected = !isRunningSelected;

                            if(isRunningSelected) selectedMethod = 'Running';
                            if(!isRunningSelected) selectedMethod = '';

                            Provider.of<DataProvider>(context, listen: false).setDeliveryMethod(selectedMethod);
                          }),
                          child: DeliveryMethod(
                            isSelected: isRunningSelected, 
                            iconType: Icons.run_circle_outlined, 
                            method: 'Running'
                          ),
                        ),

                        
                      ]
                    ),
                    SizedBox(height: 10), 

                    ElevatedButton(
                      onPressed: (){
                        String selectedMethod = Provider.of<DataProvider>(context, listen: false).getDeliveryMethod();

                        if(selectedMethod == 'Bike' || selectedMethod == 'On Foot' || selectedMethod == 'Running'){
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: const Color.fromARGB(255, 250, 250, 238),
                                scrollable: true,
                                title: Center(
                                  child: Text(
                                    "Recap",
                                    style: TextStyle(
                                      color: Colors.black54, 
                                      fontWeight: FontWeight.bold 
                                    ),
                                  )
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 3,),
                                    Text('You have selected: ',style: TextStyle(color: Colors.black54),),
                                    SizedBox(height: 15,),
                                    Row(mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_home_outlined, size: 17,color: Colors.black54, ),
                                        SizedBox(width: 3,),
                                        Text('Canteen:  ',style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(text: widget.canteen, style: TextStyle(color: Colors.black54,) ),
                                            ]
                                          )
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 13,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.fmd_good_outlined,size: 17,color: Colors.black54,),
                                        SizedBox(width: 3,),
                                        Text('Address:  ',style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),),
                                         Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(text: widget.address.split('-')[0], style: TextStyle(color: Colors.black54,) ),
                                            ]
                                          )
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 13,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.fastfood_outlined,size: 17,color: Colors.black54,),
                                        SizedBox(width: 3,),
                                        Text('Type: ',style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(text: widget.packageType, style: TextStyle(color: Colors.black54,) ),
                                            ]
                                          )
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 13,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.delivery_dining_outlined,size: 17,color: Colors.black54,),
                                        SizedBox(width: 3,),
                                        Text('Modality:  ',style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold),),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(text: selectedMethod, style: TextStyle(color: Colors.black54,) ),
                                            ]
                                          )
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      _toDeliveryPage(context, canteen: widget.canteen, address: widget.address, packageType: widget.packageType);
                                      Provider.of<DataProvider>(context, listen: false).setCanteen(widget.canteen);
                                      Provider.of<DataProvider>(context, listen: false).setAddress(widget.address);
                                      Provider.of<DataProvider>(context, listen: false).setPackageType(widget.packageType);
                                      Provider.of<DataProvider>(context, listen: false).setDeliveryMethod(selectedMethod);
                                    },
                                    child: Text(
                                      "Confirm",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
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
                      child: Text('Confirm'),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(color: Colors.green),
                        backgroundColor:  Color.fromARGB(255, 107, 165, 109),
                        foregroundColor:  Colors.black54,
                      ),
                    ),
                    
                    SizedBox(height: 10),                    
                  ],
                ),
              ),
          ],
        ),
      ]
    );
  }  

  void _toDeliveryPage(BuildContext context, {required String canteen, required String address, required String packageType}){
    Navigator.of(context).pop();  // Remove BoxPage from stack
    Navigator.of(context).pop();  // Remove CanteenPage from stack
    Navigator.of(context).pop();  // Remove HomePage from stack
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DeliveryPage(canteen: canteen, address: address, packageType: packageType)));
  }

  
}