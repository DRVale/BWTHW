import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatelessWidget {

  // final VoidCallback toPage1;
  // final VoidCallback toPage2;
  // final VoidCallback toPage1;
  // final VoidCallback toPage2;

  // list of elements to show
  final List<String> tabnames;
  // index currently selected
  final int currentIndex;
  // action to perform on tap -> change index
  final Function(int) callback;

  // SE VOGLIAMO RIUTILIZZARE LA CustomNavigationBar, allora tocca mettere in input anche le icone e i nomi
  // final Widget icon1;

  const CustomBottomAppBar({
    super.key, 
    // required this.toPage1, 
    // required this.toPage2,

    required this.tabnames,
    required this.currentIndex,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    //return BottomNavigationBar(items: items)
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
      height: 80,
      
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
                  tabnames
                      .asMap() // i need the index of the element so i transform the list to a dict/map
                      .map(
                        (k, e) => MapEntry(
                          k,
                          TextButton(
                            onPressed: () => callback(k),
                            onLongPress: () {
                              bool isLeft = currentIndex == k? true : false;
                              showPopup(context, 'Do something', isLeft);
                            },
                            child: Text(
                              e,
                              style:
                              TextStyle(
                                color: currentIndex == k? Colors.black : Colors.grey,
                                fontWeight: currentIndex == k? FontWeight.bold : null
                              )
                            ),
                          ),
                        ),
                      )
                      .values
                      .toList(),












            /*
            // [
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
            // Expanded(
            //   child: InkWell(
            //     onTap: toPage1,
            //     child: Align(
            //       alignment: Alignment(-0.5, 0),
            //       child: Column(
            //         children: [
            //           Icon(
            //               Icons.history, 
            //               color: Colors.black54,
            //               size: 30,
            //             ),
            //           Text('Homepage')
            //         ],
            //       )
            //     ),
            //   ),
            // ),

            // Space between the buttons
            //SizedBox(width: 150),
            // // Space between the buttons
            // //SizedBox(width: 150),
        
            // Right side of the bar
            Expanded(child: 
              InkWell(
              onTap: toPage2,
              child: Center(child: Icon(Icons.history,color: Colors.black54 ,size: 30,)),
              ),
            ),
          ],
          */
            // // Right side of the bar
            // Expanded(
            //   child: InkWell(
            //     onTap: toPage2,
            //     child: Center(
            //       child: Icon(
            //         Icons.history,
            //         color: Colors.black54,
            //         size: 30,
            //       )
            //     ),
            //   ),
            // ),
          // ],
        ),
      ),   
    );
  }

  void showPopup(BuildContext context, String message, bool isLeft) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 80, // Adjust as needed
        left: isLeft? 20 : MediaQuery.of(context).size.width - 140,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}

