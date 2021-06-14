import 'package:flutter/material.dart';
import 'package:animator/animator.dart';

class BasicAnimation0 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basic Animation 0'),
      ),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool toggleCurve = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Widget is animated on rebuild'),
        Animator<double>(
          resetAnimationOnRebuild: true,
          duration: Duration(seconds: 2),
          cycles: 2,
          builder: (_, anim, __) => Center(
            child: Transform.scale(
              scale: anim.value,
              child: FlutterLogo(size: 50),
            ),
          ),
        ),
        Divider(),
        Text('Widget is not animated on rebuild'),
        Animator<double>(
          duration: Duration(seconds: 2),
          builder: (_, anim, __) => Center(
            child: Transform.scale(
              scale: anim.value,
              child: FlutterLogo(
                size: 50,
                textColor: Colors.red,
              ),
            ),
          ),
        ),
        Divider(),
        Text('Animation is reset on rebuild. Curve changes on rebuild'),
        Animator<double>(
          duration: Duration(seconds: 2),
          repeats: 1,
          resetAnimationOnRebuild: true,
          curve: toggleCurve ? Curves.linear : Curves.bounceIn,
          builder: (_, anim, __) => Center(
            child: Transform.scale(
              scale: anim.value,
              child: FlutterLogo(size: 50),
            ),
          ),
        ),
        ElevatedButton(
          child: Text('Rebuild '),
          onPressed: () {
            setState(() {
              toggleCurve = !toggleCurve;
            });
          },
        )
      ],
    );
  }
}
