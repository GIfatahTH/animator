import 'package:flutter/material.dart';
import 'pages/opacity.dart';
import 'pages/rotation.dart';
import 'pages/scale.dart';
import 'pages/translation.dart';
import 'pages/multi_tween.dart';
import 'pages/flutter_animation.dart';
import 'pages/explicit_like.dart';

class BasicAnimation1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Animator Demo',
        home: Scaffold(
          appBar: AppBar(
            title: Text("Animator demo"),
          ),
          body: MyHomePage(),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  goto(Widget page, BuildContext context) {
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
        children: <Widget>[
          RaisedButton(
            child: Text("Opacity Animation"),
            onPressed: () => goto(OpacityAnimation(), context),
          ),
          RaisedButton(
            child: Text("Rotation Animation"),
            onPressed: () => goto(RotationAnimation(), context),
          ),
          RaisedButton(
            child: Text("Scale Animation"),
            onPressed: () => goto(ScaleAnimation(), context),
          ),
          RaisedButton(
            child: Text("Translation Animation"),
            onPressed: () => goto(TranslateAnimation(), context),
          ),
          RaisedButton(
            child: Text("Multi Tween Animation"),
            onPressed: () => goto(MultiTweenAnimation(), context),
          ),
          RaisedButton(
            child: Text("Flutter Animation"),
            onPressed: () => goto(FlutterAnimation(), context),
          ),
          RaisedButton(
            child: Text("Explicit-like Animation"),
            onPressed: () => goto(ExplicitAnimation(), context),
          )
        ],
      ),
    );
  }
}
