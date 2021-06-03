import 'dart:math';

import 'package:flutter/material.dart';
import 'package:animator/animator.dart';

class RandomFlutterWalk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Random Walk'),
        ),
        body: Child(
          child: FlutterLogo(
            size: 50,
          ),
          builder: (child) => Animator<Offset>(
            tween: Tween<Offset>(
              begin: Offset(0.0, 0.0),
              end: Offset(
                Random().nextDouble() * 50,
                Random().nextDouble() * 50,
              ),
            ),
            duration: Duration(milliseconds: 500 + Random().nextInt(1000)),
            curve: Curves.linear,
            // resetAnimationOnRebuild: true,
            triggerOnInit: true,
            // cycles: 1,
            builder: (_, animatorState, __) {
              return Transform.translate(
                offset: animatorState.value,
                child: child,
              );
            },
            statusListener: (status, animatorState) {
              print('beginX ${animatorState.value.dx}');

              if (status == AnimationStatus.completed) {
                final sign = Random().nextBool() ? 1 : -1;
                final beginX = animatorState.value.dx;
                final beginY = animatorState.value.dy;
                double endX = beginX + sign * Random().nextDouble() * 50;
                double endY = beginY + sign * Random().nextDouble() * 50;

                endX =
                    endX > screenSize.width - 50 ? screenSize.width - 50 : endX;
                endX = endX < 0 ? 0 : endX;
                endY = endY > screenSize.height - 50
                    ? screenSize.width - 50
                    : endY;
                endY = endY < 0 ? 0 : endY;
                // animatorState.endX = nextEndX;
                // endY = nextEndY;
                final milliseconds = Random().nextInt(1000);
                animatorState
                  ..resetAnimation(
                    tween: Tween<Offset>(
                      begin: Offset(beginX, beginY),
                      end: Offset(endX, endY),
                    ),
                    curve: beginY != 0 || beginY != 0
                        ? Curves.easeInOut
                        : Curves.bounceIn,
                    duration: Duration(milliseconds: 500 + milliseconds),
                  )
                  ..triggerAnimation();
              }
            },
          ),
        ));
  }
}
