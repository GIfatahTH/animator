import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:animator/animator.dart';

class MainBloc extends StatesRebuilder {
  bool toggleCurve = false;
  rebuild() {
    toggleCurve = !toggleCurve;
    rebuildStates(ids: ['widget 1', 'widget 2', 'widget 3', 'rr']);
  }
}

final mainBloc = MainBloc();

void main() => runApp(AnimatedLogo());

class AnimatedLogo extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
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
    return StateBuilder(
      stateID: 'rr',
      blocs: [mainBloc],
      builder: (_) => Column(
            children: <Widget>[
              Text('Widget is animated on rebuild'),
              Animator(
                stateID: "widget 1",
                blocs: [mainBloc],
                cycles: 1,
                builder: (anim) => Center(
                      child: Transform.scale(
                        scale: anim.value,
                        child: FlutterLogo(size: 50),
                      ),
                    ),
              ),
              Divider(),
              Text('Widget is not animatted on rebuild'),
              Animator(
                stateID: "widget 2",
                blocs: [mainBloc],
                // animateOnRebuild: false,
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
              Text('Animation is reset on rebuild.'),
              Animator(
                stateID: "widget 3",
                blocs: [mainBloc],
                // animateOnRebuild: false,
                duration: Duration(seconds: 2),
                repeats: 1,
                // curve: mainBloc.toggleCurve ? Curves.linear : Curves.bounceIn,
                // duration: mainBloc.toggleCurve ? null : Duration(seconds: 2),
                builder: (anim) => Center(
                      child: Transform.scale(
                        scale: anim.value,
                        child: FlutterLogo(size: 50),
                      ),
                    ),
              ),
              RaisedButton(
                child: Text('Rebuild '),
                onPressed: () => mainBloc.rebuild(),
              )
            ],
          ),
    );
  }
}
