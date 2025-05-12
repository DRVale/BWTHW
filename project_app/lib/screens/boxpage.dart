import 'package:flutter/material.dart';
import 'package:project_app/models/expandibletilelist.dart';

class BoxPage extends StatelessWidget {
  final String mensa;

  const BoxPage({super.key, required this.mensa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mensa: $mensa')),
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



        ,
      ),
    );
  }
}