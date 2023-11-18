import 'dart:async';
import 'dart:math';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;
  List<Offset> list = [];
  List<Color> colorList = [];
  int selectedCircleIndex = -1;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.bounceInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drag Position Example'),
      ),
      body: GestureDetector(
        onPanStart: (DragStartDetails details) {
          setState(() {
            list.add(details.localPosition);
            var ix = Color(Random().nextInt(0xFFFFFFFF)).withOpacity(1.0);
            colorList.add(ix);
          });
        },
        onPanEnd: (DragEndDetails details) {
          Timer(const Duration(seconds: 10), () {
            setState(() {
              // Keep a random circle and remove the rest
              if (list.isNotEmpty) {
                final randomIndex = Random().nextInt(list.length);
                selectedCircleIndex = randomIndex;
                animationController.repeat();
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
                    alignment: Alignment.center,
                    children: [
                      // Larger circle around the chosen one
                      if (i == selectedCircleIndex)
                        CircularRevealAnimation(
                          animation: animationController,
                          centerOffset: const Offset(0, 0), // Adjust as needed
                          // Adjust as needed
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colorList[i],
                                width: 5,
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorList[i],
                              width: 5,
                            ),
                          ),
                        ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorList[i],
                            width: 4,
                          ),
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
}
