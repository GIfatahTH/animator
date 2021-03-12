import 'package:flutter/material.dart';
import 'pages/opacity.dart';
import 'pages/random_flutter_walk.dart';
import 'pages/rotation.dart';
import 'pages/scale.dart';
import 'pages/translation.dart';
import 'pages/multi_tween.dart';
import 'pages/flutter_animation.dart';
import 'pages/animator_key.dart';

class BasicAnimation1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animator demo"),
      ),
      body: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  void goto(Widget page, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ElevatedButton(
            child: Text("Opacity Animation"),
            onPressed: () => goto(OpacityAnimation(), context),
          ),
          ElevatedButton(
            child: Text("Rotation Animation"),
            onPressed: () => goto(RotationAnimation(), context),
          ),
          ElevatedButton(
            child: Text("Scale Animation"),
            onPressed: () => goto(ScaleAnimation(), context),
          ),
          ElevatedButton(
            child: Text("Translation Animation"),
            onPressed: () => goto(TranslateAnimation(), context),
          ),
          ElevatedButton(
            child: Text("Multi Tween Animation"),
            onPressed: () => goto(MultiTweenAnimation(), context),
          ),
          ElevatedButton(
            child: Text("Flutter Animation"),
            onPressed: () => goto(FlutterAnimation(), context),
          ),
          ElevatedButton(
            child: Text("Animation with AnimatorKey"),
            onPressed: () => goto(AnimationWithAnimatorKey(), context),
          ),
          ElevatedButton(
            child: Text("Random Flutter walk"),
            onPressed: () => goto(RandomFlutterWalk(), context),
          )
        ],
      ),
    );
  }
}
