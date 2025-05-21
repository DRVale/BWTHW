import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:project_app/providers/dataprovider.dart';
import 'package:project_app/models/requesteddata.dart';

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
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Provider.of<DataProvider>(context, listen: false).fetchDistanceData('2023-05-13');
            
                // Define consumer

                // for debug
                print('Done');
              },
              child: Text('Prendi i dati'),
            ),
          ],
        ),
      ),
    );
  }
}