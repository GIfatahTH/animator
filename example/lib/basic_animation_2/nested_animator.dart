import 'dart:math';

import 'package:flutter/material.dart';
import 'package:animator/animator.dart';

class MyCustomPainterAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MyPainterWidget(),
    );
  }
}

class MyPainterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //You can nest an many Animator as you like with different tween, duration
    //and curve. If used with CustomClipper and CustomPainter you can get
    //out with amazing animation.
    return Animator(
      tweenMap: {
        "color1": ColorTween(begin: Colors.orange, end: Colors.blue),
        "color2": ColorTween(begin: Colors.blue, end: Colors.orange)
      },
      repeats: 0,
      duration: Duration(seconds: 5),
      builder: (_, animationState1, __) => Animator<double>(
        duration: Duration(seconds: 5),
        curve: Curves.bounceOut,
        repeats: 0,
        builder: (_, animationState2, __) => Center(
          child: CustomPaint(
            painter: WaveLayer(
              revealPercent: animationState2.value,
              primaryColor: animationState1.getValue('color1'),
              secondaryColor: animationState1.getValue('color2'),
            ),
            child: Container(
              alignment: Alignment.center,
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Animation With Animator",
                    style: TextStyle(
                      color: animationState1.getValue('color2'),
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    "is very easy",
                    style: TextStyle(
                      color: animationState1.getValue('color1'),
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum SlideDirection {
  leftToRight,
  rightToLeft,
  none,
}

// inspired from https://github.com/iamSahdeep/liquid_swipe_flutter
class WaveLayer extends CustomPainter {
  double revealPercent;
  late double waveCenterY;
  late double waveHorRadius;
  late double waveVertRadius;
  late double sideWidth;
  SlideDirection slideDirection = SlideDirection.rightToLeft;
  Color primaryColor;
  Color secondaryColor;
  WaveLayer(
      {@required required this.revealPercent,
      required this.primaryColor,
      required this.secondaryColor});

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.color = primaryColor;

    Path path = new Path();
    sideWidth = sidewidth(size);
    waveVertRadius = waveVertRadiusF(size);
    waveCenterY = size.height * 0.75;
    if (slideDirection == SlideDirection.leftToRight) {
      waveHorRadius = waveHorRadiusFBack(size);
    } else {
      waveHorRadius = waveHorRadiusF(size);
    }
    var maskWidth = size.width - sideWidth;
    path.moveTo(maskWidth - sideWidth, 0);
    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(maskWidth, size.height);
    double curveStartY = waveCenterY + waveVertRadius;

    path.lineTo(maskWidth, curveStartY);

    path.cubicTo(
        maskWidth,
        curveStartY - waveVertRadius * 0.1346194756,
        maskWidth - waveHorRadius * 0.05341339583,
        curveStartY - waveVertRadius * 0.2412779634,
        maskWidth - waveHorRadius * 0.1561501458,
        curveStartY - waveVertRadius * 0.3322374268);

    path.cubicTo(
        maskWidth - waveHorRadius * 0.2361659167,
        curveStartY - waveVertRadius * 0.4030805244,
        maskWidth - waveHorRadius * 0.3305285625,
        curveStartY - waveVertRadius * 0.4561193293,
        maskWidth - waveHorRadius * 0.5012484792,
        curveStartY - waveVertRadius * 0.5350576951);

    path.cubicTo(
        maskWidth - waveHorRadius * 0.515878125,
        curveStartY - waveVertRadius * 0.5418222317,
        maskWidth - waveHorRadius * 0.5664134792,
        curveStartY - waveVertRadius * 0.5650349878,
        maskWidth - waveHorRadius * 0.574934875,
        curveStartY - waveVertRadius * 0.5689655122);

    path.cubicTo(
        maskWidth - waveHorRadius * 0.7283715208,
        curveStartY - waveVertRadius * 0.6397387195,
        maskWidth - waveHorRadius * 0.8086618958,
        curveStartY - waveVertRadius * 0.6833456585,
        maskWidth - waveHorRadius * 0.8774032292,
        curveStartY - waveVertRadius * 0.7399037439);

    path.cubicTo(
        maskWidth - waveHorRadius * 0.9653464583,
        curveStartY - waveVertRadius * 0.8122605122,
        maskWidth - waveHorRadius,
        curveStartY - waveVertRadius * 0.8936183659,
        maskWidth - waveHorRadius,
        curveStartY - waveVertRadius);

    path.cubicTo(
        maskWidth - waveHorRadius,
        curveStartY - waveVertRadius * 1.100142878,
        maskWidth - waveHorRadius * 0.9595746667,
        curveStartY - waveVertRadius * 1.1887991951,
        maskWidth - waveHorRadius * 0.8608411667,
        curveStartY - waveVertRadius * 1.270484439);

    path.cubicTo(
        maskWidth - waveHorRadius * 0.7852123333,
        curveStartY - waveVertRadius * 1.3330544756,
        maskWidth - waveHorRadius * 0.703382125,
        curveStartY - waveVertRadius * 1.3795848049,
        maskWidth - waveHorRadius * 0.5291125625,
        curveStartY - waveVertRadius * 1.4665102805);

    path.cubicTo(
      maskWidth - waveHorRadius * 0.5241858333,
      curveStartY - waveVertRadius * 1.4689677195,
      maskWidth - waveHorRadius * 0.505739125,
      curveStartY - waveVertRadius * 1.4781625854,
      maskWidth - waveHorRadius * 0.5015305417,
      curveStartY - waveVertRadius * 1.4802616098,
    );

    path.cubicTo(
        maskWidth - waveHorRadius * 0.3187486042,
        curveStartY - waveVertRadius * 1.5714239024,
        maskWidth - waveHorRadius * 0.2332057083,
        curveStartY - waveVertRadius * 1.6204116463,
        maskWidth - waveHorRadius * 0.1541165417,
        curveStartY - waveVertRadius * 1.687403);

    path.cubicTo(
        maskWidth - waveHorRadius * 0.0509933125,
        curveStartY - waveVertRadius * 1.774752061,
        maskWidth,
        curveStartY - waveVertRadius * 1.8709256829,
        maskWidth,
        curveStartY - waveVertRadius * 2);

    path.lineTo(maskWidth, 0);
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 4),
      80,
      Paint()..color = secondaryColor,
    );
  }

  double sidewidth(Size size) {
    var p1 = 0.2;
    var p2 = 0.8;
    if (revealPercent <= p1) {
      return 15.0;
    }
    if (revealPercent >= p2) {
      return size.width;
    }
    return 15.0 + (size.width - 15.0) * (revealPercent - p1) / (p2 - p1);
  }

  double waveVertRadiusF(Size size) {
    var p1 = 0.4;
    if (revealPercent <= 0) {
      return 82.0;
    }
    if (revealPercent >= p1) {
      return size.height * 0.9;
    }
    return 82.0 + ((size.height * 0.9) - 82.0) * revealPercent / p1;
  }

  double waveHorRadiusF(Size size) {
    if (revealPercent <= 0) {
      return 48;
    }
    if (revealPercent >= 1) {
      return 0;
    }
    var p1 = 0.4;
    if (revealPercent <= p1) {
      return 48.0 + revealPercent / p1 * ((size.width * 0.8) - 48.0);
    }
    var t = (revealPercent - p1) / (1.0 - p1);
    var A = size.width * 0.8;
    var r = 40;
    var m = 9.8;
    var beta = r / (2 * m);
    var k = 50;
    var omega0 = k / m;
    var omega = pow(-pow(beta, 2) + pow(omega0, 2), 0.5);

    return A * exp(-beta * t) * cos(omega * t);
  }

  double waveHorRadiusFBack(Size size) {
    if (revealPercent <= 0) {
      return 48;
    }
    if (revealPercent >= 1) {
      return 0;
    }
    var p1 = 0.4;
    if (revealPercent <= p1) {
      return 48.0 + revealPercent / p1 * 48.0;
    }
    var t = (revealPercent - p1) / (1.0 - p1);
    var A = 96;
    var r = 40;
    var m = 9.8;
    var beta = r / (2 * m);
    var k = 50;
    var omega0 = k / m;
    var omega = pow(-pow(beta, 2) + pow(omega0, 2), 0.5);

    return A * exp(-beta * t) * cos(omega * t);
  }
}
