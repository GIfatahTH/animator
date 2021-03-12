import 'dart:math';

import 'package:flutter/material.dart';
import 'package:animator/animator.dart';

class RandomFlutterWalk extends StatefulWidget {
  @override
  _RandomFlutterWalkState createState() => _RandomFlutterWalkState();
}

class _RandomFlutterWalkState extends State<RandomFlutterWalk> {
  double beginX = 0.0;
  double beginY = 0.0;
  double endX = Random().nextDouble() * 50;
  double endY = Random().nextDouble() * 50;
  int seconds = Random().nextInt(1000);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Animator<Offset>(
        tween: Tween<Offset>(
            begin: Offset(beginX, beginY), end: Offset(endX, endY)),
        duration: Duration(milliseconds: 500 + seconds),
        curve: seconds % 2 == 0 ? Curves.linear : Curves.easeInOut,
        resetAnimationOnRebuild: true,
        triggerOnInit: true,
        cycles: 1,
        builder: (_, animatorState, __) => Transform.translate(
          offset: animatorState.value,
          child: FlutterLogo(
            size: 50,
          ),
        ),
        statusListener: (status, setup) {
          if (status == AnimationStatus.completed) {
            setState(() {
              final sign = Random().nextBool() ? 1 : -1;
              beginX = endX;
              beginY = endY;
              double nextEndX = endX + sign * Random().nextDouble() * 50;
              double nextEndY = endY + sign * Random().nextDouble() * 50;

              nextEndX = nextEndX > screenSize.width - 50
                  ? screenSize.width - 50
                  : nextEndX;
              nextEndX = nextEndX < 0 ? 0 : nextEndX;
              nextEndY = nextEndY > screenSize.height - 50
                  ? screenSize.width - 50
                  : nextEndY;
              nextEndY = nextEndY < 0 ? 0 : nextEndY;

              endX = nextEndX;
              endY = nextEndY;
              seconds = Random().nextInt(8);
            });
          }
        },
      ),
    );
  }
}
