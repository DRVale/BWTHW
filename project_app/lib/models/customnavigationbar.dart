import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {

  final VoidCallback goToPage1;
  final VoidCallback goToPage2;

  // SE VOGLIAMO RIUTILIZZARE LA CustomNavigationBar, allora tocca mettere in input anche le icone e i nomi
  // final Widget icon1;
  // final Widget icon2;

  const CustomNavigationBar({
    super.key, 
    required this.goToPage1, 
    required this.goToPage2,
    // required this.icon1,
    // required this.icon2,
  });

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(

            onTap: goToPage1,

            child: Container(
              decoration: BoxDecoration(
                color:  const Color.fromARGB(255, 147, 223, 149),
                border: Border(
                  top: BorderSide(color: Colors.green),
                  left: BorderSide(color: Colors.green),
                  bottom: BorderSide(color: Colors.green),
                  //right: BorderSide(width: 0)
                ),
                //borderRadius: BorderRadius.only(topLeft: Radius.circular(50))
                borderRadius: BorderRadius.only(topLeft: Radius.elliptical(100, 100), bottomLeft: Radius.elliptical(100, 100),) // A me così piace di più che dritta
                // POI POSSIAMO CAMBIARE ALTEZZA E CURVATURA
              ),
              //height: screenHeight,
              height: 90,
              width: screenWidth/3,
              child: Center(
                child: Icon(Icons.auto_graph,color: Colors.black54 ,size: 35,)
              ),
              //color: Colors.red,
            ),


            ),
            
            Container(
              height: 90,
              width: screenWidth/3,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 147, 223, 149),
                border: Border(
                  top: BorderSide(color: Colors.green),
                  bottom: BorderSide(color: Colors.green),
                )
              ),              
              //color: Colors.red,
            ),

            InkWell(
            
            onTap: goToPage2,

            child: Container(
              
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 147, 223, 149),
                border: Border(
                  top: BorderSide(color: Colors.green),
                  right: BorderSide(color: Colors.green),
                  bottom: BorderSide(color: Colors.green),

                  //left: BorderSide(width: 0)
                ),
                borderRadius: BorderRadius.only(topRight: Radius.elliptical(100,100),bottomRight:Radius.elliptical(100, 100) )
              ),
              height: 90,
              width: screenWidth/3,
              child: Center(
                child: Icon(Icons.history,color: Colors.black54, size: 35,)
              ),
              //color: Colors.red,
            )

            ),
           SizedBox(height: 145,) 
          ],
        ),
      ),
    );
  }
}

