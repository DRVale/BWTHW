import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// DELIVERY STORAGE: per memorizzare nelle SP il numero di consegne effettuate e mostrarle nella HP
class DeliveryStorage {
  static const String totalKey = 'total_deliveries';

  Future<void> recordDelivery(String method) async {
    final prefs = await SharedPreferences.getInstance();

    // Increasing total counter
    final total = prefs.getInt(totalKey) ?? 0;
    await prefs.setInt(totalKey, total + 1);

    // Increasing deliveries counters
    final count = prefs.getInt(method) ?? 0;
    await prefs.setInt(method, count + 1);
  }

  // Check SP and return the total number of deliveries.
  Future<int> getTotalDeliveries() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(totalKey) ?? 0;
  }

  // Check SP and create a map containing methods and their counts. 
  Future<Map<String, int>> getMethodCounts(List<String> methods) async {
    final prefs = await SharedPreferences.getInstance();
    final map = <String, int>{};
    for (final method in methods) {
      map[method] = prefs.getInt(method) ?? 0;
    }
    return map;
  }
}

// CLASS FOR GRAPHICAL OVERVIEW OF THE COUNTER-DIGITS:
class FlipDigit extends StatelessWidget {
  final String digit;

  const FlipDigit({super.key, required this.digit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 43, 42, 42),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Text(
        digit,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Courier',
        ),
      ),
    );
  }
}


//Displays a number with as many digits as needed
class FlipCounter extends StatelessWidget {
  final int value;

  const FlipCounter({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final digits = value.toString().padLeft(2, '0').split('');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: digits.map((d) => FlipDigit(digit: d)).toList(),
    );
  }
}


//ORGANIZES COUNTERS WITH LABELS 
class DeliveryCounterPanel extends StatelessWidget {
  final int total;
  final Map<String, int> perMethod;

  const DeliveryCounterPanel({
    super.key,
    required this.total,
    required this.perMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //border: Border.all(color: const Color.fromARGB(255, 6, 108, 10)),
        //color: Colors.green,
        borderRadius: BorderRadius.circular(10),
        shape: BoxShape.rectangle,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Totale consegne
          const Text(
            "Total deliveries:  ",
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          FlipCounter(value: total),
          const SizedBox(height: 12),
      
          // // Consegne per metodo (in una riga orizzontale)
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: perMethod.entries.map((entry) {
          //     return Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Text(
          //           entry.key,
          //           style: const TextStyle(fontSize: 14),
          //         ),
          //         const SizedBox(height: 2),
          //         FlipCounter(value: entry.value),
          //       ],
          //   );
          //   }).toList(),
          // ),
          // SizedBox(height: 16)
      ],
      ),
    );
  }
}