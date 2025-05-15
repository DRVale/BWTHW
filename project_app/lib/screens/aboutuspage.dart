import 'package:flutter/material.dart';


class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi siamo'),
        backgroundColor: Colors.green,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Benvenuto nella nostra app!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Questa applicazione è stata creata per aiutarti a gestire le tue attività quotidiane in modo semplice ed efficace.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Versione 1.0.0',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}