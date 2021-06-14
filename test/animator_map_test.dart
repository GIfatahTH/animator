import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:animator/src/animator.dart';

void main() {
  testWidgets('TweenMap default setting : auto start and stop ofter 500ms',
      (WidgetTester tester) async {
    double? animationValue;
    Offset? offsetValue;
    AnimationStatus? animationStatue;
    var numberOfRepeats = 0;
    final animator = Animator<Offset>(
      tween: Tween<Offset>(begin: Offset.zero, end: const Offset(1, 10)),
      tweenMap: {
        'anim1': Tween<double>(begin: 0, end: 1),
      },
      statusListener: (status, anim) {
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
      },
      builder: (_, anim, __) {
        offsetValue = anim.value;
        animationValue = anim.getValue<double>('anim1');
        animationStatue = anim.getAnimation<double>('anim1').status;
        return Container();
      },
    );

    expect(animationValue, isNull);
    expect(animationStatue, isNull);

    await tester.pumpWidget(animator);

    expect(animationValue, equals(0));
    expect(offsetValue, equals(Offset.zero));
    expect(animationStatue, equals(AnimationStatus.forward));

    await tester.pumpAndSettle();

    expect(animationValue, equals(1));
    expect(offsetValue, equals(const Offset(1, 10)));

    expect(animationStatue, equals(AnimationStatus.completed));
    expect(numberOfRepeats, equals(1));
  });

  testWidgets(
      'TweenMap Two tweens (double and Offset): '
      'auto start and stop ofter 500ms', (WidgetTester tester) async {
    double? animationValue1;
    Offset? animationValue2;
    AnimationStatus? animationStatue;
    var numberOfRepeats = 0;
    final animator = Animator<double>(
      tweenMap: {
        'anim1': Tween<double>(begin: 0, end: 1),
        'anim2': Tween<Offset>(begin: Offset.zero, end: const Offset(10, 10)),
      },
      statusListener: (status, anim) {
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
      },
      builder: (_, anim, __) {
        animationValue1 = anim.getValue<double>('anim1');
        animationValue2 = anim.getValue<Offset>('anim2');
        animationStatue = anim.getAnimation<double>('anim1').status;
        return Container();
      },
    );

    expect(animationValue1, isNull);
    expect(animationValue2, isNull);
    expect(animationStatue, isNull);

    await tester.pumpWidget(animator);

    expect(animationValue1, equals(0));
    expect(animationValue2, equals(Offset.zero));
    expect(animationStatue, equals(AnimationStatus.forward));

    await tester.pumpAndSettle();

    expect(animationValue1, equals(1));
    expect(animationValue2, equals(const Offset(10, 10)));
    expect(animationStatue, equals(AnimationStatus.completed));
    expect(numberOfRepeats, equals(1));
  });

  testWidgets(
      'TweenMap three tweens '
      '(double and Offset and int): auto start and stop ofter 500ms',
      (WidgetTester tester) async {
    double? animationValue1;
    Offset? animationValue2;
    int? animationValue3;
    AnimationStatus? animationStatue;
    var numberOfRepeats = 0;
    final animator = Animator<double>(
      tweenMap: {
        'anim1': Tween<double>(begin: 0, end: 1),
        'anim2': Tween<Offset>(begin: Offset.zero, end: const Offset(10, 10)),
        'anim3': IntTween(begin: 0, end: 10),
      },
      statusListener: (status, anim) {
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
      },
      builder: (_, anim, __) {
        animationValue1 = anim.getValue<double>('anim1');
        animationValue2 = anim.getValue<Offset>('anim2');
        animationValue3 = anim.getValue<int>('anim3');
        animationStatue = anim.getAnimation<double>('anim1').status;
        return Container();
      },
    );

    expect(animationValue1, isNull);
    expect(animationValue2, isNull);
    expect(animationValue3, isNull);
    expect(animationStatue, isNull);

    await tester.pumpWidget(animator);

    expect(animationValue1, equals(0));
    expect(animationValue2, equals(Offset.zero));
    expect(animationValue3, equals(0));
    expect(animationStatue, equals(AnimationStatus.forward));

    await tester.pumpAndSettle();

    expect(animationValue1, equals(1));
    expect(animationValue2, equals(const Offset(10, 10)));
    expect(animationValue3, equals(10));

    expect(animationStatue, equals(AnimationStatus.completed));
    expect(numberOfRepeats, equals(1));
  });

  testWidgets(
      'TweenMap three tweens '
      '(Alignment  and Offset and ColorTween): repeat = 4',
      (WidgetTester tester) async {
    Alignment? animationValue1;
    Offset? animationValue2;
    Color? animationValue3;
    AnimationStatus? animationStatue;
    var numberOfRepeats = 0;
    final animator = Animator<double>(
      tweenMap: {
        'anim1': AlignmentTween(
            begin: Alignment.topRight, end: Alignment.bottomLeft),
        'anim2': Tween<Offset>(begin: Offset.zero, end: const Offset(10, 10)),
        'anim3': ColorTween(begin: Colors.red, end: Colors.blue),
      },
      statusListener: (status, anim) {
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
      },
      repeats: 4,
      builder: (_, anim, __) {
        animationValue1 = anim.getValue('anim1');
        animationValue2 = anim.getValue<Offset>('anim2');
        animationValue3 = anim.getValue('anim3');
        animationStatue = anim.getAnimation<Alignment>('anim1').status;
        return Container();
      },
    );

    expect(animationValue1, isNull);
    expect(animationValue2, isNull);
    expect(animationValue3, isNull);
    expect(animationStatue, isNull);

    await tester.pumpWidget(animator);

    expect(animationValue1, equals(Alignment.topRight));
    expect(animationValue2, equals(Offset.zero));
    expect(animationValue3, equals(Colors.red));
    expect(animationStatue, equals(AnimationStatus.forward));

    await tester.pumpAndSettle();

    expect(animationValue1, equals(Alignment.bottomLeft));
    expect(animationValue2, equals(const Offset(10, 10)));
    expect(animationValue3, equals(Colors.blue));

    expect(animationStatue, equals(AnimationStatus.completed));
    expect(numberOfRepeats, equals(4));
  });

  testWidgets(
      'TweenMap three tweens (Alignment  and Offset and int): cycle = 4',
      (WidgetTester tester) async {
    Alignment? animationValue1;
    Offset? animationValue2;
    Color? animationValue3;
    AnimationStatus? animationStatue;
    var numberOfRepeats = 0;
    final animator = Animator<double>(
      tweenMap: {
        'anim1': AlignmentTween(
            begin: Alignment.topRight, end: Alignment.bottomLeft),
        'anim2': Tween<Offset>(begin: Offset.zero, end: const Offset(10, 10)),
        'anim3': ColorTween(begin: Colors.red, end: Colors.blue),
      },
      statusListener: (status, anim) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          numberOfRepeats++;
        }
      },
      cycles: 4,
      builder: (_, anim, __) {
        animationValue1 = anim.getValue('anim1');
        animationValue2 = anim.getValue<Offset>('anim2');
        animationValue3 = anim.getValue('anim3');
        animationStatue = anim.getAnimation<Alignment>('anim1').status;
        return Container();
      },
    );

    expect(animationValue1, isNull);
    expect(animationValue2, isNull);
    expect(animationValue3, isNull);
    expect(animationStatue, isNull);

    await tester.pumpWidget(animator);

    expect(animationValue1, equals(Alignment.topRight));
    expect(animationValue2, equals(Offset.zero));
    expect(animationValue3, equals(Colors.red));
    expect(animationStatue, equals(AnimationStatus.forward));

    await tester.pumpAndSettle();

    expect(animationValue1, equals(Alignment.topRight));
    expect(animationValue2, equals(const Offset(0, 0)));
    expect(animationValue3, equals(Colors.red));

    expect(animationStatue, equals(AnimationStatus.dismissed));
    expect(numberOfRepeats, equals(4));
  });

  testWidgets(
    'Nested Animator : Two default Animators',
    (WidgetTester tester) async {
      var animValue1 = 0.0;
      var animValue2 = 0.0;
      await tester.pumpWidget(Animator<double>(
        duration: const Duration(seconds: 1),
        builder: (_, anim1, __) {
          return Animator<double>(
            builder: (_, anim2, __) {
              animValue1 = anim1.value;
              animValue2 = anim2.value;
              return Container();
            },
          );
        },
      ));

      await tester.pumpAndSettle();

      expect(animValue1, equals(1));
      expect(animValue2, equals(1));
    },
  );

  testWidgets(
    'Nested Animator : Two Animators with repeats',
    (WidgetTester tester) async {
      var animValue1 = 0.0;
      var animValue2 = 0.0;
      var numberOfRepeats1 = 0;
      var numberOfRepeats2 = 0;
      await tester.pumpWidget(Animator<double>(
        duration: const Duration(seconds: 2),
        statusListener: (status, _) {
          if (status == AnimationStatus.completed) numberOfRepeats1++;
        },
        builder: (_, anim1, __) {
          return Animator<double>(
            repeats: 4,
            statusListener: (status, _) {
              if (status == AnimationStatus.completed) numberOfRepeats2++;
            },
            builder: (_, anim2, __) {
              animValue1 = anim1.value;
              animValue2 = anim2.value;

              return Container();
            },
          );
        },
      ));

      await tester.pumpAndSettle();

      expect(animValue1, equals(1));
      expect(numberOfRepeats1, equals(1));

      expect(animValue2, equals(1));
      expect(numberOfRepeats2, equals(4));
    },
  );

  testWidgets(
    'Nested Animator : online change of animation setup, '
    'resetAnimationOnRebuild = true',
    (WidgetTester tester) async {
      Offset? offset;
      var switcher = true;
      final vm = RM.inject(() => ViewModel());
      await tester.pumpWidget(
        StateBuilder<ViewModel>(
          observe: () => vm,
          builder: (_, __) {
            return Animator<Offset>(
              // tickerMixin: TickerMixin.tickerProviderStateMixin,
              tween: switcher
                  ? Tween<Offset>(begin: Offset.zero, end: const Offset(1, 1))
                  : Tween<Offset>(
                      begin: const Offset(10, 10), end: const Offset(20, 20)),
              duration: const Duration(seconds: 1),
              resetAnimationOnRebuild: true,
              builder: (_, anim, __) {
                offset = anim.value;
                return Animator<double>(
                  repeats: 4,
                  duration: const Duration(seconds: 1),
                  builder: (_, anim2, __) {
                    return Container();
                  },
                );
              },
            );
          },
        ),
      );

      expect(offset, equals(Offset.zero));

      await tester.pumpAndSettle();

      expect(offset, const Offset(1, 1));
      switcher = false;
      vm.notify();
      await tester.pump();
      expect(offset, const Offset(10, 10));

      await tester.pumpAndSettle();
      expect(offset, const Offset(20, 20));
    },
  );

  testWidgets(
      'Nested Animator: TweenMap Two tweens (double and Offset): '
      'auto start and stop ofter 500ms', (WidgetTester tester) async {
    double? animationValue1_1;
    Offset? animationValue2_1;
    double? animationValue1_2;
    Offset? animationValue2_2;
    AnimationStatus? animationStatue_1;
    AnimationStatus? animationStatue_2;
    var numberOfRepeats_1 = 0;
    var numberOfRepeats_2 = 0;

    await tester.pumpWidget(
      Animator<double>(
        tweenMap: {
          'anim1': Tween<double>(begin: 0, end: 1),
          'anim2': Tween<Offset>(begin: Offset.zero, end: const Offset(10, 10)),
        },
        statusListener: (status, anim) {
          if (status == AnimationStatus.completed) {
            numberOfRepeats_1++;
          }
        },
        builder: (_, anim, __) {
          animationValue1_1 = anim.getValue<double>('anim1');
          animationValue2_1 = anim.getValue<Offset>('anim2');
          animationStatue_1 = anim.getAnimation<double>('anim1').status;
          return Animator<double>(
            tweenMap: {
              'anim1': Tween<double>(begin: 0, end: 1),
              'anim2':
                  Tween<Offset>(begin: Offset.zero, end: const Offset(10, 10)),
            },
            statusListener: (status, anim) {
              if (status == AnimationStatus.completed) {
                numberOfRepeats_2++;
              }
            },
            builder: (_, anim, __) {
              animationValue1_2 = anim.getValue<double>('anim1');
              animationValue2_2 = anim.getValue<Offset>('anim2');
              animationStatue_2 = anim.getAnimation<double>('anim1').status;
              return Container();
            },
          );
        },
      ),
    );

    expect(animationValue1_1, equals(0));
    expect(animationValue2_1, equals(Offset.zero));
    expect(animationStatue_1, equals(AnimationStatus.forward));
    expect(animationValue1_2, equals(0));
    expect(animationValue2_2, equals(Offset.zero));
    expect(animationStatue_2, equals(AnimationStatus.forward));

    await tester.pumpAndSettle();

    expect(animationValue1_1, equals(1));
    expect(animationValue2_1, equals(const Offset(10, 10)));
    expect(animationStatue_1, equals(AnimationStatus.completed));
    expect(numberOfRepeats_1, equals(1));

    expect(animationValue1_2, equals(1));
    expect(animationValue2_2, equals(const Offset(10, 10)));
    expect(animationStatue_2, equals(AnimationStatus.completed));
    expect(numberOfRepeats_2, equals(1));
  });

  testWidgets(
      'AnimatorKey with tweenMap'
      'auto start and stop ofter 500ms', (WidgetTester tester) async {
    double? animationValue1;
    Offset? animationValue2;
    AnimationStatus? animationStatue;
    var numberOfRepeats = 0;
    final animatorKey = AnimatorKey<double>();
    final animator = Animator<double>(
      tweenMap: {
        'anim1': Tween<double>(begin: 0, end: 1),
        'anim2': Tween<Offset>(begin: Offset.zero, end: const Offset(10, 10)),
      },
      animatorKey: animatorKey,
      statusListener: (status, anim) {
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
      },
      builder: (_, anim, __) {
        animationValue1 = animatorKey.getValue<double>('anim1');
        animationValue2 = animatorKey.getValue<Offset>('anim2');
        animationStatue = animatorKey.getAnimation<double>('anim1').status;
        return Container();
      },
    );

    expect(animationValue1, isNull);
    expect(animationValue2, isNull);
    expect(animationStatue, isNull);

    await tester.pumpWidget(animator);

    expect(animationValue1, equals(0));
    expect(animationValue2, equals(Offset.zero));
    animatorKey.triggerAnimation();
    await tester.pump();
    expect(animationStatue, equals(AnimationStatus.forward));
    await tester.pumpAndSettle();

    expect(animationValue1, equals(1));
    expect(animationValue2, equals(const Offset(10, 10)));
    expect(animationStatue, equals(AnimationStatus.completed));
    expect(numberOfRepeats, equals(1));
  });
}

class ViewModel {}
