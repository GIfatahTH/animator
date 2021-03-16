import 'dart:math';

import 'package:flutter/material.dart';
import 'package:animator/animator.dart';

class FlutterAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Animation"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: MyAnimation());
  }
}

class MyAnimation extends StatefulWidget {
  @override
  _MyAnimationState createState() => _MyAnimationState();
}

class _MyAnimationState extends State<MyAnimation> {
  final _flutterLog150 =
      FlutterLogo(size: 150, style: FlutterLogoStyle.horizontal);

  final _flutterLog300 =
      FlutterLogo(size: 300, style: FlutterLogoStyle.horizontal);
  String animationSwitcher = 'opacity';
  String animationName = 'Opacity';

  changeAnimation(String switcher, String name) {
    setState(() {
      animationSwitcher = switcher;
      animationName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _child;
    switch (animationSwitcher) {
      case "opacity":
        _child = Animator<double>(
          key: Key('opacity'),
          duration: Duration(seconds: 2),
          endAnimationListener: (_) => changeAnimation('rotation1', 'Rotation'),
          cycles: 3,
          builder: (_, animatorState, __) => FadeTransition(
            opacity: animatorState.animation,
            child: _flutterLog150,
          ),
        );
        break;
      case "rotation1":
        _child = Animator<double>(
          key: Key('rotation1'),
          tween: Tween<double>(begin: 0, end: 2 * pi),
          curve: Curves.bounceIn,
          duration: Duration(seconds: 2),
          repeats: 2,
          endAnimationListener: (_) => changeAnimation('rotation2', 'Rotation'),
          builder: (_, animatorState, __) {
            return Transform.rotate(
              angle: animatorState.value,
              child: _flutterLog150,
            );
          },
        );
        break;
      case "rotation2":
        _child = Animator<double>(
          key: Key('rotation2'),
          tween: Tween<double>(begin: 0, end: 4 * pi),
          duration: Duration(seconds: 1),
          repeats: 2,
          endAnimationListener: (_) => changeAnimation('scaling1', 'Scaling'),
          builder: (_, animatorState, __) {
            return Transform.rotate(
              angle: -animatorState.value,
              child: _flutterLog150,
            );
          },
        );
        break;
      case "scaling1":
        _child = Animator<double>(
          key: Key('scaling1'),
          tween: Tween<double>(begin: 1, end: 0.5),
          duration: Duration(seconds: 1),
          cycles: 4,
          endAnimationListener: (_) => changeAnimation('scaling2', 'Scaling'),
          builder: (_, animatorState, __) {
            return Transform.scale(
              scale: animatorState.value,
              child: _flutterLog150,
            );
          },
        );
        break;
      case "scaling2":
        _child = Animator<double>(
          key: Key('scaling2'),
          tween: Tween<double>(begin: 1, end: 2),
          duration: Duration(seconds: 1),
          cycles: 3,
          endAnimationListener: (_) => changeAnimation('clipping1', 'clipping'),
          builder: (_, animatorState, __) {
            return Transform.scale(
              scale: animatorState.value,
              child: _flutterLog150,
            );
          },
        );
        break;
      case "clipping1":
        _child = Animator<double>(
          key: Key('clipping1'),
          tween: Tween<double>(begin: 1, end: 0),
          duration: Duration(seconds: 1),
          cycles: 2,
          endAnimationListener: (_) => changeAnimation('clipping2', 'clipping'),
          builder: (_, animatorState, __) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizeTransition(
                      sizeFactor: animatorState.animation,
                      child: _flutterLog300,
                    ),
                  ],
                ),
              ],
            );
          },
        );
        break;
      case "clipping2":
        _child = Animator<double>(
          key: Key('clipping2'),
          tween: Tween<double>(begin: 1, end: 0),
          duration: Duration(seconds: 1),
          cycles: 2,
          endAnimationListener: (_) => changeAnimation('skew1', 'Skew'),
          builder: (_, animatorState, __) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizeTransition(
                      sizeFactor: animatorState.animation,
                      axis: Axis.horizontal,
                      child: _flutterLog300,
                    ),
                  ],
                ),
              ],
            );
          },
        );
        break;
      case "skew1":
        _child = Animator<double>(
          key: Key('skew1'),
          tween: Tween<double>(begin: 0, end: 0.2),
          duration: Duration(seconds: 1),
          cycles: 2,
          endAnimationListener: (_) => changeAnimation('skew2', 'Skew'),
          builder: (_, animatorState, __) {
            return Transform(
              transform: Matrix4.skewX(animatorState.value),
              child: _flutterLog300,
            );
          },
        );
        break;
      case "skew2":
        _child = Animator<double>(
          key: Key('skew2'),
          tween: Tween<double>(begin: 0, end: 0.2),
          duration: Duration(seconds: 1),
          cycles: 2,
          endAnimationListener: (_) =>
              changeAnimation('translation1', 'Translation'),
          builder: (_, animatorState, __) {
            return Transform(
              transform: Matrix4.skewY(animatorState.value),
              child: _flutterLog300,
            );
          },
        );
        break;
      case "translation1":
        _child = Animator<Offset>(
          key: Key('translation1'),
          tween: Tween<Offset>(begin: Offset(0, 0), end: Offset(1.5, 0)),
          duration: Duration(seconds: 3),
          curve: Curves.elasticIn,
          cycles: 1,
          endAnimationListener: (_) =>
              changeAnimation('translation2', 'Translation'),
          builder: (_, animatorState, __) {
            return FractionalTranslation(
              translation: animatorState.value,
              child: _flutterLog300,
            );
          },
        );
        break;
      case "translation2":
        _child = Animator<Offset>(
          key: Key('translation2'),
          tween: Tween<Offset>(begin: Offset(-1.5, 0), end: Offset(0, 0)),
          duration: Duration(seconds: 3),
          curve: Curves.elasticOut,
          cycles: 1,
          endAnimationListener: (_) =>
              changeAnimation('opacity2', 'Multi Tweens'),
          builder: (_, animatorState, __) {
            return FractionalTranslation(
              translation: animatorState.value,
              child: _flutterLog300,
            );
          },
        );
        break;
      case "opacity2":
        _child = Animator<double>(
          key: Key('opacity2'),
          tween: Tween<double>(begin: 1, end: 0),
          endAnimationListener: (_) =>
              changeAnimation('multi1', 'Multi Tweens'),
          builder: (_, animatorState, __) {
            return FadeTransition(
              opacity: animatorState.animation,
              child: _flutterLog300,
            );
          },
        );
        break;
      case "multi1":
        Center(
          child: _child = Animator<double>(
            key: Key('multi1'),
            tweenMap: {
              "opacity": Tween<double>(begin: 0.2, end: 1),
              "rotation": Tween<double>(begin: 0, end: 2 * pi),
              "color": ColorTween(begin: Colors.blueAccent, end: Colors.white),
              "scale": Tween<double>(begin: 1, end: 5),
            },
            duration: Duration(seconds: 3),
            endAnimationListener: (_) =>
                changeAnimation('multi2', 'Multi Tweens'),
            builder: (context, animatorState, child) => FadeTransition(
              opacity: animatorState.getAnimation("opacity"),
              child: Transform.rotate(
                angle: animatorState.getValue("rotation"),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent, shape: BoxShape.circle),
                    ),
                    Transform.scale(
                      scale: animatorState.getValue<double>('scale'),
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: animatorState.getValue<Color>('color'),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        break;
      case "multi2":
        _child = Animator<double>(
          key: Key('multi2'),
          tweenMap: {
            "opacity": Tween<double>(begin: 1, end: 0.2),
            "rotation": Tween<double>(begin: 0, end: 2 * pi),
            "color": ColorTween(begin: Colors.white, end: Colors.blueAccent),
            "scale": Tween<double>(begin: 5, end: 1),
          },
          duration: Duration(seconds: 3),
          endAnimationListener: (_) => changeAnimation('opacity', 'Opacity'),
          builder: (_, animatorState, __) => FadeTransition(
            opacity: animatorState.getAnimation('opacity'),
            child: Transform.rotate(
              angle: animatorState.getValue<double>('rotation'),
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                        color: Colors.blueAccent, shape: BoxShape.circle),
                  ),
                  Transform.scale(
                    scale: animatorState.getValue<double>('scale'),
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: animatorState.getValue('color'),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        break;
      default:
        _child = Text("hooooops");
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          animationName,
          style: TextStyle(fontSize: 35),
        ),
        Divider(),
        Expanded(
          child: _child,
        ),
      ],
    );
  }
}
