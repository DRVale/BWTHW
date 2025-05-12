import 'package:flutter/material.dart';

class BoxPage extends StatelessWidget {
  final String mensa;

  const BoxPage({super.key, required this.mensa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Box: $mensa')),
      body: Center(
        child: Text('Hai selezionato la mensa $mensa',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}