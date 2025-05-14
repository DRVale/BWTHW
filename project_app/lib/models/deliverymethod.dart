import 'package:flutter/material.dart';

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
      width: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected? Color.fromARGB(10, 0, 255, 0) : Colors.white,
        border: Border.all(
          color: isSelected? Colors.green : Colors.black
        ),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconType,
            color: isSelected? Colors.green : Colors.black,
          ),
          Text(
            method,
            style: TextStyle(
              color: isSelected? Colors.green : Colors.black
            ),
          ),
        ],
      ),
    );
  }
}


