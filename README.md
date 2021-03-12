# animator
[![pub package](https://img.shields.io/pub/v/animator.svg)](https://pub.dev/packages/animator)
[![CircleCI](https://circleci.com/gh/GIfatahTH/animator.svg?style=svg)](https://circleci.com/gh/GIfatahTH/animator)
[![codecov](https://codecov.io/gh/GIfatahTH/animator/branch/master/graph/badge.svg)](https://codecov.io/gh/GIfatahTH/animator)


This library is an animation library for Flutter that:
  * makes animation as simple as the simplest widget in Flutter with the help of Animator widget,
  * Allows you to control (forward, stop, inverse), reconfigure, reset and restart animation from buttons, or events callbacks.

# Animator:

With one widget, `Animator`, you can do all the available animation in Flutter. 

Actually, Animator is a facade that hides all the complexity of the animation setting in Flutter.
In the design pattern the facade pattern is :
>Facade is a structural design pattern that provides a simplified interface to a library, a framework, or any other complex set of classes.


  ```dart
Animator({
    Key key, 
    Tween<dynamic> tween, // (1) // Default tween: Tween<double>(begin:0 end: 1)
    Map<String, Tween<dynamic>> tweenMap, // (1)
    Duration duration: const Duration(milliseconds: 500),  // (2)
    Curve curve: Curves.linear, // (3)
    int cycles, // (4)
    int repeats, // (5)
    (BuildContext, AnimatorState, child) → Widget builder, // (6)
    Widget child, // (7)
    () → void endAnimationListener, // (8)
    dynamic customListener,  // (9)
    (AnimationStatus, AnimationSetup) → dynamic statusListener //(10)
    bool triggerOnInit: true, () // (11)
    bool resetAnimationOnRebuild: false, // (12)
    TickerMixin tickerMixin, // (13)
    AnimatorKey animatorKey, // (14)
})
  ```

* To implement any type of animation with animator you have to define a `Tween` (1), `Duration` (2), and `Curve` (3). `

* With `cycles` argument (4) you define the number of the forward and backward periods you want your animation to perform before stopping.

* With `repeats` argument (5) you define the number of forward periods you want your animation to perform before stopping.

* In the `builder` argument (6) you put your widgets to be animated.
  ```dart
      Animator<T>(
        builder : (BuildContext context, AnimatorState animatorState, Widget child) {
            //to get animation value:
            final T value =  animatorState.value;
            //to get Animation object:
            final Animation<T> animation = animatorState.animation;
            //to get AnimationController object:
            final AnimationController animation = animatorState.controller;
            //to get animation value form tweenMap
            final R value = animatorState.getValue<R>('animName');
            //To get Animation object from tweenMap
            final Animation<R> value =animatorState.getAnimation<R>('animName');
        },
        child : MayWidget(), //widget to not rebuild with animation
    )
  ```

* If you want to animate many Tween, use `tweenMap` argument (2). It is a Map of String type keys and Tween type values. 
* With `endAnimationListener` (8) argument you can define a VoidCallback to be executed when the animation is finished. For example, it can be used to trigger another animation.

* With `customListener` (9) argument you can define a function to be called every time the animation value changes. The customListener is provided with an Animation object.

* With `statusListener` (10) argument, you can define a function to be called every time the status of the animation change. The customListener is provided with an AnimationStatus, AnimationSetup objects.

* `triggerOnInit` (11) controls whether the animation is automatically started when the Animator widget is initialized. The default value is true.

* If you want to reset your animation, such as changing your Tween or duration, and want the new setting to be reconsidered when the Animator widget is rebuilt, set the `resetAnimationOnRebuild` (12) argument to true. The default value is false. (See `AnimatorKey`)
 
* The right `TickerProvider` is chosen by animator:(13)
  * If animation is simple the `singleTickerProviderStateMixin`.
  * If you define the animatorKey parameter or set `resetAnimationOnRebuild`, animator use `tickerProviderStateMixin`.

* With `animationKey` (14), you can associate an `Animator` widget to an `AnimatorKey`. Doing so, you can control (forward, start, stop, reverse) animation from callbacks outside the Animator widget, you can even reset the animation parameter (tween, duration curve, repeats, cycles) on the fly. (See example below)

## Example of a single Tween animation:

```dart
import 'package:flutter/material.dart';
import 'package:animator/animator.dart';

void main() => runApp(AnimatedLogo());

class AnimatedLogo extends StatelessWidget {
  Widget build(BuildContext context) {
    return Animator<double>(
      tween: Tween<double>(begin: 0, end: 300),
      cycles: 0,
      builder: (context, animatorState, child ) => Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              height: animatorState.value,
              width: animatorState.value,
              child: FlutterLogo(),
            ),
          ),
    );
  }
}
```

## Example of a multi-tween animation:

```dart
import 'package:flutter/material.dart';
import 'package:animator/animator.dart';

void main() => runApp(AnimatedLogo());

class AnimatedLogo extends StatelessWidget {
  Widget build(BuildContext context) {
    return Animator(
      tweenMap: {
        "scaleAnim": Tween<double>(begin: 0, end: 300),
        "translateAnim": Tween<Offset>(begin: Offset.zero, end: Offset(2, 0)),
      },
      cycles: 0,
      builder: (context, animatorState, child ) => Center(
            child: FractionalTranslation(
              translation: animatorState.getAnimation<double>('translateAnim'),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: animatorState.getAnimation<Offset>('scaleAnim'),
                width:  animatorState.getAnimation<Offset>('scaleAnim'),
                child: FlutterLogo(),
              ),
            ),
          ),
    );
  }
}
```

You can nest many animators with a different setting (tween, duration, curve, repeats, and cycles) to do a complex animation:

This is a simple example of how to animate the scale and rotation independently.

```dart
import 'package:flutter/material.dart';
import 'package:animator/animator.dart';

void main() => runApp(AnimatedLogo());

class AnimatedLogo extends StatelessWidget {
  Widget build(BuildContext context) {
    return Animator<double>(
      tween: Tween<double>(begin: 0, end: 300),
      repeats: 0,
      duration: Duration(seconds: 2),
      builder: (context, anim1, child ) => Animator<double>(
        tween: Tween<double>(begin: -1, end: 1),
        cycles: 0,
         builder: (context, anim2, child ) => Center(
          child: Transform.rotate(
            angle: anim2.value,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              height: anim1.value,
              width: anim1.value,
              child: FlutterLogo(),
            ),
          ),
        ),
      ),
    );
  }
}
```
Use nested Animators with CustomPainter and CustomClipper and draw the animation you want.

# AnimatorKey
Similarly to Flutter global key. AnimatorKey allows controlling the animation from outside the Animator widget it is associated with.

Example:
```dart
final animatorKey = AnimatorKey();

//..
//..
Animator(
    animatorKey: animatorKey,
    builder: (context, anim, child) {
        //....
    }
)

//By default, the animation will not start when the Animator is inserted in the widget tree.
//To start the animation from some Button in the widget tree outside the builder of the Animator.

onPressed: (){
    animatorKey.triggerAnimation();

    //You can  forward, start, reverse animation
    animatorKey.controller.stop,
    

    //You can configure the animation online and reset the setting and restart the animation
    animatorKey.refreshAnimation(
        tween: Tween(...),//new tween
        duration : Duration(...),
        curve : Curve(...),
        repeats : ....,
        cycles : ...
    );

}
```

# AnimatorRebuilder widget

The AnimatorRebuilder widget can subscribe to an “AnimatorKey”. It will be animated in synchronization with the Animator widget with which `animatorKey` is associated.
Example:

```dart
//In AnimatorKey you can provide the initial values of the animation.
final animatorKey = AnimatorKey<T>(initialValue: 10);

//..
//..
Animator(
    animatorKey: animatorKey,
    builder: (context, anim, child) {
        //....
    }
);
//

//In another place in the widget tree : 

AnimatorRebuilder(
    observe:()=> animatorKey,
    builder: (context, anim, child) {
        //....
        //this widget receives the same animation object of the Animator above.
    }
);
```

The order of Animator and AnimatorRebuilder in the widget tree is irrelevant, except in the case, AnimatorRebuilder is first inserted in the widget tree, you have to provide initial values in AnimatorKey to avoid null exceptions.


## Example of Flutter log random walk

```dart
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

```