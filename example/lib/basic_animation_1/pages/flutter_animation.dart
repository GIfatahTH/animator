import 'dart:math';

import 'package:flutter/material.dart';
import 'package:animator/animator.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class MyBloc extends StatesRebuilder {
  String animationSwitcher = 'opacity';
  String animationName = 'Opacity';

  changeAnimation(String switcher, String name) {
    animationSwitcher = switcher;
    animationName = name;
    rebuildStates(['myAnimation']);
  }
}

MyBloc myBloc = MyBloc();

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
    return StateBuilder(
      tag: 'myAnimation',
      models: [myBloc],
      builder: (_, __) => Center(child: MyAnimation()),
    );
  }
}

class MyAnimation extends StatelessWidget {
  final _flutterLog150 =
      FlutterLogo(size: 150, style: FlutterLogoStyle.horizontal);
  final _flutterLog300 =
      FlutterLogo(size: 300, style: FlutterLogoStyle.horizontal);
  @override
  Widget build(BuildContext context) {
    Widget _child;
    switch (myBloc.animationSwitcher) {
      case "opacity":
        _child = Animator(
          key: UniqueKey(),
          duration: Duration(seconds: 2),
          endAnimationListener: (_) =>
              myBloc.changeAnimation('rotation1', 'Rotation'),
          cycles: 3,
          builder: (anim) => FadeTransition(
            opacity: anim,
            child: _flutterLog150,
          ),
        );
        break;
      case "rotation1":
        _child = Animator(
          key: UniqueKey(),
          tween: Tween<double>(begin: 0, end: 2 * pi),
          curve: Curves.bounceIn,
          duration: Duration(seconds: 2),
          repeats: 2,
          endAnimationListener: (_) =>
              myBloc.changeAnimation('rotation2', 'Rotation'),
          builder: (anim) {
            return Transform.rotate(
              angle: anim.value,
              child: _flutterLog150,
            );
          },
        );
        break;
      case "rotation2":
        _child = Animator(
          key: UniqueKey(),
          tween: Tween<double>(begin: 0, end: 4 * pi),
          duration: Duration(seconds: 1),
          repeats: 2,
          endAnimationListener: (_) =>
              myBloc.changeAnimation('scaling1', 'Scaling'),
          builder: (anim) {
            return Transform.rotate(
              angle: -anim.value,
              child: _flutterLog150,
            );
          },
        );
        break;
      case "scaling1":
        _child = Animator(
          key: UniqueKey(),
          tween: Tween<double>(begin: 1, end: 0.5),
          duration: Duration(seconds: 1),
          cycles: 4,
          endAnimationListener: (_) =>
              myBloc.changeAnimation('scaling2', 'Scaling'),
          builder: (anim) {
            return Transform.scale(
              scale: anim.value,
              child: _flutterLog150,
            );
          },
        );
        break;
      case "scaling2":
        _child = Animator(
          key: UniqueKey(),
          tween: Tween<double>(begin: 1, end: 2),
          duration: Duration(seconds: 1),
          cycles: 3,
          endAnimationListener: (_) =>
              myBloc.changeAnimation('clipping1', 'clipping'),
          builder: (anim) {
            return Transform.scale(
              scale: anim.value,
              child: _flutterLog150,
            );
          },
        );
        break;
      case "clipping1":
        _child = Animator(
          key: UniqueKey(),
          tween: Tween<double>(begin: 1, end: 0),
          duration: Duration(seconds: 1),
          cycles: 2,
          endAnimationListener: (_) =>
              myBloc.changeAnimation('clipping2', 'clipping'),
          builder: (anim) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizeTransition(
                      sizeFactor: anim,
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
        _child = Animator(
          key: UniqueKey(),
          tween: Tween<double>(begin: 1, end: 0),
          duration: Duration(seconds: 1),
          cycles: 2,
          endAnimationListener: (_) => myBloc.changeAnimation('skew1', 'Skew'),
          builder: (anim) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizeTransition(
                      sizeFactor: anim,
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
        _child = Animator(
          key: UniqueKey(),
          tween: Tween<double>(begin: 0, end: 0.2),
          duration: Duration(seconds: 1),
          cycles: 2,
          endAnimationListener: (_) => myBloc.changeAnimation('skew2', 'Skew'),
          builder: (anim) {
            return Transform(
              transform: Matrix4.skewX(anim.value),
              child: _flutterLog300,
            );
          },
        );
        break;
      case "skew2":
        _child = Animator(
          key: UniqueKey(),
          tween: Tween<double>(begin: 0, end: 0.2),
          duration: Duration(seconds: 1),
          cycles: 2,
          endAnimationListener: (_) =>
              myBloc.changeAnimation('translation1', 'Translation'),
          builder: (anim) {
            return Transform(
              transform: Matrix4.skewY(anim.value),
              child: _flutterLog300,
            );
          },
        );
        break;
      case "translation1":
        _child = Animator(
          key: UniqueKey(),
          tween: Tween<Offset>(begin: Offset(0, 0), end: Offset(1.5, 0)),
          duration: Duration(seconds: 3),
          curve: Curves.elasticIn,
          cycles: 1,
          endAnimationListener: (_) =>
              myBloc.changeAnimation('translation2', 'Translation'),
          builder: (anim) {
            return FractionalTranslation(
              translation: anim.value,
              child: _flutterLog300,
            );
          },
        );
        break;
      case "translation2":
        _child = Animator(
          key: UniqueKey(),
          tween: Tween<Offset>(begin: Offset(-1.5, 0), end: Offset(0, 0)),
          duration: Duration(seconds: 3),
          curve: Curves.elasticOut,
          cycles: 1,
          endAnimationListener: (_) =>
              myBloc.changeAnimation('opacity2', 'Multi Tweens'),
          builder: (anim) {
            return FractionalTranslation(
              translation: anim.value,
              child: _flutterLog300,
            );
          },
        );
        break;
      case "opacity2":
        _child = Animator(
          key: UniqueKey(),
          tween: Tween<double>(begin: 1, end: 0),
          endAnimationListener: (_) =>
              myBloc.changeAnimation('multi1', 'Multi Tweens'),
          builder: (anim) {
            return FadeTransition(
              opacity: anim,
              child: _flutterLog300,
            );
          },
        );
        break;
      case "multi1":
        Center(
          child: _child = Animator(
            key: UniqueKey(),
            tweenMap: {
              "opacity": Tween<double>(begin: 0.2, end: 1),
              "rotation": Tween<double>(begin: 0, end: 2 * pi),
              "color": ColorTween(begin: Colors.blueAccent, end: Colors.white),
              "scale": Tween<double>(begin: 1, end: 5),
            },
            duration: Duration(seconds: 3),
            endAnimationListener: (_) =>
                myBloc.changeAnimation('multi2', 'Multi Tweens'),
            builderMap: (anim) => FadeTransition(
              opacity: anim["opacity"],
              child: Transform.rotate(
                angle: anim["rotation"].value,
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
                      scale: anim['scale'].value,
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: anim["color"].value,
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
        _child = Animator(
          key: UniqueKey(),
          tweenMap: {
            "opacity": Tween<double>(begin: 1, end: 0.2),
            "rotation": Tween<double>(begin: 0, end: 2 * pi),
            "color": ColorTween(begin: Colors.white, end: Colors.blueAccent),
            "scale": Tween<double>(begin: 5, end: 1),
          },
          duration: Duration(seconds: 3),
          endAnimationListener: (_) =>
              myBloc.changeAnimation('opacity', 'Opacity'),
          builderMap: (anim) => FadeTransition(
            opacity: anim["opacity"],
            child: Transform.rotate(
              angle: anim["rotation"].value,
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
                    scale: anim['scale'].value,
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: anim["color"].value,
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
          myBloc.animationName,
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
