import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_app/screens/editprofilepage.dart';
import 'package:project_app/providers/dataprovider.dart';
import 'package:provider/provider.dart';


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
      Navigator.pop(context, true);
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
            
            Consumer<DataProvider>(builder: (context, data, child) {
                return TextField(
                  controller: _birthdateController,
                  readOnly: true,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: _currentBirthDate, 
                    labelStyle: TextStyle(color: Colors.black54),
                    prefixIcon: Icon(Icons.edit_calendar,color: Colors.green,size: 17,),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                );
              }
            ),

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
