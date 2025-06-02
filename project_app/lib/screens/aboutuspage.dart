import 'package:flutter/material.dart';


class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color.fromARGB(255, 250, 250, 238),
      appBar: AppBar(title:  Text('About Us',style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold),),
      backgroundColor:  const Color.fromARGB(255, 250, 250, 238),),
      body: SingleChildScrollView(
        child: 
       Padding(
        padding: EdgeInsets.all(16.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
              'Welcome in our App!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
            ),
            SizedBox(height: 250),
            Row(
              children: [
                Icon(Icons.arrow_forward_ios_rounded, size: 17, color: Colors.green,),
                SizedBox(width: 4,),
                Text('Our goal: ', style: TextStyle(fontSize: 17, color: Colors.green, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
              ]
            ),
            SizedBox(height: 3,),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Our app was created with a simple but powerful mission: ',style: TextStyle(fontSize: 12, color: Colors.black54)),
                  TextSpan(text: 'to fight food waste while supporting those who need it most. ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
                  ]
                  ),
                  ),
            SizedBox(height: 13,),
            Row(
              children: [
                Icon(Icons.arrow_forward_ios_rounded, size: 17, color: Colors.green,),
                SizedBox(width: 4,),
                Text('How? ', style: TextStyle(fontSize: 17, color: Colors.green, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
              ]
            ),
            SizedBox(height: 3,),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Through partnerships with',style: TextStyle(fontSize: 12, color: Colors.black54)),
                  TextSpan(text:' affiliated canteens ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
                  TextSpan(text: ', we recover, ' ,style: TextStyle(fontSize: 12, color: Colors.black54)),
                  TextSpan(text: 'fresh, unserved meals and pack them into special boxes. ',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
                 ]
                  ),
                  ),
              SizedBox(height: 13,),
              Row(
              children: [
                Icon(Icons.arrow_forward_ios_rounded, size: 17, color: Colors.green,),
                SizedBox(width: 4,),
                Text("Our canteens: ", style: TextStyle(fontSize: 17, color: Colors.green, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
              ]
            ),
            SizedBox(height: 3,),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Our affiliated canteens are:', style: TextStyle(color: Colors.black54, fontSize: 12)),
                  TextSpan(text: ' Murialdo, Piovego, Pio X, Belzoni. ',style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.bold)),
                  TextSpan(text: ' Very famous around the students ;)', style: TextStyle(color: Colors.black54, fontSize: 12)),
                  ]
                  ),
                  ),
            
            SizedBox(height: 13,),
              Row(
              children: [
                Icon(Icons.arrow_forward_ios_rounded, size: 17, color: Colors.green,),
                SizedBox(width: 4,),
                Text('Where do the boxes go?', style: TextStyle(fontSize: 17, color: Colors.green, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
              ]
            ),
            SizedBox(height: 3,),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'These boxes are then delivered by you directly to ',style: TextStyle(fontSize: 12, color: Colors.black54)),
                  TextSpan(text: 'children, the elderly, and people in need', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
                  TextSpan(text: ', providing them with a',style: TextStyle(fontSize: 12, color: Colors.black54)),
                  TextSpan(text: ' balanced, healthy meal. ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
                  ]
                  ),
                  ),
            

            SizedBox(height: 13,),
              Row(
              children: [
                Icon(Icons.arrow_forward_ios_rounded, size: 17, color: Colors.green,),
                SizedBox(width: 4,),
                Text("What's in it for me? ", style: TextStyle(fontSize: 17, color: Colors.green, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
              ]
            ),
            SizedBox(height: 3,),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'But that’s not all: ',style: TextStyle(fontSize: 12, color: Colors.black54)),
                  TextSpan(text: 'each delivery is good for you too!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
                  TextSpan(text: ' By moving and staying active, the more deliveries you make, the more rewards you unlock. ',style: TextStyle(fontSize: 12, color: Colors.black54)),
                  TextSpan(text: 'the more rewards you unlock.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
                  TextSpan(text: ' Every day brings new surprises and prizes based on your commitment and consistency.',style: TextStyle(fontSize: 12, color: Colors.black54)),
                  ]
                  ),
                  ),
                  SizedBox(height: 13,),
            Row(
              children: [
                Icon(Icons.arrow_forward_ios_rounded, size: 17, color: Colors.green,),
                SizedBox(width: 4,),
                Text("Who can participate? ", style: TextStyle(fontSize: 17, color: Colors.green, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
              ]
            ),
            SizedBox(height: 3,),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Everyone’s invited to be part of the change! ',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54) ),
                  TextSpan(text: 'No matter your age or background, if you care about people and the planet, you can take part.',style: TextStyle(fontSize: 12, color: Colors.black54))
                  ]
                  ),
            ),
            SizedBox(height: 13,),
            Row(
              children: [
                Icon(Icons.arrow_forward_ios_rounded, size: 17, color: Colors.green,),
                SizedBox(width: 4,),
                Text("What are you waiting for? ", style: TextStyle(fontSize: 17, color: Colors.green, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
              ]
            ),
            SizedBox(height: 3,),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: ' A small act for you, a big impact for the community. Join the change, one box at a time.',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54) )]
                  ),
            ),
            SizedBox(height: 16),
            Center(child: 
            Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey),
            ),

            )
          ]
          )
          ),
      ),
          );
      }
          
}