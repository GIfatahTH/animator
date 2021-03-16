import 'package:animator/animator.dart';
import 'package:flutter/material.dart';

class BasicAnimation3 extends StatefulWidget {
  @override
  _BasicAnimation3State createState() => _BasicAnimation3State();
}

class _BasicAnimation3State extends State<BasicAnimation3> {
  bool selected = true;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Switch(
              value: selected,
              onChanged: (value) => setState(() => selected = value),
              activeColor: Colors.white,
              inactiveThumbColor: Colors.grey,
            ),
            Text('Implicit animation'),
          ],
        ),
      ),
      body: Child2(
        child1: FlutterLogo(
          size: 40,
        ),
        child2: Container(
          height: 40,
          width: 50,
          color: Colors.blue,
        ),
        builder: (flutterLogo, container) {
          return ImplicitAnimator(
            cycles: 3,
            duration: Duration(seconds: 2),
            builder: (context, animate) {
              return Column(
                children: [
                  // Transform.translate(
                  //   offset: animateTween(
                  //     (begin) => Tween(
                  //       begin: Offset(0, 0),
                  //       end: Offset(200, 200),
                  //     ),
                  //     'rotate',
                  //   )!,
                  //   child: flutterLogo,
                  // ),
                  // Transform.translate(
                  //   offset: Offset(animate(selected ? 0 : 200)!,
                  //       animate(selected ? 0 : 200, 'off')!),
                  //   child: flutterLogo,
                  // ),
                  Container(
                    width: 50,
                    height: 50,
                    color: animate(selected ? null : Colors.red),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    color:
                        animate.formTween((_) => ColorTween(end: Colors.blue)),
                  ),
                  Transform.translate(
                    offset: Offset(animate(selected ? 0 : 200)!,
                        animate(selected ? 0 : 200, 'off')!),
                    child: flutterLogo,
                  ),
                  Transform.rotate(
                    angle: animate(selected ? 0 : 2 * 3.14, 'rotate')!,
                    child: flutterLogo,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Transform.scale(
                        scale: animate(selected ? 1 : 2, 'scale')!,
                        child: flutterLogo,
                      ),
                      Transform.rotate(
                        angle: animate(selected ? 0 : 2 * 3.14, 'rotate2')!,
                        child: flutterLogo,
                      ),
                      Transform(
                        transform: animate(
                          selected
                              ? Matrix4.translationValues(0, 0, 0.0)
                              : Matrix4.translationValues(50, 0, 0.0),
                        )!,
                        child: flutterLogo,
                      ),
                      Transform.rotate(
                        angle: animate.formTween(
                          (_) => selected
                              ? Tween(begin: 2 * 3.1436, end: 0)
                              : Tween(begin: 0, end: 2 * 3.14),
                          'rotate1',
                        )!,
                        child: flutterLogo,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: animate(selected ? 40 : 10, 'c_w'),
                        child: container,
                      ),
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Container(
                          alignment: animate(
                            selected
                                ? AlignmentDirectional.topStart
                                : AlignmentDirectional.topEnd,
                          ),
                          child: container,
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Container(
                            alignment: animate(
                              selected
                                  ? AlignmentDirectional.topStart
                                  : AlignmentDirectional.topEnd,
                              'align_2',
                            ),
                            child: container,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
