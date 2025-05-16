import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _controller = TextEditingController();
  String _currentName = '';

  @override
  void initState() {
    super.initState();
    _loadCurrentName();
  }

  Future<void> _loadCurrentName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentName = prefs.getString('username') ?? '';
      _controller.text = _currentName;
    });
  }

  Future<void> _saveUsername() async {
    if (_controller.text.trim().isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _controller.text.trim());
      Navigator.pop(context, true); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color.fromARGB(255, 250, 250, 238),
      appBar: AppBar(title: const Text('Change name',style: TextStyle(color: Colors.black54),),
      backgroundColor:  const Color.fromARGB(255, 250, 250, 238),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Insert your new name:',style: TextStyle(color: Colors.black54),),
            const SizedBox(height: 10),
            TextField(
              cursorColor: Colors.black,
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nuovo nome',
                labelStyle: TextStyle(color: Colors.green),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green)
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green)
                )
              )
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 107, 165, 109),
                  foregroundColor: Colors.black54,),
              onPressed: _saveUsername,
              child: const Text('Salva'),
            ),
          ],
        ),
      ),
    );
  }
}


/*
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routename = 'Homepage';

  @override
  Widget build(BuildContext context) {
    return Scaffold();
    
  }
}*/