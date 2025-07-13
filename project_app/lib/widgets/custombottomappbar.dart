import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatelessWidget {

  // list of elements to show
  final List<String> tabnames;

  // index currently selected
  final int currentIndex;

  // action to perform on tap -> change index
  final Function(int) callback;

  const CustomBottomAppBar({
    super.key, 
    required this.tabnames,
    required this.currentIndex,
    required this.callback,
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
            .asMap() 
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
                      color: currentIndex == k? Colors.black54 : Colors.grey,
                      fontWeight: currentIndex == k? FontWeight.bold : null
                    )
                  ),
                ),
              ),
            )
            .values
            .toList(),

        ),
      ),   
    );
  }

  void showPopup(BuildContext context, String message, bool isLeft) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 80,
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

