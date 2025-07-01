import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:project_app/screens/editprofilepage.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  String _currentName = '';
  String _currentSurname = '';
  String _currentBirthDate = '';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      _currentName = sp.getString('username') ?? '';
      _currentSurname = sp.getString('surname') ?? '';
      _currentBirthDate = sp.getString('birthdate') ?? '';
    });
  }

    Future<void> _goToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage()),
    );
    if (result == true) {
      _loadProfileData();
      Navigator.pop(context, true); // notifica alla home che qualcosa è cambiato
    }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color.fromARGB(255, 250, 250, 238),
      appBar: AppBar(title:  Text('My profile',style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold),),
      backgroundColor:  const Color.fromARGB(255, 250, 250, 238),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
             //Text('Current name: $_currentName' ,style: TextStyle(color: Colors.black54),),
             SizedBox(height: 10),
              TextField(
              readOnly: true,
              enabled: false,
              controller: _nameController,
              decoration:  InputDecoration(
                labelText: _currentName,
                labelStyle: TextStyle(color: Colors.black54),
                prefixIcon: Icon(Icons.person,color: Colors.green,size: 17,),
            ),),
            SizedBox(height: 10),
              TextField(
              readOnly: true,
              enabled: false,
              controller: _surnameController,
              decoration:  InputDecoration(
                labelText: _currentSurname,
                labelStyle: TextStyle(color: Colors.black54),
                prefixIcon: Icon(Icons.person,color: Colors.green,size: 17,),
            ),),
            SizedBox(height: 10),
              TextField(
              readOnly: true,
              enabled: false,
              controller: _birthdateController,
              decoration:  InputDecoration(
                labelText: _currentBirthDate,
                labelStyle: TextStyle(color: Colors.black54),
                prefixIcon: Icon(Icons.date_range,color: Colors.green,size: 17,),
            ),),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 107, 165, 109),
                  foregroundColor: Colors.black54,),
              onPressed: _goToEditProfile,
              child: const Text('Edit'),
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