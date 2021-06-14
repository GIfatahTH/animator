# ex_002_explicit_animation


This is an example showing how to use explicit animation using `AnimateWidget`.

```dart
 AnimateWidget(
          duration: const Duration(seconds: 1),
          reverseDuration: 3.seconds(),// use extension
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
              (currentValue) => 100.0.tweenTo(200.0), //use of extension
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
```