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


