import 'dart:async';

import 'package:flutter/material.dart';
import 'package:animator/animator.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: MyStatefulWidget()),
    );
  }
}

class MyImplicitStaggeredWidget extends StatelessWidget {
  const MyImplicitStaggeredWidget({Key? key}) : super(key: key);

  static const String _title = 'Timer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStaggeredWidgetState();
}

class _MyStaggeredWidgetState extends State<MyStatefulWidget> {
  static const _kOneGradient = 2 * 3.14 / 60;
  late double nowSeconds = DateTime.now().second * _kOneGradient;

  late double nowMinutes =
      DateTime.now().minute * _kOneGradient + nowSeconds / 60;
  late double nowHours =
      (DateTime.now().hour % 12) * _kOneGradient * 5 + nowMinutes / 60;

  @override
  void initState() {
    super.initState();
    Timer.periodic(
      Duration(seconds: 1),
      (_) {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(border: Border.all(width: 2.0)),
        child: Align(
          alignment: Alignment.topCenter,
          child: Child3(
            //Second rod
            child1: Container(
              width: 1,
              height: 100,
              color: Colors.red,
            ),
            //minute rod
            child2: Container(
              width: 2,
              height: 90,
              color: Colors.black,
            ),
            //hour rod
            child3: Container(
              width: 4,
              height: 80,
              color: Colors.black,
            ),
            builder: (secondRod, minuteRod, hourRod) => Stack(
              alignment: Alignment.bottomCenter,
              children: [
                AnimateWidget(
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  triggerOnRebuild: true,
                  builder: (context, animate) {
                    return Transform.rotate(
                      angle: animate.fromTween(
                        (currentValue) => Tween(
                          begin: currentValue ?? nowSeconds,
                          end: (currentValue ?? nowSeconds) + _kOneGradient,
                        ),
                      )!,
                      alignment: Alignment.bottomCenter,
                      child: secondRod,
                    );
                  },
                ),
                AnimateWidget(
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  triggerOnRebuild: true,
                  builder: (context, animate) => Transform.rotate(
                    angle: animate.fromTween(
                      (currentValue) => Tween(
                        begin: currentValue ?? nowMinutes,
                        end: (currentValue ?? nowMinutes) + _kOneGradient / 60,
                      ),
                    )!,
                    alignment: Alignment.bottomCenter,
                    child: minuteRod,
                  ),
                ),
                AnimateWidget(
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  triggerOnRebuild: true,
                  builder: (context, animate) => Transform.rotate(
                    angle: animate.fromTween(
                      (currentValue) => Tween(
                        begin: currentValue ?? nowHours,
                        end: (currentValue ?? nowHours) +
                            _kOneGradient / 60 / 60,
                      ),
                    )!,
                    alignment: Alignment.bottomCenter,
                    child: hourRod,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
