import 'package:flutter/material.dart';
import 'package:project_app/screens/boxpage.dart';


class CanteenPage extends StatefulWidget {
  const CanteenPage({super.key});

  @override
  State<CanteenPage> createState() => _CanteenPageState();

}

class _CanteenPageState extends State<CanteenPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CanteenPage'),
      ),
      body: Column(
        children: [
          Text('Pick a canteen'),
          Expanded(
            child:
              ListView(
                children: [
                  ListTile(
                    //leading: Icon(Icons.plus_one),
                    title: Text('Piovego'),
                    trailing: Icon(Icons.arrow_right_alt),
                    onTap: (){
                      final String id_mensa = 'Piovego';
                      _toBoxPage(context,mensa: id_mensa);
                    },
                  ),

                  ListTile(
                    //leading: Icon(Icons.plus_one),
                    title: Text('Murialdo'),
                    trailing: Icon(Icons.arrow_right_alt),
                    onTap: (){
                      final String id_mensa = 'Murialdo';
                      _toBoxPage(context,mensa: id_mensa);
                    },
                  ),

                  ListTile(
                    title: Text('PioX',
                      style: TextStyle(
                        color: Colors.red
                      ),
                    ),
                    onTap: (){
                      final String id_mensa = 'PioX';
                      _toBoxPage(context,mensa: id_mensa);
                    },
                  ),

                  ListTile(
                    title: Text('Belzoni',
                      style: TextStyle(
                        color: Colors.red
                      ),
                    ),
                    onTap: (){
                      final String id_mensa = 'Belzoni';
                      _toBoxPage(context, mensa: id_mensa);
                    },
                  ),
                ]
              )
          ),
      ],
        
      )
    );
  }

  void _toBoxPage(BuildContext context, {required String mensa}){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => BoxPage(mensa: mensa)));
  }
}

