import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animator/animator.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class MyBloc extends StatesRebuilder {
  final myAnimation = AniamtionSetup(
    tweenMap: {
      "opacityAnim": Tween<double>(begin: 0.5, end: 1),
      "rotationAnim": Tween<double>(begin: 0, end: 2 * pi),
      "translateAnim": Tween<Offset>(begin: Offset.zero, end: Offset(1, 0)),
    },
    duration: Duration(seconds: 2),
  );
  init() {
    myAnimation.initAnimation(
      bloc: this,
      ids: ["OpacityWidget", "RotationWidget"],
      cycles: 3,
      endAnimationListener: () => print("animation finished"),
    );
  }
}

MyBloc myBloc;

class ExplicitAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      initState: (_) => myBloc = MyBloc(),
      dispose: (_) => myBloc = null,
      builder: (_) => Scaffold(
            appBar: AppBar(
              title: Text("Flutter Animation"),
            ),
            body: Padding(
              padding: EdgeInsets.all(20),
              child: MyHomePage(),
            ),
          ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      initState: (_) => myBloc.init(),
      dispose: (_) => myBloc.myAnimation.disposeAnimation(),
      stateID: 'myAnimation',
      blocs: [myBloc],
      builder: (_) => Center(child: MyAnimation()),
    );
  }
}

class MyAnimation extends StatelessWidget {
  final _flutterLog100 =
      FlutterLogo(size: 150, style: FlutterLogoStyle.horizontal);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RaisedButton(
        child: Text("Animate"),
        onPressed: () => myBloc.myAnimation.triggerAnimation(),
      ),
      StateBuilder(
        key: Key("opacity"),
        stateID: "OpacityWidget",
        blocs: [myBloc],
        builder: (anim) => FadeTransition(
              opacity: myBloc.myAnimation.animationMap["opacityAnim"],
              child: FractionalTranslation(
                translation: myBloc.myAnimation.valueMap["translateAnim"],
                child: _flutterLog100,
              ),
            ),
      ),
      StateBuilder(
        key: Key("rotation"),
        stateID: "RotationWidget",
        blocs: [myBloc],
        builder: (anim) {
          return Container(
            child: FractionalTranslation(
              translation: myBloc.myAnimation.valueMap["translateAnim"],
              child: Transform.rotate(
                angle: myBloc.myAnimation.valueMap['rotationAnim'],
                child: _flutterLog100,
              ),
            ),
          );
        },
      )
    ]);
  }
}

// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:animator/animator.dart';
// import 'package:states_rebuilder/states_rebuilder.dart';

// class MyBloc extends StatesRebuilder {
//   String animationStageName = 'opacity';
//   String animationName = 'Opacity';

//   changeAnimation(String stage, String name) {
//     animationStageName = stage;
//     animationName = name;
//     rebuildStates(ids: ['myAnimation']);
//   }
// }

// MyBloc myBloc;

// class FlutterAnimation extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StateBuilder(
//       initState: (_) => myBloc = MyBloc(),
//       dispose: (_) => myBloc = null,
//       builder: (_) => Scaffold(
//             appBar: AppBar(
//               title: Text("Flutter Animation"),
//             ),
//             body: Padding(
//               padding: EdgeInsets.all(20),
//               child: MyHomePage(),
//             ),
//           ),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StateBuilder(
//       stateID: 'myAnimation',
//       blocs: [myBloc],
//       builder: (_) => Center(child: MyAnimation()),
//     );
//   }
// }

// class MyAnimation extends StatelessWidget {
//   final _flutterLog100 =
//       FlutterLogo(size: 150, style: FlutterLogoStyle.horizontal);
//   @override
//   Widget build(BuildContext context) {
//     Widget _child;
//     switch (myBloc.animationStageName) {
//       case "opacity":
//         _child = Animator(
//           key: Key("opacity"),
//           duration: Duration(seconds: 2),
//           endAnimationListener: () =>
//               myBloc.changeAnimation('rotation1', 'Rotation'),
//           cycles: 3,
//           builder: (anim) => FadeTransition(
//                 opacity: anim,
//                 child: _flutterLog100,
//               ),
//         );
//         break;
//       case "rotation1":
//         _child = Animator(
//           key: Key("rotation1"),
//           tween: Tween<double>(begin: 0, end: 2 * pi),
//           curve: Curves.bounceIn,
//           duration: Duration(seconds: 2),
//           repeats: 2,
//           builder: (anim) {
//             return Transform.rotate(
//               angle: anim.value,
//               child: _flutterLog100,
//             );
//           },
//         );
//         break;
//       default:
//         _child = Text("hooooops");
//     }
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         Text(myBloc.animationName, style: TextStyle(fontSize: 35)),
//         Divider(),
//         Expanded(child: _child),
//       ],
//     );
//   }
// }
