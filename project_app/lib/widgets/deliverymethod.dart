import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryMethod extends StatelessWidget {

  final bool isSelected;
  final IconData iconType;
  final String method;

  const DeliveryMethod({
    Key? key,
    required this.isSelected,
    required this.iconType,
    required this.method,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected? Color.fromARGB(10, 0, 255, 0) : Colors.white,
        border: Border.all(
          color: isSelected? Colors.green : Colors.black54
        ),
        boxShadow: [ if(isSelected) 
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          )
        ]
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconType,
            color: isSelected? Colors.green : Colors.black54,
          ),
          Text(
            method,
            style: TextStyle(
              color: isSelected? Colors.green : Colors.black54
            ),
          ),
        ],
      ),
    );
  }
}

// DELIVERY STORAGE: per memorizzare nelle SP il numero di consegne effettuate e mostrarle nella HP
 
class DeliveryStorage {
  static const String totalKey = 'total_deliveries';
  static const String methodPrefix = 'delivery_';
  

  Future<void> recordDelivery(String method) async {
    final prefs = await SharedPreferences.getInstance();

    // Totale
    final total = prefs.getInt(totalKey) ?? 0;
    await prefs.setInt(totalKey, total + 1);

    // Specifico per metodo
    final methodKey = '$methodPrefix$method';
    final count = prefs.getInt(methodKey) ?? 0;
    await prefs.setInt(methodKey, count + 1);
  }

  Future<int> getTotalDeliveries() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(totalKey) ?? 0;
  }

  Future<Map<String, int>> getMethodCounts(List<String> methods) async {
    final prefs = await SharedPreferences.getInstance();
    final map = <String, int>{};
    for (final method in methods) {
      final methodKey = '$methodPrefix$method';
      map[method] = prefs.getInt(methodKey) ?? 0;
    }
    return map;
  }
}



