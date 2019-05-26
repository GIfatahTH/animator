import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animator/animator.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class MyBloc extends AnimatorBloc with StatesRebuilder {
  MyBloc()
      : super(
          tweenMap: {
            "opacityAnim": Tween<double>(begin: 0.5, end: 1),
            "rotationAnim": Tween<double>(begin: 0, end: 2 * pi),
            "translateAnim":
                Tween<Offset>(begin: Offset.zero, end: Offset(1, 0)),
          },
          duration: Duration(seconds: 2),
        );

  init() {
    animator.initAnimation(
      bloc: this,
      states: ["OpacityWidget", "RotationWidget"],
      cycles: 3,
      endAnimationListener: (_) => print("animation finished"),
    );
  }
}

MyBloc myBloc = MyBloc();

class ExplicitAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Animation"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Animator(
          blocs: [myBloc],
          triggerOnInit: false,
          resetAnimationOnRebuild: false,
          builder: (_) => MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      initState: (_, __) => myBloc.init(),
      tag: 'myAnimation',
      blocs: [myBloc],
      builder: (_, __) => Center(child: MyAnimation()),
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
        onPressed: () => myBloc.triggerAnimation(),
      ),
      StateBuilder(
        tag: "OpacityWidget",
        blocs: [myBloc],
        builder: (_, __) => FadeTransition(
              opacity: myBloc.animator.animationMap["opacityAnim"],
              child: FractionalTranslation(
                translation: myBloc.animator.valueMap["translateAnim"],
                child: _flutterLog100,
              ),
            ),
      ),
      StateBuilder(
        tag: "RotationWidget",
        blocs: [myBloc],
        builder: (_, __) {
          return Container(
            child: FractionalTranslation(
              translation: myBloc.animator.valueMap["translateAnim"],
              child: Transform.rotate(
                angle: myBloc.animator.valueMap['rotationAnim'],
                child: _flutterLog100,
              ),
            ),
          );
        },
      )
    ]);
  }
}
