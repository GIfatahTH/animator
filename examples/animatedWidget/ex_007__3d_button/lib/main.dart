import 'package:animator/animator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('3D button'),
        ),
        body: Center(
          child: _HomePage(
            elevation: 8.0,
            // height: 100,
            // width: 50,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage({
    Key? key,
    this.elevation = 8.0,
    this.height = 50,
    this.width = double.infinity,
    this.color = Colors.blue,
  }) : super(key: key);
  final double elevation;
  final double height;
  final double width;
  final MaterialColor color;
  @override
  __HomePageState createState() => __HomePageState();
}

class __HomePageState extends State<_HomePage> {
  bool _isTapDown = false;
  late MaterialColor color = widget.color;
  late double _elevation = widget.elevation * 0.5;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        setState(() {
          _isTapDown = false;
        });
      },
      onTapDown: (details) {
        setState(() {
          _isTapDown = true;
        });
      },
      child: AnimateWidget(
        duration: 200.milliseconds(),
        triggerOnRebuild: true,
        builder: (context, animate) {
          final elevation = animate(_isTapDown ? 0.0 : _elevation * 2)!;
          return SizedBox(
            height: widget.elevation + widget.height,
            width: widget.width,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    margin: animate(
                      _isTapDown
                          ? EdgeInsets.only(
                              right: 0.0,
                              top: _elevation * 0.5,
                              left: _elevation * 0.5,
                              bottom: _elevation * 0.5,
                            )
                          : EdgeInsets.only(
                              right: _elevation * 0.5,
                              top: _elevation * 0.5,
                              left: 0.0,
                              bottom: 0.0,
                            ),
                    ),
                    height: widget.height + elevation - _elevation * 0.5,
                    decoration: ShapeDecoration(
                      color: color.shade800,
                      shape: StadiumBorder(),
                    ),
                    child: Center(child: Text('Button')),
                  ),
                ),
                Positioned(
                  right: 0,
                  left: elevation * 0.5,
                  bottom: elevation,
                  child: Container(
                    height: widget.height,
                    decoration: ShapeDecoration(
                      color: color,
                      shape: StadiumBorder(),
                    ),
                    child: Center(child: Text('Button')),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
