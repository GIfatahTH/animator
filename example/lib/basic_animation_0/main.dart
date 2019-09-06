import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:animator/animator.dart';

class MainBloc extends StatesRebuilder {
  bool toggleCurve = true;
  rebuild() {
    toggleCurve = !toggleCurve;
    rebuildStates(['widget 1', 'widget 2', 'widget 3']);
  }
}

final mainBloc = MainBloc();

class BasicAnimation0 extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Basic Animation 0'),
        ),
        body: Body(),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Widget is animated on rebuild'),
        Animator(
          key: UniqueKey(),
          name: "widget 1",
          blocs: [mainBloc],
          duration: Duration(seconds: 2),
          cycles: 2,
          builder: (anim) => Center(
            child: Transform.scale(
              scale: anim.value,
              child: FlutterLogo(size: 50),
            ),
          ),
        ),
        Divider(),
        Text('Widget is not animated on rebuild'),
        Animator(
          duration: Duration(seconds: 2),
          builder: (anim) => Center(
            child: Transform.scale(
              scale: anim.value,
              child: FlutterLogo(
                size: 50,
                colors: Colors.red,
              ),
            ),
          ),
        ),
        Divider(),
        Text('Animation is reset on rebuild. Curve changes on rebuild'),
        StateBuilder(
          tag: 'widget 3',
          blocs: [mainBloc],
          builder: (_, __) => Animator(
            tickerMixin: TickerMixin.tickerProviderStateMixin,
            duration: Duration(seconds: 2),
            repeats: 1,
            resetAnimationOnRebuild: true,
            curve: mainBloc.toggleCurve ? Curves.linear : Curves.bounceIn,
            builder: (anim) => Center(
              child: Transform.scale(
                scale: anim.value,
                child: FlutterLogo(size: 50),
              ),
            ),
          ),
        ),
        RaisedButton(
          child: Text('Rebuild '),
          onPressed: () => mainBloc.rebuild(),
        )
      ],
    );
  }
}
