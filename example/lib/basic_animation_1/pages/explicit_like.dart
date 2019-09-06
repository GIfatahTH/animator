import 'dart:math';
import 'package:flutter/material.dart';

import 'package:states_rebuilder/states_rebuilder.dart';

import 'package:animator/animator.dart';

class MyBloc extends StatesRebuilderWithAnimator {
  init(TickerProvider ticker) {
    animator.tweenMap = {
      "opacityAnim": Tween<double>(begin: 0.5, end: 1),
      "rotationAnim": Tween<double>(begin: 0, end: 2 * pi),
      "translateAnim": Tween<Offset>(begin: Offset.zero, end: Offset(1, 0)),
    };
    initAnimation(ticker);
    addAnimationListener(() {
      print(this);
      rebuildStates(["OpacityWidget", "RotationWidget"]);
    });
    animator.cycles = 3;
    // animator.duration = Duration(seconds: 2);

    endAnimationListener(() => print("animation finished"));
  }

  startAnimation([bool reset = false]) {
    triggerAnimation(reset: reset);
  }
}

class ExplicitAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Injector<MyBloc>(
      models: [() => MyBloc()],
      builder: (_, model) => Scaffold(
        appBar: AppBar(
          title: Text("Flutter Animation"),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: StateWithMixinBuilder(
            mixinWith: MixinWith.tickerProviderStateMixin,
            viewModels: [model],
            initState: (ctx, _, ticker) => model.init(ticker),
            dispose: (_, __, ___) => model.dispose(),
            builder: (_, __) => Center(child: MyAnimation()),
          ),
        ),
      ),
    );
  }
}

class MyAnimation extends StatelessWidget {
  final _flutterLog100 =
      FlutterLogo(size: 150, style: FlutterLogoStyle.horizontal);

  final model = Injector.get<MyBloc>();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RaisedButton(
        child: Text("Animate"),
        onPressed: () => model.triggerAnimation(),
      ),
      RaisedButton(
        child: Text("Reset and Animate"),
        onPressed: () => model.startAnimation(true),
      ),
      StateBuilder(
        tag: "OpacityWidget",
        blocs: [model],
        builder: (_, __) => FadeTransition(
          opacity: model.animationMap["opacityAnim"],
          child: FractionalTranslation(
            translation: model.animationMap["translateAnim"].value,
            child: _flutterLog100,
          ),
        ),
      ),
      StateBuilder(
        tag: "RotationWidget",
        blocs: [model],
        builder: (_, __) {
          return Container(
            child: FractionalTranslation(
              translation: model.animationMap["translateAnim"].value,
              child: Transform.rotate(
                angle: model.animationMap['rotationAnim'].value,
                child: _flutterLog100,
              ),
            ),
          );
        },
      )
    ]);
  }
}
