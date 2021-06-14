import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

void main() {
  testWidgets(
    'WHEN two double , AlignmentGeometry, tow EdgeInsetsGeometry, constraints, color and  decoration are fined'
    'THEN they are implicitly animated',
    (tester) async {
      bool selected = false;
      double? height;
      double? width;
      AlignmentGeometry? alignment;
      EdgeInsetsGeometry? padding;
      EdgeInsetsGeometry? margin;
      BoxConstraints? constraints;
      Color? color;
      Decoration? decoration;
      final model = RM.inject(() => 0);

      await tester.pumpWidget(
        On(
          () => AnimateWidget(
            duration: Duration(seconds: 1),
            builder: (_, animate) {
              return Container(
                height: height = animate(selected ? 100 : 0),
                width: width = animate(selected ? 50 : 0, 'width'),
                padding: padding = animate(
                    selected ? EdgeInsets.all(100) : EdgeInsets.all(10))!,
                margin: margin = animate(
                    selected ? EdgeInsets.all(100) : EdgeInsets.all(10),
                    'margin')!,
                alignment: alignment = animate(
                    selected ? Alignment.topLeft : Alignment.bottomRight)!,
                constraints: constraints = animate(selected
                    ? BoxConstraints(maxHeight: 0, maxWidth: 0)
                    : BoxConstraints(maxHeight: 100, maxWidth: 100)),
                color: color = animate(selected ? Colors.white : Colors.red),
                foregroundDecoration: decoration = animate(selected
                    ? BoxDecoration(color: Colors.white)
                    : BoxDecoration(color: Colors.red)),
                child: Container(),
              );
            },
          ),
        ).listenTo(model),
      );
      expect('$height', '0.0');
      expect('$width', '0.0');
      expect('$alignment', 'Alignment.bottomRight');
      expect('$padding', 'EdgeInsets.all(10.0)');
      expect('$margin', 'EdgeInsets.all(10.0)');
      expect('$constraints', 'BoxConstraints(0.0<=w<=100.0, 0.0<=h<=100.0)');
      expect('$color', 'MaterialColor(primary value: Color(0xfff44336))');
      expect('$decoration',
          'BoxDecoration(color: MaterialColor(primary value: Color(0xfff44336)))');

      selected = !selected;
      model.notify();
      await tester.pump();
      await tester.pump(Duration(milliseconds: 500));
      expect('$height', '50.0');
      expect('$width', '25.0');
      expect('$alignment', 'Alignment.center');
      expect('$padding', 'EdgeInsets.all(55.0)');
      expect('$margin', 'EdgeInsets.all(55.0)');
      expect('$constraints', 'BoxConstraints(0.0<=w<=50.0, 0.0<=h<=50.0)');
      expect('$color', 'Color(0xfff9a19a)');
      expect('$decoration', 'BoxDecoration(color: Color(0xfff9a19a))');

      await tester.pumpAndSettle(Duration(milliseconds: 500));
      expect('$height', '100.0');
      expect('$width', '50.0');
      expect('$alignment', 'Alignment.topLeft');
      expect('$padding', 'EdgeInsets.all(100.0)');
      expect('$margin', 'EdgeInsets.all(100.0)');
      expect('$constraints', 'BoxConstraints(w=0.0, h=0.0)');
      expect('$color', 'Color(0xffffffff)');
      expect('$decoration', 'BoxDecoration(color: Color(0xffffffff))');
    },
  );

  testWidgets(
    'WHEN  AlignmentGeometry, tow EdgeInsetsGeometry, constraints, color and  decoration are fined'
    'With some null value'
    'THEN the app works',
    (tester) async {
      bool selected = false;

      AlignmentGeometry? alignment;
      EdgeInsetsGeometry? padding;
      EdgeInsetsGeometry? margin;
      BoxConstraints? constraints;
      Color? color;
      Decoration? decoration;
      final model = RM.inject(() => 0);

      await tester.pumpWidget(On(
        () => AnimateWidget(
          duration: Duration(seconds: 1),
          builder: (_, animate) {
            return Container(
              padding: padding = animate(selected ? EdgeInsets.all(100) : null),
              margin: margin =
                  animate(selected ? null : EdgeInsets.all(10), 'margin'),
              alignment: alignment =
                  animate(selected ? Alignment.topLeft : null),
              constraints: constraints = animate(selected
                  ? null
                  : BoxConstraints(maxHeight: 100, maxWidth: 100)),
              color: color = animate(selected ? null : Colors.red),
              foregroundDecoration: decoration =
                  animate(selected ? BoxDecoration(color: Colors.white) : null),
              child: Container(),
            );
          },
        ),
      ).listenTo(model));

      expect('$alignment', 'null');
      expect('$padding', 'null');
      expect('$margin', 'EdgeInsets.all(10.0)');
      expect('$constraints', 'BoxConstraints(0.0<=w<=100.0, 0.0<=h<=100.0)');
      expect('$color', 'MaterialColor(primary value: Color(0xfff44336))');
      expect('$decoration', 'null');

      selected = !selected;
      model.notify();
      await tester.pump();
      await tester.pump(Duration(milliseconds: 500));

      expect('$alignment', 'Alignment(-0.5, -0.5)');
      expect('$padding', 'EdgeInsets.all(50.0)');
      expect('$margin', 'EdgeInsets.all(5.0)');
      expect('$constraints', 'BoxConstraints(0.0<=w<=50.0, 0.0<=h<=50.0)');
      expect('$color', 'Color(0x80f44336)');
      expect('$decoration', 'BoxDecoration(color: Color(0x80ffffff))');

      await tester.pumpAndSettle(Duration(milliseconds: 500));

      expect('$alignment', 'Alignment.topLeft');
      expect('$padding', 'EdgeInsets.all(100.0)');
      expect('$margin', 'null');
      expect('$constraints', 'null');
      expect('$color', 'null');
      expect('$decoration', 'BoxDecoration(color: Color(0xffffffff))');
    },
  );
  testWidgets(
    'WHEN two variable of the same type and same name are used'
    'THEN it will throw an ArgumentError',
    (tester) async {
      await tester.pumpWidget(AnimateWidget(
          duration: Duration(seconds: 1),
          builder: (_, animate) {
            return Container(
              width: animate(100)!,
              height: animate(50)!,
            );
          }));
      await tester.pump();
      expect(tester.takeException(), isArgumentError);
    },
  );

  testWidgets(
    'WHEN double property is animated '
    'THEN It does not auto started '
    'AND WHEN AnimateWidget rebuild '
    'It start animating form current value to end',
    (tester) async {
      late double inVal = 0;
      late double outVal;

      final model = RM.inject(() => 0);

      await tester.pumpWidget(On(
        () => AnimateWidget(
          duration: Duration(seconds: 1),
          builder: (_, animate) {
            outVal = animate(inVal)!;
            return Container();
          },
        ),
      ).listenTo(model));

      expect(outVal, 0);
      // animating from 0 => 1000
      inVal = 1000;
      model.notify();
      await tester.pump();
      expect(outVal, 0);
      await tester.pump(Duration(milliseconds: 200));
      expect(outVal, 200);
      await tester.pump(Duration(milliseconds: 300));
      expect(outVal, 500);
      await tester.pump(Duration(milliseconds: 500));
      expect(outVal, 1000);
      // animating from 1000 => 2000
      inVal = 2000;
      model.notify();
      await tester.pump();
      await tester.pump();
      expect(outVal, 1000);
      await tester.pump(Duration(milliseconds: 200));
      expect(outVal, 1200);
      await tester.pump(Duration(milliseconds: 300));
      expect(outVal, 1500);
      await tester.pump(Duration(milliseconds: 500));
      expect(outVal, 2000);
    },
  );

  testWidgets(
    'WHEN Tween<Double> property is animated '
    'THEN It does auto started '
    'AND WHEN AnimateWidget rebuild '
    'It start animating form current value to end '
    'And when begin and and values of the tween are equal '
    'animation does not start',
    (tester) async {
      late double inVal = 1000;
      late double outVal;

      final model = RM.inject(() => 0);

      await tester.pumpWidget(On(
        () => AnimateWidget(
          duration: Duration(seconds: 1),
          builder: (_, animate) {
            outVal = animate.fromTween(
              (current) {
                return Tween<double>(begin: current ?? 0, end: inVal);
              },
            )!;
            return Container();
          },
        ),
      ).listenTo(model));
      await tester.pump();

      expect(outVal, 0);
      await tester.pump(Duration(milliseconds: 200));
      expect(outVal, 200);
      await tester.pump(Duration(milliseconds: 300));
      expect(outVal, 500);
      await tester.pump(Duration(milliseconds: 500));
      expect(outVal, 1000);
      await tester.pumpAndSettle();

      // animating from 1000 => 2000
      inVal = 2000;
      model.notify();
      await tester.pump();
      expect(outVal, 1000);
      await tester.pump(Duration(milliseconds: 200));
      expect(outVal, 1200);
      await tester.pump(Duration(milliseconds: 300));
      expect(outVal, 1500);
      await tester.pump(Duration(milliseconds: 500));
      expect(outVal, 2000);
      //the same value
      inVal = 2000;
      model.notify();
      await tester.pump();
      await tester.pump();

      expect(outVal, 2000);
      model.notify();
      await tester.pump();

      await tester.pump(Duration(milliseconds: 200));
      expect(outVal, 2000);
      model.notify();
      await tester.pump();

      await tester.pump(Duration(milliseconds: 300));
      expect(outVal, 2000);
      model.notify();
      await tester.pump();

      await tester.pump(Duration(milliseconds: 500));
      expect(outVal, 2000);
    },
  );

  testWidgets(
    'WHEN int property is animated '
    'THEN It does not auto started '
    'AND WHEN AnimateWidget rebuild '
    'It start animating form current value to end',
    (tester) async {
      late int inVal = 0;
      late int outVal;

      final model = RM.inject(() => 0);

      await tester.pumpWidget(On(
        () => AnimateWidget(
          duration: Duration(seconds: 1),
          builder: (_, animate) {
            outVal = animate(inVal)!;
            return Container();
          },
        ),
      ).listenTo(model));
      await tester.pump();

      expect(outVal, 0);
      // animating from 0 => 1000
      inVal = 1000;
      model.notify();
      await tester.pump();
      expect(outVal, 0);
      await tester.pump(Duration(milliseconds: 200));
      expect(outVal, 200);
      await tester.pump(Duration(milliseconds: 300));
      expect(outVal, 500);
      await tester.pump(Duration(milliseconds: 500));
      expect(outVal, 1000);
      // animating from 1000 => 2000
      inVal = 2000;
      model.notify();
      await tester.pump();

      expect(outVal, 1000);
      await tester.pump(Duration(milliseconds: 200));
      expect(outVal, 1200);
      await tester.pump(Duration(milliseconds: 300));
      expect(outVal, 1500);
      await tester.pump(Duration(milliseconds: 500));
      expect(outVal, 2000);
    },
  );

  testWidgets(
    'WHEN Color property is animated '
    'THEN It does not auto started '
    'AND WHEN AnimateWidget rebuild '
    'It start animating form current value to end',
    (tester) async {
      Color? inVal; //Transparent
      Color? outVal;

      final model = RM.inject(() => 0);

      await tester.pumpWidget(On(
        () => AnimateWidget(
          duration: Duration(seconds: 1),
          builder: (_, animate) {
            outVal = animate(inVal);
            return Container();
          },
        ),
      ).listenTo(model));
      await tester.pump();

      expect(outVal, null);
      //
      inVal = Colors.blue;
      model.notify();
      await tester.pump();
      expect(outVal, Color(0x002196f3));
      await tester.pump(Duration(milliseconds: 200));
      expect(outVal, Color(0x332196f3));
      await tester.pump(Duration(milliseconds: 300));
      expect(outVal, Color(0x802196f3));
      await tester.pump(Duration(milliseconds: 500));
      print(outVal);
      expect(outVal, Colors.blue);
      // animating from blue => red
      inVal = Colors.red;
      model.notify();
      await tester.pump();
      expect(outVal, Colors.blue);
      await tester.pump(Duration(milliseconds: 200));
      print(outVal);
      expect(outVal, Color(0xff4b85cd));
      await tester.pump(Duration(milliseconds: 300));
      expect(outVal, Color(0xff8a6c94));
      await tester.pump(Duration(milliseconds: 500));
      expect(outVal, Colors.red);
    },
  );

  testWidgets(
    'WHEN AlignmentGeometry and AlignmentDirectional property is animated '
    'THEN It does not auto started '
    'AND WHEN AnimateWidget rebuild '
    'It start animating form current value to end',
    (tester) async {
      AlignmentGeometry? inVal; // Alignment.center
      AlignmentGeometry? outVal;

      final model = RM.inject(() => 0);

      await tester.pumpWidget(On(
        () => AnimateWidget(
          duration: Duration(seconds: 1),
          builder: (_, animate) {
            outVal = animate(inVal);
            return Container();
          },
        ),
      ).listenTo(model));
      await tester.pump();

      expect(outVal, null);
      // animating from Alignment.center =>  Alignment.topLeft
      inVal = Alignment.topLeft;
      model.notify();
      await tester.pump();
      expect(outVal, Alignment.center);
      await tester.pump(Duration(milliseconds: 200));

      expect(outVal, Alignment(-0.2, -0.2));
      await tester.pump(Duration(milliseconds: 300));

      expect(outVal, Alignment(-0.5, -0.5));
      await tester.pump(Duration(milliseconds: 500));

      expect(outVal, Alignment.topLeft);
      // animating from Alignment.topLeft => Alignment.bottomRight
      inVal = AlignmentDirectional.bottomEnd;
      model.notify();
      await tester.pump();
      expect(outVal, Alignment.topLeft);
      await tester.pump(Duration(milliseconds: 200));
      expect(
          '$outVal', 'Alignment(-0.8, -0.6) + AlignmentDirectional(0.2, 0.0)');
      await tester.pump(Duration(milliseconds: 300));
      expect(
          '$outVal', 'Alignment(-0.5, 0.0) + AlignmentDirectional(0.5, 0.0)');
      await tester.pump(Duration(milliseconds: 500));
      expect(outVal, AlignmentDirectional.bottomEnd);
    },
  );

  testWidgets(
    'WHEN EdgeInsetsGeometry and EdgeInsetsDirectional property is animated '
    'THEN It does not auto started '
    'AND WHEN AnimateWidget rebuild '
    'It start animating form current value to end',
    (tester) async {
      EdgeInsetsGeometry? inVal; //EdgeInsets.zero
      EdgeInsetsGeometry? outVal;

      final model = RM.inject(() => 0);

      await tester.pumpWidget(On(
        () => AnimateWidget(
          duration: Duration(seconds: 1),
          builder: (_, animate) {
            outVal = animate(inVal);
            return Container();
          },
        ),
      ).listenTo(model));

      expect(outVal, null);
      // animating from EdgeInsets.zero => EdgeInsets.all(10.0)
      inVal = EdgeInsets.all(10);
      model.notify();
      await tester.pump();
      expect(outVal, EdgeInsets.zero);
      await tester.pump(Duration(milliseconds: 200));
      expect(outVal, EdgeInsets.all(2.0));
      await tester.pump(Duration(milliseconds: 300));
      expect(outVal, EdgeInsets.all(5.0));
      await tester.pump(Duration(milliseconds: 500));
      expect(outVal, EdgeInsets.all(10.0));
      // animating from EdgeInsets.all(10.0) => red
      inVal = EdgeInsetsDirectional.all(20);
      model.notify();
      await tester.pump();
      expect(outVal, EdgeInsets.all(10.0));
      await tester.pump(Duration(milliseconds: 200));
      expect('$outVal',
          'EdgeInsets(8.0, 12.0, 8.0, 12.0) + EdgeInsetsDirectional(4.0, 0.0, 4.0, 0.0)');
      await tester.pump(Duration(milliseconds: 300));
      expect('$outVal',
          'EdgeInsets(5.0, 15.0, 5.0, 15.0) + EdgeInsetsDirectional(10.0, 0.0, 10.0, 0.0)');
      await tester.pump(Duration(milliseconds: 500));
      expect('$outVal', 'EdgeInsetsDirectional(20.0, 20.0, 20.0, 20.0)');
    },
  );

  testWidgets(
    'WHEN Decoration property is animated '
    'THEN It does not auto started '
    'AND WHEN AnimateWidget rebuild '
    'It start animating form current value to end',
    (tester) async {
      Decoration? inVal;
      Decoration? outVal;

      final model = RM.inject(() => 0);

      await tester.pumpWidget(On(
        () => AnimateWidget(
          duration: Duration(seconds: 1),
          builder: (_, animate) {
            outVal = animate(inVal);
            return Container();
          },
        ),
      ).listenTo(model));

      expect(outVal, null);

      inVal = BoxDecoration(border: Border.all(width: 1));
      model.notify();
      await tester.pump();
      expect('$outVal',
          'BoxDecoration(border: Border.all(BorderSide(Color(0xff000000), 0.0, BorderStyle.none)))');
      await tester.pump(Duration(milliseconds: 200));
      expect('$outVal',
          'BoxDecoration(border: Border.all(BorderSide(Color(0xff000000), 0.2, BorderStyle.solid)))');
      await tester.pump(Duration(milliseconds: 300));
      expect('$outVal',
          'BoxDecoration(border: Border.all(BorderSide(Color(0xff000000), 0.5, BorderStyle.solid)))');
      await tester.pump(Duration(milliseconds: 500));
      expect('$outVal',
          'BoxDecoration(border: Border.all(BorderSide(Color(0xff000000), 1.0, BorderStyle.solid)))');
      //

      inVal = BoxDecoration(border: Border.all(width: 2));
      model.notify();
      await tester.pump();
      expect('$outVal',
          'BoxDecoration(border: Border.all(BorderSide(Color(0xff000000), 1.0, BorderStyle.solid)))');
      await tester.pump(Duration(milliseconds: 200));
      expect('$outVal',
          'BoxDecoration(border: Border.all(BorderSide(Color(0xff000000), 1.2, BorderStyle.solid)))');
      await tester.pump(Duration(milliseconds: 300));
      expect('$outVal',
          'BoxDecoration(border: Border.all(BorderSide(Color(0xff000000), 1.5, BorderStyle.solid)))');
      await tester.pump(Duration(milliseconds: 500));
      expect('$outVal',
          'BoxDecoration(border: Border.all(BorderSide(Color(0xff000000), 2.0, BorderStyle.solid)))');
    },
  );

  testWidgets(
    'WHEN BoxConstraints property is animated '
    'THEN It does not auto started '
    'AND WHEN AnimateWidget rebuild '
    'It start animating form current value to end',
    (tester) async {
      BoxConstraints? inVal; //Transparent
      BoxConstraints? outVal;

      final model = RM.inject(() => 0);

      await tester.pumpWidget(On(
        () => AnimateWidget(
          duration: Duration(seconds: 1),
          builder: (_, animate) {
            outVal = animate(inVal);
            return Container();
          },
        ),
      ).listenTo(model));

      expect(outVal, null);

      inVal = BoxConstraints(maxHeight: 10, maxWidth: 10);
      model.notify();
      await tester.pump();
      expect('$outVal', 'BoxConstraints(w=0.0, h=0.0)');
      await tester.pump(Duration(milliseconds: 200));
      expect('$outVal', 'BoxConstraints(0.0<=w<=2.0, 0.0<=h<=2.0)');
      await tester.pump(Duration(milliseconds: 300));
      expect('$outVal', 'BoxConstraints(0.0<=w<=5.0, 0.0<=h<=5.0)');
      await tester.pump(Duration(milliseconds: 500));
      expect('$outVal', 'BoxConstraints(0.0<=w<=10.0, 0.0<=h<=10.0)');
      //
      inVal = BoxConstraints(maxHeight: 20, maxWidth: 20);
      model.notify();
      await tester.pump();
      expect('$outVal', 'BoxConstraints(0.0<=w<=10.0, 0.0<=h<=10.0)');
      await tester.pump(Duration(milliseconds: 200));
      expect('$outVal', 'BoxConstraints(0.0<=w<=12.0, 0.0<=h<=12.0)');
      await tester.pump(Duration(milliseconds: 300));
      print(outVal);
      expect('$outVal', 'BoxConstraints(0.0<=w<=15.0, 0.0<=h<=15.0)');
      await tester.pump(Duration(milliseconds: 500));
      expect('$outVal', 'BoxConstraints(0.0<=w<=20.0, 0.0<=h<=20.0)');
    },
  );
  testWidgets(
    'WHEN Matrix4 property is animated '
    'THEN It does not auto started '
    'AND WHEN AnimateWidget rebuild '
    'It start animating form current value to end',
    (tester) async {
      Matrix4? inVal = Matrix4.diagonal3Values(0, 0, 0);
      Matrix4? outVal;

      final model = RM.inject(() => 0);

      await tester.pumpWidget(On(
        () => AnimateWidget(
          duration: Duration(seconds: 1),
          builder: (_, animate) {
            outVal = animate(inVal);
            return Container();
          },
        ),
      ).listenTo(model));

      inVal = Matrix4.diagonal3Values(10, 10, 10);
      model.notify();
      await tester.pump();
      expect('${outVal?.row0}', '0.0,0.0,0.0,0.0');
      await tester.pump(Duration(milliseconds: 200));
      expect('${outVal?.row0}', 'NaN,NaN,NaN,0.0');
      await tester.pump(Duration(milliseconds: 300));
      expect('${outVal?.row0}', 'NaN,NaN,NaN,0.0');
      await tester.pump(Duration(milliseconds: 500));
      expect('${outVal?.row0}', '10.0,0.0,0.0,0.0');
      //
      inVal = Matrix4.diagonal3Values(20, 20, 20);
      model.notify();
      await tester.pump();
      expect('${outVal?.row0}', '10.0,0.0,0.0,0.0');
      await tester.pump(Duration(milliseconds: 200));
      expect('${outVal?.row0}', '12.0,0.0,0.0,0.0');
      await tester.pump(Duration(milliseconds: 300));
      expect('${outVal?.row0}', '15.0,0.0,0.0,0.0');
      await tester.pump(Duration(milliseconds: 500));
      expect('${outVal?.row0}', '20.0,0.0,0.0,0.0');
    },
  );

  testWidgets(
    'WHEN TextStyle property is animated '
    'THEN It does not auto started '
    'AND WHEN AnimateWidget rebuild '
    'It start animating form current value to end',
    (tester) async {
      TextStyle? inVal = TextStyle(fontSize: 0); //Transparent
      TextStyle? outVal;

      final model = RM.inject(() => 0);

      await tester.pumpWidget(On(
        () => AnimateWidget(
          duration: Duration(seconds: 1),
          builder: (_, animate) {
            outVal = animate(inVal);
            return Container();
          },
        ),
      ).listenTo(model));

      // expect(outVal, 0);
      //
      inVal = TextStyle(fontSize: 10);
      model.notify();
      await tester.pump();
      expect(outVal?.fontSize, 0);

      await tester.pump(Duration(milliseconds: 200));
      expect(outVal?.fontSize, 2.0);
      await tester.pump(Duration(milliseconds: 300));
      expect(outVal?.fontSize, 5.0);
      await tester.pump(Duration(milliseconds: 500));
      expect(outVal?.fontSize, 10.0);

      inVal = TextStyle(fontSize: 20);
      model.notify();
      await tester.pump();
      expect(outVal?.fontSize, 10.0);
      await tester.pump(Duration(milliseconds: 200));
      expect(outVal?.fontSize, 12.0);
      await tester.pump(Duration(milliseconds: 300));
      expect(outVal?.fontSize, 15.0);
      await tester.pump(Duration(milliseconds: 500));
      expect(outVal?.fontSize, 20.0);
    },
  );

  testWidgets(
    'WHEN BorderRadius property is animated '
    'THEN It does not auto started '
    'AND WHEN AnimateWidget rebuild '
    'It start animating form current value to end',
    (tester) async {
      BorderRadius? inVal;
      BorderRadius? outVal;

      final model = RM.inject(() => 0);

      await tester.pumpWidget(On(
        () => AnimateWidget(
          duration: Duration(seconds: 1),
          builder: (_, animate) {
            outVal = animate(inVal);
            return Container();
          },
        ),
      ).listenTo(model));

      // expect(outVal, 0);
      //
      inVal = BorderRadius.circular(10);
      model.notify();
      await tester.pump();
      expect('$outVal', 'BorderRadius.zero');
      await tester.pump(Duration(milliseconds: 200));
      expect('$outVal', 'BorderRadius.circular(2.0)');

      await tester.pump(Duration(milliseconds: 300));
      expect('$outVal', 'BorderRadius.circular(5.0)');

      await tester.pump(Duration(milliseconds: 500));
      expect('$outVal', 'BorderRadius.circular(10.0)');

      //
      inVal = BorderRadius.circular(20);
      model.notify();
      await tester.pump();
      expect('$outVal', 'BorderRadius.circular(10.0)');
      await tester.pump(Duration(milliseconds: 200));
      expect('$outVal', 'BorderRadius.circular(12.0)');
      await tester.pump(Duration(milliseconds: 300));
      expect('$outVal', 'BorderRadius.circular(15.0)');
      await tester.pump(Duration(milliseconds: 500));
      expect('$outVal', 'BorderRadius.circular(20.0)');
    },
  );

  testWidgets(
    'WHEN ThemeData property is animated '
    'THEN It does not auto started '
    'AND WHEN AnimateWidget rebuild '
    'It start animating form current value to end',
    (tester) async {
      ThemeData? inVal = ThemeData.light();
      ThemeData? outVal;

      final model = RM.inject(() => 0);

      await tester.pumpWidget(On(
        () => AnimateWidget(
          duration: Duration(seconds: 1),
          builder: (_, animate) {
            outVal = animate(inVal);
            return Container();
          },
        ),
      ).listenTo(model));

      // expect(outVal, 0);
      //
      inVal = ThemeData.dark();
      model.notify();
      await tester.pump();
      expect('${outVal?.accentColor}', 'Color(0xff2196f3)');
      await tester.pump(Duration(milliseconds: 200));
      expect('${outVal?.accentColor}', 'Color(0xff2eabee)');

      await tester.pump(Duration(milliseconds: 300));
      expect('${outVal?.accentColor}', 'Color(0xff42cae6)');

      await tester.pump(Duration(milliseconds: 500));
      expect('${outVal?.accentColor}', 'Color(0xff64ffda)');

      //
      inVal = ThemeData.light();
      model.notify();
      await tester.pump();

      expect('${outVal?.accentColor}', 'Color(0xff64ffda)');

      await tester.pump(Duration(milliseconds: 200));
      expect('${outVal?.accentColor}', 'Color(0xff56eadf)');

      await tester.pump(Duration(milliseconds: 300));
      expect('${outVal?.accentColor}', 'Color(0xff42cae6)');

      await tester.pump(Duration(milliseconds: 500));
      expect('${outVal?.accentColor}', 'Color(0xff2196f3)');
    },
  );

  testWidgets(
    'WHEN the animated property has no built-in tween'
    'THEN it throw Unimplemented Error',
    (tester) async {
      Text? inVal = Text('');

      await tester.pumpWidget(
        AnimateWidget(
          duration: Duration(seconds: 1),
          builder: (_, animate) {
            animate(inVal);
            return Container();
          },
        ),
      );

      expect(tester.takeException(), isUnimplementedError);
    },
  );

  testWidgets(
    'WHEN Offset property is animated '
    'THEN It does not auto started '
    'AND WHEN AnimateWidget rebuild '
    'It start animating form current value to end',
    (tester) async {
      Offset? inVal = Offset.zero;
      Offset? outVal;

      final model = RM.inject(() => 0);

      await tester.pumpWidget(On(
        () => AnimateWidget(
          duration: Duration(seconds: 1),
          builder: (_, animate) {
            outVal = animate(inVal);
            return Container();
          },
        ),
      ).listenTo(model));

      // expect(outVal, 0);
      //
      inVal = Offset(10, 10);
      model.notify();
      await tester.pump();

      expect('$outVal', 'Offset(0.0, 0.0)');
      await tester.pump(Duration(milliseconds: 200));
      expect('$outVal', 'Offset(2.0, 2.0)');
      await tester.pump(Duration(milliseconds: 300));
      expect('$outVal', 'Offset(5.0, 5.0)');
      await tester.pump(Duration(milliseconds: 500));
      expect('$outVal', 'Offset(10.0, 10.0)');
      //
      inVal = Offset(20, 20);
      model.notify();
      await tester.pump();

      expect('$outVal', 'Offset(10.0, 10.0)');
      await tester.pump(Duration(milliseconds: 200));
      expect('$outVal', 'Offset(12.0, 12.0)');
      await tester.pump(Duration(milliseconds: 300));
      expect('$outVal', 'Offset(15.0, 15.0)');
      await tester.pump(Duration(milliseconds: 500));
      expect('$outVal', 'Offset(20.0, 20.0)');
    },
  );

  testWidgets(
    'WHEN Size property is animated '
    'THEN It does not auto started '
    'AND WHEN AnimateWidget rebuild '
    'It start animating form current value to end',
    (tester) async {
      Size? inVal;
      Size? outVal;

      final model = RM.inject(() => 0);

      await tester.pumpWidget(On(
        () => AnimateWidget(
          duration: Duration(seconds: 1),
          builder: (_, animate) {
            outVal = animate(inVal);
            return Container();
          },
        ),
      ).listenTo(model));

      // expect(outVal, 0);
      //
      inVal = Size(10, 10);
      model.notify();
      await tester.pump();

      expect('$outVal', 'Size(0.0, 0.0)');
      await tester.pump(Duration(milliseconds: 200));
      expect('$outVal', 'Size(2.0, 2.0)');
      await tester.pump(Duration(milliseconds: 300));
      expect('$outVal', 'Size(5.0, 5.0)');
      await tester.pump(Duration(milliseconds: 500));
      expect('$outVal', 'Size(10.0, 10.0)');
      //
      inVal = Size(20, 20);
      model.notify();
      await tester.pump();

      expect('$outVal', 'Size(10.0, 10.0)');
      await tester.pump(Duration(milliseconds: 200));
      expect('$outVal', 'Size(12.0, 12.0)');
      await tester.pump(Duration(milliseconds: 300));
      expect('$outVal', 'Size(15.0, 15.0)');
      await tester.pump(Duration(milliseconds: 500));
      expect('$outVal', 'Size(20.0, 20.0)');
    },
  );

  testWidgets(
    'WHEN Rect property is animated '
    'THEN It does not auto started '
    'AND WHEN AnimateWidget rebuild '
    'It start animating form current value to end',
    (tester) async {
      Rect? inVal;
      Rect? outVal;

      final model = RM.inject(() => 0);

      await tester.pumpWidget(On(
        () => AnimateWidget(
          duration: Duration(seconds: 1),
          builder: (_, animate) {
            outVal = animate(inVal);
            return Container();
          },
        ),
      ).listenTo(model));

      // expect(outVal, 0);
      //
      inVal = Rect.fromLTRB(10, 10, 10, 10);
      model.notify();
      await tester.pump();
      expect('$outVal', 'Rect.fromLTRB(0.0, 0.0, 0.0, 0.0)');
      await tester.pump(Duration(milliseconds: 200));
      expect('$outVal', 'Rect.fromLTRB(2.0, 2.0, 2.0, 2.0)');

      await tester.pump(Duration(milliseconds: 300));
      expect('$outVal', 'Rect.fromLTRB(5.0, 5.0, 5.0, 5.0)');

      await tester.pump(Duration(milliseconds: 500));
      expect('$outVal', 'Rect.fromLTRB(10.0, 10.0, 10.0, 10.0)');

      //
      inVal = Rect.fromLTRB(20, 20, 20, 20);
      model.notify();
      await tester.pump();

      expect('$outVal', 'Rect.fromLTRB(10.0, 10.0, 10.0, 10.0)');

      await tester.pump(Duration(milliseconds: 200));
      expect('$outVal', 'Rect.fromLTRB(12.0, 12.0, 12.0, 12.0)');

      await tester.pump(Duration(milliseconds: 300));
      expect('$outVal', 'Rect.fromLTRB(15.0, 15.0, 15.0, 15.0)');

      await tester.pump(Duration(milliseconds: 500));
      expect('$outVal', 'Rect.fromLTRB(20.0, 20.0, 20.0, 20.0)');
    },
  );

  testWidgets(
    'WHEN RelativeRect property is animated '
    'THEN It does not auto started '
    'AND WHEN AnimateWidget rebuild '
    'It start animating form current value to end',
    (tester) async {
      RelativeRect? inVal;
      RelativeRect? outVal;

      final model = RM.inject(() => 0);

      await tester.pumpWidget(On(
        () => AnimateWidget(
          duration: Duration(seconds: 1),
          builder: (_, animate) {
            outVal = animate(inVal);
            return Container();
          },
        ),
      ).listenTo(model));

      // expect(outVal, 0);
      //
      inVal = RelativeRect.fromLTRB(10, 10, 10, 10);
      model.notify();
      await tester.pump();
      expect('$outVal', 'RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0)');
      await tester.pump(Duration(milliseconds: 200));
      expect('$outVal', 'RelativeRect.fromLTRB(2.0, 2.0, 2.0, 2.0)');

      await tester.pump(Duration(milliseconds: 300));
      expect('$outVal', 'RelativeRect.fromLTRB(5.0, 5.0, 5.0, 5.0)');

      await tester.pump(Duration(milliseconds: 500));
      expect('$outVal', 'RelativeRect.fromLTRB(10.0, 10.0, 10.0, 10.0)');
      //
      inVal = RelativeRect.fromLTRB(20, 20, 20, 20);
      model.notify();
      await tester.pump();

      expect('$outVal', 'RelativeRect.fromLTRB(10.0, 10.0, 10.0, 10.0)');

      await tester.pump(Duration(milliseconds: 200));
      expect('$outVal', 'RelativeRect.fromLTRB(12.0, 12.0, 12.0, 12.0)');

      await tester.pump(Duration(milliseconds: 300));
      expect('$outVal', 'RelativeRect.fromLTRB(15.0, 15.0, 15.0, 15.0)');

      await tester.pump(Duration(milliseconds: 500));
      expect('$outVal', 'RelativeRect.fromLTRB(20.0, 20.0, 20.0, 20.0)');
    },
  );

  testWidgets(
    'WHEN MaterialRectArcTween property is animated using Animate.fromTween'
    'AND WEHN cycle is 2'
    'THEN It does auto started and cycle 2 times ',
    (tester) async {
      Rect? inVal = Rect.fromLTRB(20, 20, 20, 20);
      Rect? outVal;

      final model = RM.inject(() => 0);

      await tester.pumpWidget(On(
        () => AnimateWidget(
          cycles: 2,
          duration: Duration(seconds: 1),
          builder: (_, animate) {
            outVal = animate.fromTween(
              (currentVal) => MaterialRectArcTween(
                begin: currentVal ?? Rect.fromLTRB(10, 10, 10, 10),
                end: inVal,
              ),
            );
            return Container();
          },
        ),
      ).listenTo(model));

      expect('$outVal', 'Rect.fromLTRB(10.0, 10.0, 10.0, 10.0)');
      await tester.pump();
      await tester.pump(Duration(milliseconds: 200));
      expect('$outVal', 'Rect.fromLTRB(13.1, 10.5, 13.1, 10.5)');

      await tester.pump(Duration(milliseconds: 300));
      expect('$outVal', 'Rect.fromLTRB(17.1, 12.9, 17.1, 12.9)');

      await tester.pump(Duration(milliseconds: 500));
      expect('$outVal', 'Rect.fromLTRB(20.0, 20.0, 20.0, 20.0)');
      await tester.pump();
      await tester.pump();
      //
      await tester.pump(Duration(milliseconds: 200));
      print('$outVal');

      await tester.pump(Duration(milliseconds: 300));
      print('$outVal');

      await tester.pump(Duration(milliseconds: 500));
      print('$outVal');

      await tester.pump(Duration(milliseconds: 500));
      print('$outVal');
    },
  );

  testWidgets(
    'WHEN repeats is 2 '
    'THEN the animation repeats two times',
    (tester) async {
      late double inVal = 0;
      late double outVal;

      final model = RM.inject(() => 0);

      await tester.pumpWidget(On(
        () => AnimateWidget(
          duration: Duration(seconds: 1),
          repeats: 2,
          builder: (_, animate) {
            outVal = animate(inVal)!;
            return Container();
          },
        ),
      ).listenTo(model));

      expect(outVal, 0);
      //
      inVal = 1000;
      model.notify();
      await tester.pump();
      await tester.pump();
      expect(outVal, 0);
      await tester.pump(Duration(milliseconds: 200));
      expect(outVal, 200);
      await tester.pump(Duration(milliseconds: 300));
      expect(outVal, 500);
      await tester.pump(Duration(milliseconds: 500));
      expect(outVal, 1000);
      //Offset duration added for test
      await tester.pump(Duration(milliseconds: 100));
      expect(outVal, 0);
      await tester.pump(Duration(milliseconds: 200));
      expect(outVal, 200);
      await tester.pump(Duration(milliseconds: 300));
      expect(outVal, 500);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      expect(outVal, 1000);
      //
      inVal = 2000;
      model.notify();
      await tester.pump();
      await tester.pump();
      expect(outVal, 1000);
      await tester.pump(Duration(milliseconds: 200));
      expect(outVal, 1200);
      await tester.pump(Duration(milliseconds: 300));
      expect(outVal, 1500);
      await tester.pump(Duration(milliseconds: 500));
      expect(outVal, 2000);
      //Offset duration added for test
      await tester.pump(Duration(milliseconds: 100));
      expect(outVal, 1000);
      await tester.pump(Duration(milliseconds: 200));
      expect(outVal, 1200);
      await tester.pump(Duration(milliseconds: 300));
      expect(outVal, 1500);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      expect(outVal, 2000);
    },
  );

  testWidgets(
    'WHEN repeats is 2 '
    'THEN the animation with tween repeats two times',
    (tester) async {
      late double inVal = 0;
      late double outVal;

      final model = RM.inject(() => 0);

      await tester.pumpWidget(On(
        () => AnimateWidget(
          duration: Duration(seconds: 1),
          repeats: 2,
          builder: (_, animate) {
            outVal = animate.fromTween(
              (current) => Tween(begin: current ?? inVal, end: inVal),
            )!;
            return Container();
          },
        ),
      ).listenTo(model));

      expect(outVal, 0);
      //
      inVal = 1000;
      model.notify();
      await tester.pump();
      await tester.pump();
      expect(outVal, 0);
      await tester.pump(Duration(milliseconds: 200));
      expect(outVal, 200);
      await tester.pump(Duration(milliseconds: 300));
      expect(outVal, 500);
      await tester.pump(Duration(milliseconds: 500));
      expect(outVal, 1000);
      //Offset duration added for test
      await tester.pump(Duration(milliseconds: 100));
      expect(outVal, 0);
      await tester.pump(Duration(milliseconds: 200));
      expect(outVal, 200);
      await tester.pump(Duration(milliseconds: 300));
      expect(outVal, 500);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      expect(outVal, 1000);
      //
      inVal = 2000;
      model.notify();
      await tester.pump();
      await tester.pump();
      expect(outVal, 1000);
      await tester.pump(Duration(milliseconds: 200));
      expect(outVal, 1200);
      await tester.pump(Duration(milliseconds: 300));
      expect(outVal, 1500);
      await tester.pump(Duration(milliseconds: 500));
      expect(outVal, 2000);
      //Offset duration added for test
      await tester.pump(Duration(milliseconds: 100));
      expect(outVal, 1000);
      await tester.pump(Duration(milliseconds: 200));
      expect(outVal, 1200);
      await tester.pump(Duration(milliseconds: 300));
      expect(outVal, 1500);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      expect(outVal, 2000);
    },
  );

  testWidgets(
    'WHEN cycle is 2 '
    'THEN the animation cycles two times',
    (tester) async {
      late double inVal = 0;
      late double outVal;

      final model = RM.inject(() => 0);

      await tester.pumpWidget(On(
        () => AnimateWidget(
          duration: Duration(seconds: 1),
          cycles: 2,
          builder: (_, animate) {
            outVal = animate(inVal)!;
            return Container();
          },
        ),
      ).listenTo(model));

      expect(outVal, 0);
      //
      inVal = 1000;
      model.notify();
      await tester.pump();
      await tester.pump();
      expect(outVal, 0);
      await tester.pump(Duration(milliseconds: 200));
      expect(outVal, 200);
      await tester.pump(Duration(milliseconds: 300));
      expect(outVal, 500);
      await tester.pump(Duration(milliseconds: 500));
      expect(outVal, 1000);
      //Offset duration added for test
      await tester.pump(Duration(milliseconds: 100));
      expect(outVal, 1000);
      await tester.pump(Duration(milliseconds: 200));
      expect(outVal, 800);
      await tester.pump(Duration(milliseconds: 300));
      expect(outVal, 500);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      expect(outVal, 0);
      //
      inVal = 1000;
      model.notify();
      await tester.pump();
      await tester.pump();
      expect(outVal, 0);
      await tester.pump(Duration(milliseconds: 200));
      expect(outVal, 0);
      await tester.pump(Duration(milliseconds: 300));
      expect(outVal, 0);
      await tester.pump(Duration(milliseconds: 500));
      expect(outVal, 0);

      //
      inVal = 2000;
      model.notify();
      await tester.pump();
      await tester.pump();
      expect(outVal, 0);
      await tester.pump(Duration(milliseconds: 200));
      expect(outVal, 400);
      await tester.pump(Duration(milliseconds: 300));
      expect(outVal, 1000);
      await tester.pump(Duration(milliseconds: 500));
      expect(outVal, 2000);
      //Offset duration added for test
      await tester.pump(Duration(milliseconds: 100));
      expect(outVal, 2000);
      await tester.pump(Duration(milliseconds: 200));
      expect(outVal, 1600);
      await tester.pump(Duration(milliseconds: 300));
      expect(outVal, 1000);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      expect(outVal, 0);
    },
  );
}
