import 'package:flutter/material.dart';
import 'package:project_app/screens/graphpage.dart';
import 'package:project_app/screens/historypage.dart';
import 'package:project_app/models/expandablelisttile.dart';


class OptionsPage extends StatelessWidget {
  const OptionsPage({Key? key}) : super(key: key);

  static const routename = 'OptionsPage';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('OptionsPage'),
      ),

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
                  spacing: 100,
                  children: [
                    Text('Address'),
                    Text('Modalità'),
                  ],
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
      ),

      
    );
    
  }


}