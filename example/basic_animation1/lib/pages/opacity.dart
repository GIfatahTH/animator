import 'package:flutter/material.dart';
import 'package:animator/animator.dart';

class OpacityAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Tween<double>'),
            Text('Opacity Animation'),
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
            "1- Opacity widget. Default Animation = Twn:<bouble> 0 -->1, Dur: 500ms, Crv: Linear",
            style: _titleStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("Defaut", style: _style),
                  Animator(
                    builder: (Animation anim) => Opacity(
                          opacity: anim.value,
                          child: FlutterLogo(
                            size: 50,
                          ),
                        ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("repeats = 5", style: _style),
                  Animator(
                    repeats: 5,
                    endAnimationListener: () => print("end"),
                    builder: (anim) => Opacity(
                          opacity: anim.value,
                          child: FlutterLogo(
                            size: 50,
                          ),
                        ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("repeats = 0", style: _style),
                  Animator(
                    repeats: 0,
                    builder: (anim) => Opacity(
                          opacity: anim.value,
                          child: FlutterLogo(
                            size: 50,
                          ),
                        ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("cycles = 10", style: _style),
                  Animator(
                    cycles: 2 * 5,
                    builder: (anim) => Opacity(
                          opacity: anim.value,
                          child: FlutterLogo(
                            size: 50,
                          ),
                        ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("cycles = 0", style: _style),
                  Animator(
                    cycles: 0,
                    builder: (anim) => Opacity(
                          opacity: anim.value,
                          child: FlutterLogo(
                            size: 50,
                          ),
                        ),
                  )
                ],
              ),
            ],
          ),
          Divider(height: 20, color: Colors.teal),
          Text(
            "2- FadeTransition widget : Default Animation = Twn:<bouble> 0 -->1, Dur: 500ms, Crv: Linear",
            style: _titleStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("Defaut", style: _style),
                  Animator(
                    builder: (Animation anim) => FadeTransition(
                          opacity: anim,
                          child: FlutterLogo(
                            size: 50,
                          ),
                        ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("repeats = 5", style: _style),
                  Animator(
                    repeats: 5,
                    builder: (Animation anim) => FadeTransition(
                          opacity: anim,
                          child: FlutterLogo(
                            size: 50,
                          ),
                        ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("repeats = 0", style: _style),
                  Animator(
                    repeats: 0,
                    builder: (Animation anim) => FadeTransition(
                          opacity: anim,
                          child: FlutterLogo(
                            size: 50,
                          ),
                        ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("cycles = 10", style: _style),
                  Animator(
                    cycles: 2 * 5,
                    builder: (Animation anim) => FadeTransition(
                          opacity: anim,
                          child: FlutterLogo(
                            size: 50,
                          ),
                        ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("cycles = 0", style: _style),
                  Animator(
                    cycles: 0,
                    builder: (Animation anim) => FadeTransition(
                          opacity: anim,
                          child: FlutterLogo(
                            size: 50,
                          ),
                        ),
                  )
                ],
              ),
            ],
          ),
          Divider(height: 20, color: Colors.teal),
          Text(
            "3- FadeTransition widget : duration = 2s",
            style: _titleStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("Defaut", style: _style),
                  Animator(
                    duration: Duration(seconds: 2),
                    builder: (anim) => FadeTransition(
                          opacity: anim,
                          child: FlutterLogo(
                            size: 50,
                          ),
                        ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("repeats = 5", style: _style),
                  Animator(
                    duration: Duration(seconds: 2),
                    repeats: 5,
                    builder: (anim) => FadeTransition(
                          opacity: anim,
                          child: FlutterLogo(
                            size: 50,
                          ),
                        ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("repeats = 0", style: _style),
                  Animator(
                    duration: Duration(seconds: 2),
                    repeats: 0,
                    builder: (anim) => FadeTransition(
                          opacity: anim,
                          child: FlutterLogo(
                            size: 50,
                          ),
                        ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("cycles = 10", style: _style),
                  Animator(
                    duration: Duration(seconds: 2),
                    cycles: 2 * 5,
                    builder: (anim) => FadeTransition(
                          opacity: anim,
                          child: FlutterLogo(
                            size: 50,
                          ),
                        ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("cycles = 0", style: _style),
                  Animator(
                    duration: Duration(seconds: 2),
                    cycles: 0,
                    builder: (anim) => FadeTransition(
                          opacity: anim,
                          child: FlutterLogo(
                            size: 50,
                          ),
                        ),
                  )
                ],
              ),
            ],
          ),
          Divider(height: 20, color: Colors.teal),
          Text(
            "4- FadeTransition widget : duration = 2s, curve = elasticOut",
            style: _titleStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("Defaut", style: _style),
                  Animator(
                    duration: Duration(seconds: 2),
                    curve: Curves.fastOutSlowIn,
                    builder: (anim) => FadeTransition(
                          opacity: anim,
                          child: FlutterLogo(
                            size: 50,
                          ),
                        ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("repeats = 5", style: _style),
                  Animator(
                    duration: Duration(seconds: 2),
                    curve: Curves.fastOutSlowIn,
                    repeats: 5,
                    builder: (anim) => FadeTransition(
                          opacity: anim,
                          child: FlutterLogo(
                            size: 50,
                          ),
                        ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("repeats = 0", style: _style),
                  Animator(
                    duration: Duration(seconds: 2),
                    curve: Curves.fastOutSlowIn,
                    repeats: 0,
                    builder: (anim) => FadeTransition(
                          opacity: anim,
                          child: FlutterLogo(
                            size: 50,
                          ),
                        ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("cycles = 10", style: _style),
                  Animator(
                    duration: Duration(seconds: 2),
                    curve: Curves.decelerate,
                    cycles: 2 * 5,
                    builder: (anim) => FadeTransition(
                          opacity: anim,
                          child: FlutterLogo(
                            size: 50,
                          ),
                        ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text("cycles = 0", style: _style),
                  Animator(
                    duration: Duration(seconds: 2),
                    curve: Curves.elasticOut,
                    cycles: 0,
                    builder: (anim) => FadeTransition(
                          opacity: anim,
                          child: FlutterLogo(
                            size: 50,
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
