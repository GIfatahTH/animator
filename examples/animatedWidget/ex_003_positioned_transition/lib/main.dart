import 'package:flutter/material.dart';
import 'package:animator/animator.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: Scaffold(body: MyStatefulWidget()),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    const double smallLogo = 100;
    const double bigLogo = 200;
    return Column(
      children: [
        Text('Flutter PositionedTransition'),
        SizedBox(height: 20),
        Expanded(child: Center(child: FlutterPositionedTransition())),
        Text('Using AnimateWidget'),
        SizedBox(height: 20),
        Expanded(
          child: Center(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final Size biggest = constraints.biggest;
                return Stack(
                  children: <Widget>[
                    AnimateWidget(
                      duration: const Duration(seconds: 2),
                      curve: Curves.elasticInOut,
                      cycles: 0,
                      builder: (context, animate) {
                        return PositionedTransition(
                          rect: RelativeRectTween(
                            begin: RelativeRect.fromSize(
                                const Rect.fromLTWH(0, 0, smallLogo, smallLogo),
                                biggest),
                            end: RelativeRect.fromSize(
                                Rect.fromLTWH(biggest.width - bigLogo,
                                    biggest.height - bigLogo, bigLogo, bigLogo),
                                biggest),
                          ).animate(animate.curvedAnimation),
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: FlutterLogo(),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class FlutterPositionedTransition extends StatefulWidget {
  const FlutterPositionedTransition({Key? key}) : super(key: key);

  @override
  State<FlutterPositionedTransition> createState() =>
      _FlutterPositionedTransitionState();
}

class _FlutterPositionedTransitionState
    extends State<FlutterPositionedTransition> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..forward();
  initState() {
    super.initState();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double smallLogo = 100;
    const double bigLogo = 200;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size biggest = constraints.biggest;
        return Stack(
          children: <Widget>[
            PositionedTransition(
              rect: RelativeRectTween(
                begin: RelativeRect.fromSize(
                    const Rect.fromLTWH(0, 0, smallLogo, smallLogo), biggest),
                end: RelativeRect.fromSize(
                    Rect.fromLTWH(biggest.width - bigLogo,
                        biggest.height - bigLogo, bigLogo, bigLogo),
                    biggest),
              ).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: Curves.elasticInOut,
                ),
              ),
              child: const Padding(
                  padding: EdgeInsets.all(8), child: FlutterLogo()),
            ),
          ],
        );
      },
    );
  }
}
