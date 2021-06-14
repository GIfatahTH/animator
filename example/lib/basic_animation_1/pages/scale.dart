import 'package:flutter/material.dart';
import 'package:animator/animator.dart';

class ScaleAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Tween<double>'),
            Text('Scale & SizeTransition & Skew'),
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
            "1- Scale from center. dur:2s , cycles = 0",
            style: _titleStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "SizedBox",
                    style: _style,
                  ),
                  Animator<double>(
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animationState, __) => SizedBox(
                      width: 50 * animationState.value,
                      height: 50 * animationState.value,
                      child: FlutterLogo(
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    "Transform.scale",
                    style: _style,
                  ),
                  Animator<double>(
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animationState, __) => Transform.scale(
                      scale: animationState.value,
                      child: FlutterLogo(
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    "diagonal3Values",
                    style: _style,
                  ),
                  Animator<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animationState, __) => Transform(
                      transform: Matrix4.diagonal3Values(
                          animationState.value, animationState.value, 1),
                      alignment: Alignment.center,
                      child: FlutterLogo(
                        size: 50,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    "ScaleTransition",
                    style: _style,
                  ),
                  Animator<double>(
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animationState, __) => ScaleTransition(
                      scale: animationState.animation,
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
            "2- Transform.scale widget : Changing the origin. dur:2s , cycles=0",
            style: _titleStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "center",
                    style: _style,
                  ),
                  Animator<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animationState, __) => Transform.scale(
                      scale: animationState.value,
                      child: FlutterLogo(
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    "topLeft",
                    style: _style,
                  ),
                  Animator<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animationState, __) => Transform.scale(
                      scale: animationState.value,
                      alignment: Alignment.topLeft,
                      child: FlutterLogo(
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    "bottomRight",
                    style: _style,
                  ),
                  Animator<double>(
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animationState, __) => Transform.scale(
                      scale: animationState.value,
                      alignment: Alignment.bottomRight,
                      child: FlutterLogo(
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    "Offset(10, -10)",
                    style: _style,
                  ),
                  Animator<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animationState, __) => Transform.scale(
                      scale: animationState.value,
                      origin: Offset(10, -10),
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
            "3- Transform.scale : Changing Curves. dur:500ms , cycles = 0",
            style: _titleStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "elasticOut",
                    style: _style,
                  ),
                  Animator<double>(
                    tween: Tween<double>(begin: 0.8, end: 1.4),
                    curve: Curves.elasticOut,
                    cycles: 0,
                    builder: (_, animationState, __) => Transform.scale(
                        scale: animationState.value,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 50,
                        )),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    "elasticIn",
                    style: _style,
                  ),
                  Animator<double>(
                    tween: Tween<double>(begin: 0.8, end: 1.4),
                    curve: Curves.elasticIn,
                    cycles: 0,
                    builder: (_, animationState, __) => Transform.scale(
                        scale: animationState.value,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 50,
                        )),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    "elasticInOut",
                    style: _style,
                  ),
                  Animator<double>(
                    tween: Tween<double>(begin: 0.8, end: 1.4),
                    curve: Curves.elasticInOut,
                    cycles: 0,
                    builder: (_, animationState, __) => Transform.scale(
                        scale: animationState.value,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 50,
                        )),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    "fastOutSlowIn",
                    style: _style,
                  ),
                  Animator<double>(
                    tween: Tween<double>(begin: 0.8, end: 1.4),
                    curve: Curves.fastOutSlowIn,
                    cycles: 0,
                    builder: (_, animationState, __) => Transform.scale(
                        scale: animationState.value,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 50,
                        )),
                  )
                ],
              ),
            ],
          ),
          Divider(),
          Text(
            "4- SizeTransition widget. dur:2s , cycles=0",
            style: _titleStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("Axis.vertical", style: _style),
                  Animator<double>(
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animationState, __) => SizeTransition(
                        sizeFactor: animationState.animation,
                        child: FlutterLogo(
                          size: 50,
                        )),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    "Axis.horizontal",
                    style: _style,
                  ),
                  Animator<double>(
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animationState, __) => SizeTransition(
                        sizeFactor: animationState.animation,
                        axis: Axis.horizontal,
                        child: FlutterLogo(
                          size: 50,
                        )),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    "axisAlig. : -1",
                    style: _style,
                  ),
                  Animator<double>(
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animationState, __) => SizeTransition(
                        sizeFactor: animationState.animation,
                        axis: Axis.horizontal,
                        axisAlignment: -1,
                        child: FlutterLogo(
                          size: 50,
                        )),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    "axisAlig. : 1",
                    style: _style,
                  ),
                  Animator<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animationState, __) => SizeTransition(
                        sizeFactor: animationState.animation,
                        axis: Axis.horizontal,
                        axisAlignment: 1,
                        child: FlutterLogo(
                          size: 50,
                        )),
                  )
                ],
              ),
            ],
          ),
          Divider(),
          Text(
            "5- Transform widget. Matrix4.skew . dur:2s , cycles=0",
            style: _titleStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("skewX", style: _style),
                  Animator<double>(
                    tween: Tween<double>(begin: -0.5, end: 0.5),
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animationState, __) => Transform(
                      transform: Matrix4.skewX(animationState.value),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                        ),
                        child: FlutterLogo(
                          size: 50,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    "skewY",
                    style: _style,
                  ),
                  Animator<double>(
                    tween: Tween<double>(begin: -0.5, end: 0.5),
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animationState, __) => Transform(
                      transform: Matrix4.skewY(animationState.value),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                        ),
                        child: FlutterLogo(
                          size: 50,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    "skew",
                    style: _style,
                  ),
                  Animator<double>(
                    tween: Tween<double>(begin: -0.5, end: 0.5),
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (_, animationState, __) => Transform(
                      transform: Matrix4.skew(
                          animationState.value, animationState.value),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                        ),
                        child: FlutterLogo(
                          size: 50,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
