# animator

[![CircleCI](https://circleci.com/gh/GIfatahTH/animator.svg?style=svg)](https://circleci.com/gh/GIfatahTH/animator)
[![codecov](https://codecov.io/gh/GIfatahTH/animator/branch/master/graph/badge.svg)](https://codecov.io/gh/GIfatahTH/animator)


This library is an animation library for Flutter that:
  * makes animation as simple as the simplest widget in Flutter with the help of Animator widget,
  * Allows you to declare all animation setup in your logic classes (BloCs) and animate you widgets.

In flutter animation can be classified:
  * Implicit: such as AnimatedContainer, AnimatedPadding, AnimatedPositioned and AnimatedDefaultTextStyle.
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
    int repeats, // (5)
    (Animation<dynamic>) → Widget builder, // (6)
    Map<String, Tween<dynamic>> tweenMap, // (7)
    (Map<String, Animation<dynamic>>) → Widget builderMap, // (8)
    () → void endAnimationListener, // (9)
    dynamic customListener,  // (10)
    (AnimationStatus, AnimationSetup) → dynamic statusListener //(11)
    bool triggerOnInit: true, () // (12)
    bool resetAnimationOnRebuild: false, // (13)
    String name, // (14)
    List<StatesRebuilder> blocs, // (15)
    TickerMixin tickerMixin, // (16)
})
  ```

To implement any type of animation with animator you have to define a `Tween` (1), `Duration` (2) and `Curve` (3). `

With `cycles` argument (4) you define the number of forward and backward periods you want your animation to perform before stopping.

With `repeats` argument (5) you define the number of forward periods you want your animation to perform before stopping.

In the `builder` argument (6) you put your widgets to be animated. The builder is a function with Animation argument.

If you want to animate many Tween, use `tweenMap` argument (7). Is is a Map of String type keys and Tween type values. In this case you have to use `builderMap` (8) instead of `builder` (6). 

With `endAnimationListener` (9) argument you can define a VoidCallback to be executed when animation is finished. For example, it can be used to trigger another animation.

With `customListener` (10) argument you can define a Function to be called every time the animation value changes. The customListener is provided with an Animation object.

With `statusListener` (11) argument you can define a Function to be called every time the status of the animation change. The customListener is provided with an AnimationStatus, AnimationSetup objects.

`triggerOnInit` (12) controls whether the animation is automatically started when Animator widget is initialized. The default value is true.

If you want to reset your animation, such as changing your Tween or duration, and want the new setting to be reconsidered when the Animator widget is rebuilt, set the `resetAnimationOnRebuild` (13) argument to true. The default value is false.

`name` is a unique name of your Animator widget. It is used to rebuild this widget from your logic classes.

`blocs` argument is a list of your logic classes you want to rebuild this widget from. The logic class should extend  `StatesRebuilder`of the states_rebuilder package.

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

You can nest many Animator with different setting (tween, duration, curve, repeats and cycles) to do a complex animation:

This is a simple example of how to animate the the scale and rotation independently.

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
      builder: (anim1) => Animator<double>(
        tween: Tween<double>(begin: -1, end: 1),
        cycles: 0,
        builder: (anim2) => Center(
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

# Explicit-like animation:
With implicit-like animation you can implement almost all the available animation type in Flutter. However if you want more control over your animation use Explicit-like animation. 

Your logic class should extends `StatesRebuilderWithAnimator` to get access to animator parameters and your UI should use `StateWithMixinBuilder` from the states_rebuilder package.

You have many methods available in the logic class: 

1-	`initAnimation` : to initialize animation.

```dart
void initAnimation([TickerProvider ticker])
```

3- 	`addAnimationListener`: to aAdd listeners you want to calls every time animation ticks.

```dart
void addAnimationListener(void Function() fn)
```

3- 	`addAnimationStatusListener`: to aAdd listeners you want to calls every time animation status changes.

```dart
void addAnimationStatusListener(void Function(AnimationStatus) fn)

```
4-	`endAnimationListener`: to aAdd listeners you want to calls The animation ends.

```dart
void endAnimationListener(void Function() fn)
```

3-	`triggerAnimation` : to starts running this animation forwards (towards the end).
```dart
void triggerAnimation({bool reset = false})
```

5-	`dispose()` : to dispose the animation controller.

## Implicit animation example:
 ```dart
 import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animator/animator.dart';
import 'package:states_rebuilder/states_rebuilder.dart';


class MyBloc extends StatesRebuilderWithAnimator {
  init(TickerProvider ticker) {
    animator.tweenMap = {
      "opacityAnim": Tween<double>(begin: 0.5, end: 1),
      "rotationAnim": Tween<double>(begin: 0, end: 2 * pi),
      "translateAnim": Tween<Offset>(begin: Offset.zero, end: Offset(1, 0)),
    };
    initAnimation(ticker);
    addAnimationListener(() {
      print(this);
      rebuildStates(["OpacityWidget", "RotationWidget"]);
    });
    animator.cycles = 3;
    // animator.duration = Duration(seconds: 2);

    endAnimationListener(() => print("animation finished"));
  }

  startAnimation([bool reset = false]) {
    triggerAnimation(reset: reset);
  }
}

class ExplicitAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Injector<MyBloc>(
      models: [() => MyBloc()],
      builder: (_, model) => Scaffold(
        appBar: AppBar(
          title: Text("Flutter Animation"),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: StateWithMixinBuilder(
            mixinWith: MixinWith.tickerProviderStateMixin,
            viewModels: [model],
            initState: (ctx, _, ticker) => model.init(ticker),
            dispose: (_, __, ___) => model.dispose(),
            builder: (_, __) => Center(child: MyAnimation()),
          ),
        ),
      ),
    );
  }
}

class MyAnimation extends StatelessWidget {
  final _flutterLog100 =
      FlutterLogo(size: 150, style: FlutterLogoStyle.horizontal);

  final model = Injector.get<MyBloc>();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RaisedButton(
        child: Text("Animate"),
        onPressed: () => model.triggerAnimation(),
      ),
      RaisedButton(
        child: Text("Reset and Animate"),
        onPressed: () => model.startAnimation(true),
      ),
      StateBuilder(
        tag: "OpacityWidget",
        blocs: [model],
        builder: (_, __) => FadeTransition(
          opacity: model.animationMap["opacityAnim"],
          child: FractionalTranslation(
            translation: model.animationMap["translateAnim"].value,
            child: _flutterLog100,
          ),
        ),
      ),
      StateBuilder(
        tag: "RotationWidget",
        blocs: [model],
        builder: (_, __) {
          return Container(
            child: FractionalTranslation(
              translation: model.animationMap["translateAnim"].value,
              child: Transform.rotate(
                angle: model.animationMap['rotationAnim'].value,
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
