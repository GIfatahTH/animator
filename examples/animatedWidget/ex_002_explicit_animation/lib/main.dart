import 'package:animator/animator.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyAnimatedContainer());

class MyAnimatedContainer extends StatelessWidget {
  const MyAnimatedContainer({Key? key}) : super(key: key);

  static const String _title = 'Explicit Animation';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = !selected;
        });
      },
      child: Center(
        child: AnimateWidget(
          duration: const Duration(seconds: 1),
          reverseDuration: 3.seconds(),
          curve: Curves.fastOutSlowIn,
          reverseCurve: Curves.bounceInOut,
          cycles: 0,
          builder: (context, animate) {
            final width = animate.fromTween(
              (currentValue) => Tween(
                begin: 200.0,
                end: 100.0,
              ),
            );
            final height = animate.fromTween(
              (currentValue) => 100.0.tweenTo(200.0),
              'height',
            );

            final alignment = animate.fromTween(
              (currentValue) => AlignmentGeometryTween(
                begin: Alignment.center,
                end: AlignmentDirectional.topCenter,
              ),
            );

            final Color? color = animate.fromTween(
              (currentValue) => Colors.red.tweenTo(Colors.blue),
              'height',
            );

            return Container(
              width: width,
              height: height,
              color: color,
              alignment: alignment,
              child: const FlutterLogo(size: 75),
            );
          },
        ),
      ),
    );
  }
}
