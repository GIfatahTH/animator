import 'package:example/basic_animatio_3/main.dart';
import 'package:flutter/material.dart';
import 'basic_animation_0/main.dart';
import 'basic_animation_1/main.dart';
import 'basic_animation_2/nested_animator.dart';
// import 'basic_animation_2/nested_animator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animator Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Animator demo"),
        ),
        body: MyHomePage(),
      ),
    );
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
          ElevatedButton(
            child: Text("Basic Animation 0"),
            onPressed: () => goto(BasicAnimation0(), context),
          ),
          ElevatedButton(
            child: Text("Basic Animation 1"),
            onPressed: () => goto(BasicAnimation1(), context),
          ),
          ElevatedButton(
            child: Text("Basic Animation 2"),
            onPressed: () => goto(MyCustomPainterAnimation(), context),
          ),
          ElevatedButton(
            child: Text("Implicit animation"),
            onPressed: () => goto(BasicAnimation3(), context),
          ),
        ],
      ),
    );
  }
}
