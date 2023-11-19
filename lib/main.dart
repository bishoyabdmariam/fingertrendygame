import 'dart:async';
import 'dart:math';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;
  Map<int, Offset?> pointerPositions = {};
  Map<int, Color> pointerColors = {};
  int? selectedCircleIndex;
  bool animationInProgress = false;

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
        title: const Text('Choose One'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Listener(
              onPointerDown: (PointerDownEvent event) {
                setState(() {
                  int pointerId = event.pointer;
                  pointerPositions[pointerId] = event.localPosition;
                  pointerColors[pointerId] =
                      Color(Random().nextInt(0xFFFFFFFF)).withOpacity(1.0);
                });
              },
              onPointerMove: (PointerMoveEvent event) {
                setState(() {
                  int pointerId = event.pointer;
                  pointerPositions[pointerId] = event.localPosition;
                });
              },
              onPointerUp: (PointerUpEvent event) {
                // The animation and position selection will only occur when the button is pressed
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: Stack(
                  children: [
                    // Use a loop to create circular containers for each position in the list
                    for (MapEntry<int, Offset?> entry
                    in pointerPositions.entries)
                      if (entry.value != null)
                        Positioned(
                          left: entry.value!.dx - 25, // Adjust as needed
                          top: entry.value!.dy - 25, // Adjust as needed
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Larger circle around the chosen one
                              if (entry.key == selectedCircleIndex)
                                CircularRevealAnimation(
                                  animation: animationController,
                                  centerOffset: const Offset(0, 0),
                                  // Adjust as needed
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: pointerColors[entry.key]!,
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
                                      color: pointerColors[entry.key]!,
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
                                    color: pointerColors[entry.key]!,
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
          ),
          // Button Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  // Choose a random circle
                  setState(() {
                    selectedCircleIndex =
                        pointerPositions.keys.elementAt(Random().nextInt(pointerPositions.length));
                    animationInProgress = true;
                    // Start the animation
                    animationController.repeat();
                  });
                },
                icon: const Icon(Icons.shuffle),
              ),
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    // Reset the state variables
                    pointerPositions.clear();
                    pointerColors.clear();
                    selectedCircleIndex = null;
                    animationInProgress = false;

                    // Stop and reset the animation
                    animationController.stop();
                    animationController.reset();
                  });
                },
                child: const Icon(Icons.refresh),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
