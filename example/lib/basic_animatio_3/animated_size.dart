import 'package:animator/animator.dart';
import 'package:flutter/material.dart';

/// Inspired form https://api.flutter.dev/flutter/widgets/AnimatedSize-class.html
class ImplicitAnimatedSize extends StatelessWidget {
  const ImplicitAnimatedSize({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Implicit Animated Size'),
      ),
      body: const Center(
        child: MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  double _size = 50.0;
  bool _large = false;

  void _updateSize() {
    setState(() {
      _size = _large ? 250.0 : 100.0;
      _large = !_large;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _updateSize(),
      child: Container(
        color: Colors.amberAccent,
        child: AnimateWidget(
          curve: Curves.easeIn,
          duration: const Duration(seconds: 1),
          builder: (context, animate) {
            return Container(
              width: animate.fromTween((_) => 100.0.tweenTo(250)),
              child: FlutterLogo(),
            );
          },
        ),
      ),
    );
  }
}
