# animator

This library is an animation library for Flutter that:
  * makes animation as simple as the simplest widget in Flutter with the help of Animator widget,
  * Allows you to declare all animation setup in your logic classes (BloCs) and animate you widgets.

In flutter animation can be classified:
  * Implicit: such as AnimatedContaine, AnimatedPadding, AnimatedPositioned and AnimatedDefaultTextStyle.
  * Explicit: Where you define AnimationController, Animation and Tween classes, and you should explicitly start, stop and listen to animation status.

Following the same fashion, the Animator package offers implicit-like and explicit-like animation

# Implicit-like animation:

With one widget, `Animator`, you can do all the available animation in Flutter.

  ```dart
Animator({
  Key key, 
  Tween<dynamic> tween, // (1) // Default tween: Tween<double>(begin:0 end: 1)
  Duration duration: const Duration(milliseconds: 500),  // (2)
  Curve curve: Curves.linear, // (3)
  int cycles, // (4)
  int repeats: 1, // (5)
  (Animation<dynamic>) → Widget builder, // (6)
  Map<String, Tween<dynamic>> tweenMap, () → void endAnimationListener, // (7)
  (Map<String, Animation<dynamic>>) → Widget builderMap, // (8)
  () → void endAnimationListener, // (10)
})
  ```

To implement any type of animation with animator you have to define a `Tween` (1), `Duration` (2) and `Curve` (3). `

With `cycles` argument (4) you define the number of forward and backward periods you want your animation to perform before stopping.

With `repeats` argument (5) you define the number of forward periods you want your animation to perform before stopping.

In the `builder` argument (6) you put your widgets to be animated. The builder is a function with Animation argument.

If you want to animate many Tween, use `tweenMap` argument (7). Is is a Map of String type keys and Tween type values. In this case you have to use `builderMap` (8) insteat of `builder` (6). 

With `endAnimationListener` (10) argument you can define a VoidCallback to be executed when animation is finished. For example, it can be used to trigger another animation.

## Example of a single Tween animation:

```dart
import 'package:flutter/material.dart';
import 'package:animator/animator.dart';

void main() => runApp(AnimatedLogo());

class AnimatedLogo extends StatelessWidget {
  Widget build(BuildContext context) {
    return Animator(
      tween: Tween<double>(begin: 0, end: 300),
      cycles: 0,
      builder: (anim) => Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              height: anim.value,
              width: anim.value,
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
      builderMap: (anim) => Center(
            child: FractionalTranslation(
              translation: anim["translateAnim"].value,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: anim["scaleAnim"].value,
                width: anim['scaleAnim'].value,
                child: FlutterLogo(),
              ),
            ),
          ),
    );
  }
}
```

# Explicit-like animation:
With implicit-like animation you can implement almost all the available animation type in Flutter. However if you want more control over your animation use Explicit-like animation. 

In any of your logic classes, instantiate the `AnimationSetup` and assign it to a variable.

```dart
AnimationSetup({
        Tween<dynamic> tween, 
        Duration duration: const Duration(milliseconds: 500), 
        Curve curve: Curves.linear,
        Map<String, Tween<dynamic>> tweenMap, 
})
```

You have five methods: 

1-	`initAnimation` : to initialize animation by adding listener

```dart
initAnimation({
    StatesRebuilder bloc, 
    List<State<StatefulWidget>> states, // reference to widgets to be rebuild each frame.
    List<String> ids, // reference to widgets to be rebuild each frame.
    bool trigger: false, // Auto start animation if trigger is true
    int cycles, 
    int repeats, 
    bool dispose: false // Dispose animation after it is finished
    (AnimationSetup) → dynamic customListener, // any custom animation listener
    () → void endAnimationListener,
})
```

2-	`addListners`: to aAdd listners you want to calls every time animation ticks.

```dart
addListners({
    List<State<StatefulWidget>> states, 
    List<String> ids, 
    StatesRebuilder bloc, 
bool reset: true
})
```
3-	`changeAnimatioSetup`:  to change any of the animation parameters. such as tween, duration, curve, cycles and repeats

```dart
changeAnimatioSetup({
    Tween<dynamic> tween, 
    Map<String, Tween<dynamic>> tweenMap, 
    bool resetTweenMap: false, 
    Duration duration, 
    Curve curve, 
    bool trigger: false, 
    int cycles, 
    int repeats, 
    bool dispose: false,
    (AnimationSetup) → dynamic customListener, 
    () → void endAnimationListener
})
```
4-	`triggerAnimation` : to starts running this animation forwards (towards the end).
```dart
triggerAnimation({
        int cycles, 
        int repeats, 
        bool dispose: false
    })
```

5-	`disposeAnimation()` : to remove listener, statusListner and dispose the animation controller.

## Implicet animation example:
 ```dart
 import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animator/animator.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class MyBloc extends StatesRebuilder {
  final myAnimation = AnimationSetup(
    tweenMap: {
      "opacityAnim": Tween<double>(begin: 0.5, end: 1),
      "rotationAnim": Tween<double>(begin: 0, end: 2 * pi),
      "translateAnim": Tween<Offset>(begin: Offset.zero, end: Offset(1, 0)),
    },
    duration: Duration(seconds: 2),
  );
  init() {
    myAnimation.initAnimation(
      bloc: this,
      ids: ["OpacityWidget", "RotationWidget"],
      cycles: 3,
      endAnimationListener: () => print("animation finished"),
    );
  }
}

MyBloc myBloc;

class FlutterAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      initState: (_) => myBloc = MyBloc(),
      dispose: (_) => myBloc = null,
      builder: (_) => Scaffold(
            appBar: AppBar(
              title: Text("Flutter Animation"),
            ),
            body: Padding(
              padding: EdgeInsets.all(20),
              child: MyHomePage(),
            ),
          ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      initState: (_) => myBloc.init(),
      dispose: (_) => myBloc.myAnimation.disposeAnimation(),
      stateID: 'myAnimation',
      blocs: [myBloc],
      builder: (_) => Center(child: MyAnimation()),
    );
  }
}

class MyAnimation extends StatelessWidget {
  final _flutterLog100 =
      FlutterLogo(size: 150, style: FlutterLogoStyle.horizontal);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RaisedButton(
        child: Text("Animate"),
        onPressed: () => myBloc.myAnimation.triggerAnimation(),
      ),
      StateBuilder(
        key: Key("opacity"),
        stateID: "OpacityWidget",
        blocs: [myBloc],
        builder: (anim) => FadeTransition(
              opacity: myBloc.myAnimation.animationMap["opacityAnim"],
              child: FractionalTranslation(
                translation: myBloc.myAnimation.valueMap["translateAnim"],
                child: _flutterLog100,
              ),
            ),
      ),
      StateBuilder(
        key: Key("rotation"),
        stateID: "RotationWidget",
        blocs: [myBloc],
        builder: (anim) {
          return Container(
            child: FractionalTranslation(
              translation: myBloc.myAnimation.valueMap["translateAnim"],
              child: Transform.rotate(
                angle: myBloc.myAnimation.valueMap['rotationAnim'],
                child: _flutterLog100,
              ),
            ),
          );
        },
      )
    ]);
  }
}
 
 ```








