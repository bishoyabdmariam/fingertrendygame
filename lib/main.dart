import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Offset> list = [];
  List<Color> colorList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drag Position Example'),
      ),
      body: GestureDetector(
        onPanStart: (DragStartDetails details) {
          setState(() {
            list.add(details.localPosition);
            var ix = Color(Random().nextInt(0xFFFFFFFF)).withOpacity(1.0);
            if(colorList.contains(ix)){
              print("bety");
            }
            colorList.add(ix);


          });
        },
        onPanEnd: (DragEndDetails details) {
          Timer(const Duration(seconds: 20), () {
            setState(() {
              // Keep a random circle and remove the rest
              if (list.isNotEmpty) {
                final randomIndex = Random().nextInt(list.length);
                list = [list[randomIndex]];
              }
            });
          });
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Stack(
            children: [
              // Use a loop to create circular containers for each position in the list
              for (int i = 0; i < list.length; i++)
                Positioned(
                  left: list[i].dx - 25, // Adjust as needed
                  top: list[i].dy - 25, // Adjust as needed
                  child: Stack(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorList[i], // Change the color as needed
                            width: 5, // Adjust the border width
                          ),
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                           // Use a random color
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Generate a random color
  void generateRandomColor() {
    colorList.add( Color(Random().nextInt(0xFFFFFFFF)).withOpacity(1.0));
  }
}
