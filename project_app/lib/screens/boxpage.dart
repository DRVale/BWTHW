import 'package:flutter/material.dart';
import 'package:project_app/models/box.dart';
import 'package:project_app/models/deliverymethod.dart';
import 'package:project_app/models/expandibletilelist.dart';
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
      Box(address: '1', packageType: ''),
      Box(address: '2', packageType: ''),
      Box(address: '3', packageType: ''),
      Box(address: '4', packageType: ''),
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
      appBar: AppBar(title: Text('Mensa: ${widget.mensa}')),
      body: Center(
        child: ListView.builder(
          itemCount: box_list.length,
          // itemBuilder: (context, index) => box_list[index],
          itemBuilder: (context, index){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                box_list[index],
                ElevatedButton(
                  onPressed: () async {

                    final selectedMethod = Provider.of<DeliveryMethodNotifier>(context, listen: false).selectedDeliveryMethod;

                    final sp = await SharedPreferences.getInstance();
                    sp.setString('deliveryMethod', selectedMethod!);

                    //saveDeliveryMethod(box_list[index].)
                    //_toDeliveryPage(context, address: box_list[index].address, packageType: box_list[index].packageType);

                    print(sp.getString('deliveryMethod'));

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Recap"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("• Option 1"),
                              Text("• Option 2"),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("Close"),
                            ),
                          ],
                        );
                      },
                    );

                    // showModalBottomSheet(
                    //   context: context,
                    //   builder: (context){
                    //     return Container(
                    //       padding: EdgeInsets.all(160),
                    //       height: double.infinity,
                    //       width: double.infinity,
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           // Text('prova'),
                    //           // ElevatedButton(onPressed: (){}, child: Text('Conferma'))
                    //         ],
                    //       )
                    //     );
                    //   },
                    // ); 
                  },
                  child: Text('Conferma'))
              ],
            );
          
          },
          ),
        )
    );
  }

  void _toDeliveryPage(BuildContext context, {required String address, required String packageType}){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeliveryPage(address: address,packageType: packageType,)));
  }
}


class DeliveryMethodNotifier extends ChangeNotifier{
  String ?_selectedMethod;

  String? get selectedDeliveryMethod => _selectedMethod;
  
  // String? getDeliveryMethod(){
  //   return _selectedMethod;
  // }

  void updateMethod(String? method){
    _selectedMethod = method;
    notifyListeners();
  }
}