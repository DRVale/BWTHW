import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_app/screens/editprofilepage.dart';


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
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      _currentName = sp.getString('username') ?? '';
    });
  }

    Future<void> _goToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage()),
    );
    if (result == true) {
      _loadCurrentName();
      Navigator.pop(context, true); // notifica alla home che qualcosa è cambiato
    }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color.fromARGB(255, 250, 250, 238),
      appBar: AppBar(title:  Text('Profile',style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold),),
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
              controller: _controller,
              decoration:  InputDecoration(
                labelText: _currentName,
                labelStyle: TextStyle(color: Colors.black54),
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