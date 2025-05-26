import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _loadName() async {
    final sp = await SharedPreferences.getInstance();
    _controller.text = sp.getString('username') ?? '';
  }

  Future<void> _saveName() async {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      final sp = await SharedPreferences.getInstance();
      await sp.setString('username', name);
      Navigator.pop(context, true); // torna con esito positivo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 238),
      appBar: AppBar(title: Text('Edit Page',style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold),),
      backgroundColor:  const Color.fromARGB(255, 250, 250, 238),),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 10,),
            TextField(
              controller: _controller,
              cursorColor: Colors.black54,
              decoration: InputDecoration(
                labelText: 'Insert the new name',
                labelStyle: TextStyle(color: Colors.black54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54, ), 
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide( color: Colors.green),
                )
                ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 107, 165, 109),
                  foregroundColor: Colors.black54,),
              onPressed: _saveName,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}