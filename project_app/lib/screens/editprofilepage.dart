import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_app/providers/dataprovider.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final sp = await SharedPreferences.getInstance();
    _nameController.text = sp.getString('username') ?? '';
    _surnameController.text = sp.getString('surname') ?? '';
    _birthdateController.text = sp.getString('birthdate') ?? '';
  }

  Future<void> _saveData() async {
    final name = _nameController.text.trim();
    final surname = _surnameController.text.trim();
    final birthdate = _birthdateController.text.trim();
    if (name.isNotEmpty && surname.isNotEmpty && birthdate.isNotEmpty) {
      final sp = await SharedPreferences.getInstance();
      await sp.setString('username', name);
      await sp.setString('surname', surname);
      await sp.setString('birthdate', birthdate);
      Navigator.pop(context, true); // torna con esito positivo
    }

    // aggiunta chiamate per triggerare consumer
    await Provider.of<DataProvider>(context, listen: false).setName(context,_nameController.text);
    await Provider.of<DataProvider>(context, listen: false).setSurname(context,_surnameController.text);
    await Provider.of<DataProvider>(context, listen: false).setBirthdate(context);
  }

  // Future<void> _pickDate() async{
  //   DateTime? date = await showDatePicker(context: context, firstDate: DateTime(1900), lastDate: DateTime.now(), initialDate: DateTime(2000),
  //   builder: (BuildContext context, Widget? child) {
  //     return Theme(
  //       data: ThemeData.light().copyWith(
  //         primaryColor: Colors.green,
  //         colorScheme: ColorScheme.light(
  //           primary: Colors.green,
  //           onPrimary: Colors.white,
  //           surface: Color.fromARGB(255, 250, 250, 238),
  //           onSurface: Colors.black54,
  //         ),
  //         dialogBackgroundColor: Color.fromARGB(255, 250, 250, 238),
  //       ),
  //       child: child!
  //     );
  //   }
  // );
  // if (date != null) {
  //     _birthdateController.text = "${date.day}/${date.month}/${date.year}";
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 238),
      appBar: AppBar(title: Text('Change your profile',style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold),),
      backgroundColor:  const Color.fromARGB(255, 250, 250, 238),),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 10,),
            TextField(
              controller: _nameController,
              cursorColor: Colors.black54,
              decoration: InputDecoration(
                labelText: _nameController.text,
                hintText: 'Tap to Insert the new name',
                labelStyle: TextStyle(color: Colors.black54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54, ), 
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide( color: Colors.green),
                )
                ),
            ),
            
            SizedBox(height: 10,),
            TextField(
              controller: _surnameController,
              cursorColor: Colors.black54,
              decoration: InputDecoration(
                labelText: _surnameController.text,
                hintText: 'Tap to Insert the new surname',
                labelStyle: TextStyle(color: Colors.black54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54, ), 
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide( color: Colors.green),
                )
                ),
            ),
            
            SizedBox(height: 10,),
            // TextField(
            //   controller: _birthdateController,
            //   onTap: _pickDate,
            //   decoration: InputDecoration(
            //     labelText: _birthdateController.text,
            //     hintText: 'Tap to Insert the new birthdate',
            //     labelStyle: TextStyle(color: Colors.black54),
            //     enabledBorder: UnderlineInputBorder(
            //       borderSide: BorderSide(color: Colors.black54),
            //     ),
            //     focusedBorder: UnderlineInputBorder(
            //       borderSide: BorderSide(color: Colors.green),
            //     ),
            //   ),
            // ),
            Consumer<DataProvider>(builder: (context, data, child) {
              return TextField(
                controller: _birthdateController,
                readOnly: true,
                onTap: ()async{
                      await Provider.of<DataProvider>(context, listen: false).pickDate(context);
                      _birthdateController.text = data.first_birthdate!;
                    },
                decoration: InputDecoration(
                  //labelText: 'Birthdate',
                  hintText: 'Tap to Insert the new birthdate',
                  labelStyle: TextStyle(color: Colors.black54),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              );
            }),

            SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 107, 165, 109),
                  foregroundColor: Colors.black54,),
              onPressed: _saveData,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}