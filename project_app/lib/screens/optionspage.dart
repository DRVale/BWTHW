import 'package:flutter/material.dart';
import 'package:project_app/screens/graphpage.dart';
import 'package:project_app/screens/historypage.dart';
import 'package:project_app/models/customnavigationbar.dart';


class OptionsPage extends StatelessWidget {
  const OptionsPage({Key? key}) : super(key: key);

  static const routename = 'OptionsPage';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('OptionsPage'),
      ),
      body: CustomNavigationBar(
        goToPage1: () => _toGraphPage(context), 
        goToPage2: () => _toHistoryPage(context),
      ),
    );
    
  }

  void _toGraphPage(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => GraphPage()));
  }
  void _toHistoryPage(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HistoryPage()));
  }
}