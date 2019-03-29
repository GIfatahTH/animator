import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animator/animator.dart';

class MultiTweenAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multi Tween'),
      ),
      body: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          "1- Two tweens: Opacity + Translation",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Animator(
          tweenMap: {
            "opacity": Tween<double>(begin: 0, end: 1),
            "translation": Tween<Offset>(begin: Offset.zero, end: Offset(4, 0))
          },
          cycles: 0,
          duration: Duration(seconds: 2),
          builderMap: (Map<String, Animation> anim) => FadeTransition(
                opacity: anim["opacity"],
                child: FractionalTranslation(
                  translation: anim["translation"].value,
                  child: FlutterLogo(
                    size: 50,
                  ),
                ),
              ),
        ),
        Divider(),
        Text(
          "2- Three tweens: Opacity + Translation + Rotation",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Animator(
          tweenMap: {
            "opacity": Tween<double>(begin: 0, end: 1),
            "translation": Tween<Offset>(begin: Offset.zero, end: Offset(4, 0)),
            "rotation": Tween<double>(begin: 0, end: 4 * pi),
          },
          cycles: 0,
          duration: Duration(seconds: 2),
          builderMap: (anim) => FadeTransition(
                opacity: anim["opacity"],
                child: FractionalTranslation(
                  translation: anim["translation"].value,
                  child: Transform.rotate(
                    angle: anim["rotation"].value,
                    child: FlutterLogo(
                      size: 50,
                    ),
                  ),
                ),
              ),
        ),
        Divider(),
        Text(
          "3- Four tweens: Opacity + Translation + Rotation + Color",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Animator(
          tweenMap: {
            "opacity": Tween<double>(begin: 0.2, end: 1),
            "translation": Tween<Offset>(begin: Offset.zero, end: Offset(6, 0)),
            "rotation": Tween<double>(begin: 0, end: 2 * pi),
            "color":
                ColorTween(begin: Colors.blueAccent, end: Colors.redAccent),
          },
          cycles: 0,
          duration: Duration(seconds: 3),
          builderMap: (anim) => FadeTransition(
                opacity: anim["opacity"],
                child: FractionalTranslation(
                  translation: anim["translation"].value,
                  child: Transform.rotate(
                    angle: anim["rotation"].value * 2.0,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: anim['color'].value,
                              shape: BoxShape.circle),
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ),
        Divider(),
        Text(
          "4- Five tweens: Opacity + Translation + Rotation + Color + Scale",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Animator(
          tweenMap: {
            "opacity": Tween<double>(begin: 0.2, end: 1),
            "translation": Tween<Offset>(begin: Offset.zero, end: Offset(6, 0)),
            "rotation": Tween<double>(begin: 0, end: 2 * pi),
            "color": ColorTween(begin: Colors.blueAccent, end: Colors.white),
            "scale": Tween<double>(begin: 1, end: 5),
          },
          cycles: 0,
          duration: Duration(seconds: 3),
          builderMap: (anim) => FadeTransition(
                opacity: anim["opacity"],
                child: FractionalTranslation(
                  translation: anim["translation"].value,
                  child: Transform.rotate(
                    angle: anim["rotation"].value * 2.0,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.blueAccent, shape: BoxShape.circle),
                        ),
                        Transform.scale(
                          scale: anim['scale'].value,
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: 10,
                            height: 10,
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
        ),
        Divider(),
      ],
    );
  }
}
