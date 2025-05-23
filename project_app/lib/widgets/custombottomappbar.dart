import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatelessWidget {

  final VoidCallback toPage1;
  final VoidCallback toPage2;

  // SE VOGLIAMO RIUTILIZZARE LA CustomNavigationBar, allora tocca mettere in input anche le icone e i nomi
  // final Widget icon1;
  // final Widget icon2;

  const CustomBottomAppBar({
    super.key, 
    required this.toPage1, 
    required this.toPage2,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const AutomaticNotchedShape(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.elliptical(20, 30),
              topRight: Radius.elliptical(20, 30)
            ),
            //borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          StadiumBorder(),
      ),
      notchMargin: 5,
      color: const Color.fromARGB(255, 147, 223, 149),
      elevation: 10,
      height: 80,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side of the bar
            Expanded(child:
              InkWell(
              onTap: toPage1,
              child: Align(
                alignment: Alignment(-0.5, 0),
                child: Icon(Icons.auto_graph,color: Colors.black54 ,size: 30,)
                ),
              ),
            ),

            // Space between the buttons
            //SizedBox(width: 150),
        
            // Right side of the bar
            Expanded(child: 
              InkWell(
              onTap: toPage2,
              child: Center(child: Icon(Icons.history,color: Colors.black54 ,size: 30,)),
              ),
            ),
          ],
        ),
      ),   
    );
  }
}

