/// Flutter code sample for AnimatedPositioned

// The following example transitions an AnimatedPositioned
// between two states. It adjusts the `height`, `width`, and
// [Positioned] properties when tapped.

import 'package:animator/animator.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyAnimatedPositioned());

/// This is the main application widget.
class MyAnimatedPositioned extends StatelessWidget {
  const MyAnimatedPositioned({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Implicit Animation')),
      body: const Center(
        child: MyStatefulWidget(),
      ),
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
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Using AnimatedPositioned'),
        SizedBox(height: 20),
        Center(
          child: SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              children: <Widget>[
                AnimatedPositioned(
                  width: selected ? 200.0 : 50.0,
                  height: selected ? 50.0 : 200.0,
                  top: selected ? 50.0 : 150.0,
                  duration: const Duration(seconds: 2),
                  curve: Curves.fastOutSlowIn,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = !selected;
                      });
                    },
                    child: Container(
                      color: Colors.blue,
                      child: const Center(child: Text('Tap me')),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Text('Using AnimateWidget'),
        SizedBox(height: 20),
        Center(
          child: SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              children: <Widget>[
                AnimateWidget(
                  duration: const Duration(seconds: 2),
                  curve: Curves.fastOutSlowIn,
                  builder: (context, animate) {
                    return Positioned(
                      width: animate(selected ? 200.0 : 50.0),
                      height: animate(selected ? 50.0 : 200.0, 'height'),
                      top: animate(selected ? 50.0 : 150.0, 'top'),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selected = !selected;
                          });
                        },
                        child: Container(
                          color: Colors.blue,
                          child: const Center(child: Text('Tap me')),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
