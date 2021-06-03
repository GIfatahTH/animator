/// Flutter code sample for AnimatedPadding

// The following code implements the [AnimatedPadding] widget, using a [curve] of
// [Curves.easeInOut].

import 'package:animator/animator.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyAnimatedPadding());

/// This is the main application widget.
class MyAnimatedPadding extends StatelessWidget {
  const MyAnimatedPadding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Implicit Animation')),
      body: const MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  double padValue = 0.0;
  void _updatePadding(double value) {
    setState(() {
      padValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Flutter AnimatedPadding'),
        SizedBox(height: 20),
        Expanded(
          child: AnimatedPadding(
            padding: EdgeInsets.all(padValue),
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 5,
              color: Colors.blue,
            ),
          ),
        ),
        Text('Flutter AnimateWidget'),
        SizedBox(height: 20),
        Expanded(
          child: AnimateWidget(
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            builder: (context, animate) {
              return Padding(
                padding: animate(EdgeInsets.all(padValue))!,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 5,
                  color: Colors.blue,
                ),
              );
            },
          ),
        ),
        Text('Padding: $padValue'),
        ElevatedButton(
            child: const Text('Change padding'),
            onPressed: () {
              _updatePadding(padValue == 0.0 ? 100.0 : 0.0);
            }),
      ],
    );
  }
}
