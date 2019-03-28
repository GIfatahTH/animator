```dart
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:animator/animator.dart';

class MainBloc extends StatesRebuilder {
  bool toggleCurve = true;
  rebuild(State state) {
    toggleCurve = !toggleCurve;
    rebuildStates(states: [state]);
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
      builder: (State state) => Column(
            children: <Widget>[
              Text('Widget is animated on rebuild'),
              Animator(
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
                animateOnRebuild: false,
                builder: (anim) => Center(
                      child: Transform.scale(
                        scale: anim.value,
                        child: FlutterLogo(size: 50),
                      ),
                    ),
              ),
              Divider(),
              Text('Animation is reset on rebuild.'),
              Animator(
                resetAnimationOnRebuild: true,
                curve: mainBloc.toggleCurve ? Curves.linear : Curves.elasticOut,
                builder: (anim) => Center(
                      child: Transform.scale(
                        scale: anim.value,
                        child: FlutterLogo(size: 50),
                      ),
                    ),
              ),
              RaisedButton(
                child: Text('Rebuild'),
                onPressed: () => mainBloc.rebuild(state),
              )
            ],
          ),
    );
  }
}
```