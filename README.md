# animator
[![pub package](https://img.shields.io/pub/v/animator.svg)](https://pub.dev/packages/animator)
[![CircleCI](https://circleci.com/gh/GIfatahTH/animator.svg?style=svg)](https://circleci.com/gh/GIfatahTH/animator)
[![codecov](https://codecov.io/gh/GIfatahTH/animator/branch/master/graph/badge.svg)](https://codecov.io/gh/GIfatahTH/animator)


This library is an animation library for Flutter that:
  * makes animation as simple as the simplest widget in Flutter with the help of Animator widget,
  * Allows you to control (forward, stop, inverse), reconfigure, reset and restart animation from buttons, or events callbacks.
  * Perform implicit and explicit animation without limitation.

This library exposes two widgets, `Animator`, ane `AnimateWidget`
* `Animator` is the first introduced widget. It allows for explicit animation.
* `AnimateWidget` the the new widget which is more powerful than `Animator`. It is used for both implicit animation and explicit and staggered animation.

# AnimateWidget
## setting animation parameters
AnimateWidget exposes the following parameters to set your animation:
```dart
AnimateWidget({
    Key? key, 
    double? initialValue, // (1)
    double lowerBound = 0.0, // (1)
    double upperBound = 1.0, // (1)

    Duration duration = const Duration(milliseconds: 500),  // (2)
    Duration? reverseDuration,  // (2)

    Curve curve = Curves.linear,  // (3)
    Curve? reverseCurve, // (3)

    AnimationBehavior animationBehavior = AnimationBehavior.normal, // (4)

    int? repeats, // (5)
    int? cycles, // (5)

    void Function()? endAnimationListener, // (6)

    bool triggerOnInit = true, // (7)
    bool triggerOnRebuild = false, // (7)
    bool resetOnRebuild = false, // (7)
    required Widget Function(BuildContext, Animate) builder,// (8)
  }
)
```
* (1) Optionally you can set the `initialValue`, `lowerBound`, `upperBound` to be taken by the `AnimationController`.
* (2) `duration` and `reverseDuration` are the global (default) durations of the animation in the forward and reverse path. If `reverseDuration` is not set (or is null) the value of `duration` will be used for both forward and reverse path. The value of `duration` and `reverseDuration` can be overridden for any value. (see later).
* (3) `curve` and `reverseCurve` are the global (default) curves of the animation in the forward and reverse path. If `reverseCurve` is not set (or is null) the value of `curve` will be used for both forward and reverse path. The value of `curve` and `reverseCurve` can be overridden for any value. (see later).
* (4) `animationBehavior` has similar meaning as in Flutter animationBehavior (The behavior of the controller when `AccessibilityFeatures.disableAnimations` is true).
* With `cycles` argument (5) you define the number of the forward and backward periods you want your animation to perform before stopping.
* With `repeats` argument (5) you define the number of forward periods you want your animation to perform before stopping.
* With `endAnimationListener` (6) argument you can define a VoidCallback to be executed when the animation is finished. For example, it can be used to trigger another animation.
* You can control when animation starts (7) using : 
  *  **triggerOnInt:** When set to true, animation will auto start after first initialized. The default value is true.
  *  **triggerOnRebuild:** When set to true, animation will try to trigger on rebuild. If animation is completed (stopped at the upperBound) then the animation is reversed, and if the animation is dismissed (stopped at the lowerBound) then the animation is forwarded. IF animation is running nothing will happen. Default value is false.
  *  **resetOnRebuild:** When set to true, animation will reset and restart from its lowerBound.
* In the `builder` argument (8) you put your widgets to be animated.
  ```dart
      AnimateWidget(
        builder : (BuildContext context, Animate animate) {
            //Implicit animation
            final T value =  animate.call(select? 0 : 100);
            ///Two value of the same type must be distinguished using an arbitrary name
            final T otherValue =  animate.call(select? 0 : 100, 'Other value');


            //Explicit animation
            final T value =  animate.fromTween((currentValue)=> Tween(begin:0, end: 100));

            //Use predefined flutter FooTransition widget
            ScaleTransition(
              scale : animate.curvedAnimation
              child: ...
            )
        },
        child : MayWidget(), //widget to not rebuild with animation
    )
  ```
## Implicit animation
With animator you can do any kind of implicit animation without been constrained to fined a dedicated Flutter widget of type AnimatedFoo such as `AnimatedContainer`, `AnimatedPositioned` and so on.


Let's reproduce the `AnimatedContainer` example in official Flutter docs.  ([link here](https://api.flutter.dev/flutter/widgets/AnimatedContainer-class.html)).

In Flutter `AnimatedContainer` example, we see:

```dart
Center(
    child: AnimatedContainer(
        duration: const Duration(seconds: 2),
        curve: Curves.fastOutSlowIn,
        width: selected ? 200.0 : 100.0,
        height: selected ? 100.0 : 200.0,
        color: selected ? Colors.red : Colors.blue,
        alignment: selected ? Alignment.center : AlignmentDirectional.topCenter,
        child: const FlutterLogo(size: 75),
    ),
),
```

With `animateWidget, we simply use the `Container` widget :

```dart
Center(
    child: AnimatedWidget(
        duration: const Duration(seconds: 2),
        curve: Curves.fastOutSlowIn,
        (context, animate) => Container(
            // Animate is a callable class
            width: animate.call(selected ? 200.0 : 100.0),
            height: animate(selected ? 100.0 : 200.0, 'height'),
            color: animate(selected ? Colors.red : Colors.blue),
            alignment: animate(selected ? Alignment.center : AlignmentDirectional.topCenter),
            child: const FlutterLogo(size: 75),
        ),
    );
),
```
- Using the exposed `animate` function, we set the animation start and end values.
- As the width and height are the same type (double), we need to add a name to distinguish them.

> You can implicitly animate any type. Here we implicitly animated a `double`, `Color`, and `Alignment` values. If you want to animate two parameters of the same type, you just add a dummy name to distinguish them.

That's all, you are not limited to use a widget that starts with Animated prefix to use implicit animation.

[Here is the full working example](examples/animatedWidget/ex_001_animated_container).
## Explicit animation


In explicit animation you have full control on how to parametrize your animation using tweens.

```dart
AnimatedWidget(
    duration: const Duration(seconds: 2),
    (context, animate) {
      final angle = animate.fromTween(
          (currentValue) => Tween(begin: 0, end: 2 * 3.14),
      )!;

      return Transform.rotate(
        angle: angle,
        child: const FlutterLogo(size: 75),
      );
    },
);
```

- The `FlutterLogo` will rotate from 0 to 2 * 3.14 (one turn)
- The `fromTween` exposes the current value of the angle. It may be used to animate from the current value to the next value. (See the example below)


[Here is the full working example](examples/animatedWidget/ex_002_explicit_animation).

## Use of Flutter's transition widgets

You can use built-in flutter's `FooTransition` widget such as `PositionedTransition`, `AlignTransition` ..:

The following example is the same example of `PositionedTransition` in flutter docs rewritten using states_rebuilder. ([Link here](https://api.flutter.dev/flutter/widgets/PositionedTransition-class.html)).

```dart
 AnimateWidget(
   (context, animate) => PositionedTransition(
     rect: RelativeRectTween(
       begin: RelativeRect.fromSize( const Rect.fromLTWH(0, 0, smallLogo, smallLogo), biggest),
       end: RelativeRect.fromSize(
         Rect.fromLTWH(
           biggest.width - bigLogo, biggest.height - bigLogo, bigLogo, bigLogo),
           biggest),
     ).animate(animate.curvedAnimation),
     child: const Padding(padding: EdgeInsets.all(8), child: FlutterLogo()),
   ),
 );
```
[Here is the full working example](examples/animatedWidget/ex_003_positioned_transition).

> For rebuild performance use `Child`, `Child2` and `Child3` widget.

[Here an example of clock app](examples/animatedWidget/ex_006_timer).

## staggered Animation

You can specify for each animate value, its onw `curve` and `reverseCurve` using `setCurve` and `setReverseCurve`.

This is the same example as in [Flutter docs for staggered animation](https://flutter.dev/docs/development/ui/animations/staggered-animations):


```dart
class _MyStaggeredWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {});
      },
      child: AnimateWidget(
        duration: const Duration(milliseconds: 2000),
        cycles: 2,
        triggerOnRebuild: true,
        triggerOnInit: false,
        builder: (context, animate) {
          final padding = animate
              .setCurve(Interval(0.250, 0.375, curve: Curves.ease))
              .fromTween(
                (_) => EdgeInsetsTween(
                  begin: const EdgeInsets.only(bottom: 16.0),
                  end: const EdgeInsets.only(bottom: 75.0),
                ),
              );
          final opacity = animate
              .setCurve(Interval(0.0, 0.100, curve: Curves.ease))
              .fromTween(
                (_) => Tween<double>(begin: 0.0, end: 1.0),
              )!;
          final containerWidget = animate
              .setCurve(Interval(0.125, 0.250, curve: Curves.ease))
              .fromTween(
                (_) => Tween<double>(begin: 50.0, end: 150.0),
                'width',
              )!;
          final containerHeight = animate
              .setCurve(Interval(0.250, 0.375, curve: Curves.ease))
              .fromTween(
                (_) => Tween<double>(begin: 50.0, end: 150.0),
                'height',
              )!;
          final color = animate
              .setCurve(Interval(0.500, 0.750, curve: Curves.ease))
              .fromTween(
                (_) => ColorTween(
                  begin: Colors.indigo[100],
                  end: Colors.orange[400],
                ),
              );
          final borderRadius = animate
              .setCurve(Interval(0.375, 0.500, curve: Curves.ease))
              .fromTween(
                (_) => BorderRadiusTween(
                  begin: BorderRadius.circular(4.0),
                  end: BorderRadius.circular(75.0),
                ),
              );
          return Center(
            child: Container(
              width: 300.0,
              height: 300.0,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                border: Border.all(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              child: Container(
                padding: padding,
                alignment: Alignment.bottomCenter,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: containerWidget,
                    height: containerHeight,
                    decoration: BoxDecoration(
                      color: color,
                      border: Border.all(
                        color: Colors.indigo[300]!,
                        width: 3.0,
                      ),
                      borderRadius: borderRadius,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
```

[Here is the full working example](examples/animatedWidget/ex_004_staggered_animation).

One of the particularities of Animator is that you can use staggered animation with implicitly animated widget. [Here is the above example with implicit staggered animation](examples/animatedWidget/ex_005_staggered_implicit_animation)

## Examples:
* [Implicit Animation](examples/animatedWidget/ex_001_animated_container).
* [Explicit animation](examples/animatedWidget/ex_002_explicit_animation).
* [Animation using PositionedTransition](examples/animatedWidget/ex_003_positioned_transition).
* [Explicit staggered animation](examples/animatedWidget/ex_004_staggered_animation).
* [Implicit staggered animation](examples/animatedWidget/ex_005_staggered_implicit_animation)
* [Clock](examples/animatedWidget/ex_006_timer)
* [3D button](examples/animatedWidget/ex_007__3d_button)



̉# Animator:

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