import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animator/animator.dart';

class TranslateAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Tween<Offset>'),
            Text('Translate'),
          ],
        ),
      ),
      body: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final _style = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
  final _titleStyle = TextStyle(fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            "1- offset. dur:2s , cycles = 0",
            style: _titleStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("FractionalTranslation", style: _style),
                  Animator<Offset>(
                    tween:
                        Tween<Offset>(begin: Offset(-1, 0), end: Offset(1, 0)),
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animatorState, __) => FractionalTranslation(
                      translation: animatorState.value,
                      child: FlutterLogo(
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("Transform.translate", style: _style),
                  Animator<Offset>(
                    tween: Tween<Offset>(
                        begin: Offset(-50, 0), end: Offset(50, 0)),
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animatorState, __) => Transform.translate(
                      offset: animatorState.value,
                      child: FlutterLogo(
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("SlideTransition", style: _style),
                  Animator<Offset>(
                    tween:
                        Tween<Offset>(begin: Offset(-1, 0), end: Offset(1, 0)),
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animatorState, __) => SlideTransition(
                      position: animatorState.animation,
                      child: FlutterLogo(
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          Divider(),
          Text(
            "2-Transform widget. Matrix4.translationValues.. dur:2s",
            style: _titleStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("cycles = 0", style: _style),
                  Animator<Offset>(
                    tween: Tween<Offset>(
                        begin: Offset(-50, 0), end: Offset(50, 0)),
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animatorState, __) => Transform(
                      transform: Matrix4.translationValues(
                          animatorState.value.dx, 0, 0),
                      child: FlutterLogo(
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("repeats = 0.", style: _style),
                  Animator<Offset>(
                    tween: Tween<Offset>(
                        begin: Offset(-50, 0), end: Offset(100, 0)),
                    duration: Duration(seconds: 2),
                    repeats: 0,
                    builder: (_, animatorState, __) => Transform(
                      transform: Matrix4.translationValues(
                          animatorState.value.dx, 0, 0),
                      child: FlutterLogo(
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          Divider(),
          Text(
            "3- FractionalTranslation widget. changing Offset",
            style: _titleStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("(-a, 0)=>(a, 0)", style: _style),
                  Animator<Offset>(
                    tween: Tween<Offset>(
                        begin: Offset(-0.5, 0), end: Offset(0.5, 0)),
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animatorState, __) => FractionalTranslation(
                      translation: animatorState.value,
                      child: FlutterLogo(
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("(-a, a)=>(a, a)", style: _style),
                  Animator<Offset>(
                    tween: Tween<Offset>(
                        begin: Offset(-0.5, -0.5), end: Offset(0.5, 0.5)),
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animatorState, __) => FractionalTranslation(
                      translation: animatorState.value,
                      child: FlutterLogo(
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("(0, -a)=>(0, a)", style: _style),
                  Animator<Offset>(
                    tween: Tween<Offset>(
                        begin: Offset(0, -0.5), end: Offset(0, 0.5)),
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animatorState, __) => FractionalTranslation(
                      translation: animatorState.value,
                      child: FlutterLogo(
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("(a, -a)=>(-a, a)", style: _style),
                  Animator<Offset>(
                    tween: Tween<Offset>(
                        begin: Offset(0.5, -0.5), end: Offset(-0.5, 0.5)),
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animatorState, __) => FractionalTranslation(
                      translation: animatorState.value,
                      child: FlutterLogo(
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          Divider(),
          Text(
            "4- FractionalTranslation widget. changing Curves.",
            style: _titleStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("bounceOut", style: _style),
                  Animator<Offset>(
                    tween: Tween<Offset>(
                        begin: Offset(-0.5, 0), end: Offset(0.5, 0)),
                    duration: Duration(seconds: 2),
                    curve: Curves.bounceOut,
                    repeats: 0,
                    builder: (_, animatorState, __) => FractionalTranslation(
                      translation: animatorState.value,
                      child: FlutterLogo(
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("bounceIn", style: _style),
                  Animator<Offset>(
                    tween: Tween<Offset>(
                        begin: Offset(-0.5, 0), end: Offset(0.5, 0)),
                    duration: Duration(seconds: 2),
                    curve: Curves.bounceIn,
                    repeats: 0,
                    builder: (_, animatorState, __) => FractionalTranslation(
                      translation: animatorState.value,
                      child: FlutterLogo(
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("bounceInOut", style: _style),
                  Animator<Offset>(
                    tween: Tween<Offset>(
                        begin: Offset(-0.5, 0), end: Offset(0.5, 0)),
                    duration: Duration(seconds: 2),
                    curve: Curves.bounceInOut,
                    repeats: 0,
                    builder: (_, animatorState, __) => FractionalTranslation(
                      translation: animatorState.value,
                      child: FlutterLogo(
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("decelerate", style: _style),
                  Animator<Offset>(
                    tween: Tween<Offset>(
                        begin: Offset(-0.5, 0), end: Offset(0.5, 0)),
                    duration: Duration(seconds: 2),
                    curve: Curves.decelerate,
                    repeats: 0,
                    builder: (_, animatorState, __) => FractionalTranslation(
                      translation: animatorState.value,
                      child: FlutterLogo(
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          Divider(),
          Text(
            "5- Transform widget. Combining transform. dur:2s , cycles=0",
            style: _titleStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("translation + rotateZ", style: _style),
                  Animator<double>(
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animatorState, __) => Transform(
                      transform: Matrix4.translationValues(
                          animatorState.value * 100, 0, 0)
                        ..rotateZ(animatorState.value * 4 * pi),
                      alignment: Alignment.center,
                      child: FlutterLogo(
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("translation + rotateZ +scale", style: _style),
                  Animator<double>(
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animatorState, __) => Transform(
                      transform: Matrix4.translationValues(
                          animatorState.value * 100, 0, 0)
                        ..setRotationZ(animatorState.value * 2 * pi)
                        ..scale(animatorState.value),
                      alignment: Alignment.center,
                      child: FlutterLogo(
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
