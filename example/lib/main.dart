import 'package:flutter/material.dart';
import 'basic_animation_0/main.dart';
import 'basic_animation_1/main.dart';

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
          RaisedButton(
            child: Text("Basic Animation 0"),
            onPressed: () => goto(BasicAnimation0(), context),
          ),
          RaisedButton(
            child: Text("Basic Animation 1"),
            onPressed: () => goto(BasicAnimation1(), context),
          ),
        ],
      ),
    );
  }
}
