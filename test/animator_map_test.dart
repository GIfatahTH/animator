import 'package:animator/src/states_rebuilder_with_animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:animator/src/animator.dart';

void main() {
  testWidgets("TweenMap default setting : auto start and stop ofter 500ms",
      (WidgetTester tester) async {
    double animationValue;
    AnimationStatus animationStatue;
    int numberOfRepeats = 0;
    final animator = Animator(
      tweenMap: {
        "anim1": Tween<double>(begin: 0, end: 1),
      },
      statusListener: (status, anim) {
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
      },
      builderMap: (anim) {
        animationValue = anim["anim1"].value;
        animationStatue = anim["anim1"].status;
        return Container();
      },
    );

    expect(animationValue, isNull);
    expect(animationStatue, isNull);

    await tester.pumpWidget(animator);

    expect(animationValue, equals(0));
    expect(animationStatue, equals(AnimationStatus.forward));

    await tester.pumpAndSettle();

    expect(animationValue, equals(1));
    expect(animationStatue, equals(AnimationStatus.completed));
    expect(numberOfRepeats, equals(1));
  });

  testWidgets(
      "TweenMap Two tweens (double and Offset): auto start and stop ofter 500ms",
      (WidgetTester tester) async {
    double animationValue1;
    Offset animationValue2;
    AnimationStatus animationStatue;
    int numberOfRepeats = 0;
    final animator = Animator(
      tweenMap: {
        "anim1": Tween<double>(begin: 0, end: 1),
        "anim2": Tween<Offset>(begin: Offset.zero, end: Offset(10, 10)),
      },
      statusListener: (status, anim) {
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
      },
      builderMap: (anim) {
        animationValue1 = anim["anim1"].value;
        animationValue2 = anim["anim2"].value;
        animationStatue = anim["anim1"].status;
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
    expect(animationValue2, equals(Offset(10, 10)));
    expect(animationStatue, equals(AnimationStatus.completed));
    expect(numberOfRepeats, equals(1));
  });

  testWidgets(
      "TweenMap three tweens (double and Offset and int): auto start and stop ofter 500ms",
      (WidgetTester tester) async {
    double animationValue1;
    Offset animationValue2;
    int animationValue3;
    AnimationStatus animationStatue;
    int numberOfRepeats = 0;
    final animator = Animator(
      tweenMap: {
        "anim1": Tween<double>(begin: 0, end: 1),
        "anim2": Tween<Offset>(begin: Offset.zero, end: Offset(10, 10)),
        "anim3": IntTween(begin: 0, end: 10),
      },
      statusListener: (status, anim) {
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
      },
      builderMap: (anim) {
        animationValue1 = anim["anim1"].value;
        animationValue2 = anim["anim2"].value;
        animationValue3 = anim["anim3"].value;
        animationStatue = anim["anim1"].status;
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
    expect(animationValue2, equals(Offset(10, 10)));
    expect(animationValue3, equals(10));

    expect(animationStatue, equals(AnimationStatus.completed));
    expect(numberOfRepeats, equals(1));
  });

  testWidgets(
      "TweenMap three tweens (Alignment  and Offset and ColorTween): repeat = 4",
      (WidgetTester tester) async {
    Alignment animationValue1;
    Offset animationValue2;
    Color animationValue3;
    AnimationStatus animationStatue;
    int numberOfRepeats = 0;
    final animator = Animator(
      tweenMap: {
        "anim1": AlignmentTween(
            begin: Alignment.topRight, end: Alignment.bottomLeft),
        "anim2": Tween<Offset>(begin: Offset.zero, end: Offset(10, 10)),
        "anim3": ColorTween(begin: Colors.red, end: Colors.blue),
      },
      statusListener: (status, anim) {
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
      },
      repeats: 4,
      builderMap: (anim) {
        animationValue1 = anim["anim1"].value;
        animationValue2 = anim["anim2"].value;
        animationValue3 = anim["anim3"].value;
        animationStatue = anim["anim1"].status;
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
    expect(animationValue2, equals(Offset(10, 10)));
    expect(animationValue3, equals(Colors.blue));

    expect(animationStatue, equals(AnimationStatus.completed));
    expect(numberOfRepeats, equals(4));
  });

  testWidgets(
      "TweenMap three tweens (Alignment  and Offset and int): cycle = 4",
      (WidgetTester tester) async {
    Alignment animationValue1;
    Offset animationValue2;
    Color animationValue3;
    AnimationStatus animationStatue;
    int numberOfRepeats = 0;
    final animator = Animator(
      tweenMap: {
        "anim1": AlignmentTween(
            begin: Alignment.topRight, end: Alignment.bottomLeft),
        "anim2": Tween<Offset>(begin: Offset.zero, end: Offset(10, 10)),
        "anim3": ColorTween(begin: Colors.red, end: Colors.blue),
      },
      statusListener: (status, anim) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          numberOfRepeats++;
        }
      },
      cycles: 4,
      builderMap: (anim) {
        animationValue1 = anim["anim1"].value;
        animationValue2 = anim["anim2"].value;
        animationValue3 = anim["anim3"].value;
        animationStatue = anim["anim1"].status;
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
    expect(animationValue2, equals(Offset(0, 0)));
    expect(animationValue3, equals(Colors.red));

    expect(animationStatue, equals(AnimationStatus.dismissed));
    expect(numberOfRepeats, equals(4));
  });

  testWidgets(
    "Nested Animator : Two default Animators",
    (WidgetTester tester) async {
      double animValue1 = 0;
      double animValue2 = 0;
      await tester.pumpWidget(Animator(
        duration: Duration(seconds: 1),
        builder: (anim1) {
          return Animator(
            builder: (anim2) {
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
    "Nested Animator : Two Animators with repeats",
    (WidgetTester tester) async {
      double animValue1 = 0;
      double animValue2 = 0;
      int numberOfRepeats1 = 0;
      int numberOfRepeats2 = 0;
      await tester.pumpWidget(Animator(
        duration: Duration(seconds: 2),
        statusListener: (status, _) {
          if (status == AnimationStatus.completed) numberOfRepeats1++;
        },
        builder: (anim1) {
          return Animator(
            repeats: 4,
            statusListener: (status, _) {
              if (status == AnimationStatus.completed) numberOfRepeats2++;
            },
            builder: (anim2) {
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
    "Nested Animator : online change of animation setup, resetAnimationOnRebuild = true",
    (WidgetTester tester) async {
      Offset offset;
      bool switcher = true;
      final vm = ViewModel();
      await tester.pumpWidget(
        StateBuilder(
          models: [vm],
          builder: (_, __) {
            return Animator(
              tickerMixin: TickerMixin.tickerProviderStateMixin,
              tween: switcher
                  ? Tween<Offset>(begin: Offset.zero, end: Offset(1, 1))
                  : Tween<Offset>(begin: Offset(10, 10), end: Offset(20, 20)),
              duration: Duration(seconds: 1),
              resetAnimationOnRebuild: true,
              builder: (anim) {
                offset = anim.value;
                return Animator(
                  repeats: 4,
                  duration: Duration(seconds: 1),
                  statusListener: (status, _) {
                    // if (status == AnimationStatus.completed) ;numberOfRepeats2++;
                  },
                  builder: (anim2) {
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

      expect(offset, Offset(1, 1));
      switcher = false;
      vm.rebuildStates();
      await tester.pump();
      expect(offset, Offset(10, 10));

      await tester.pumpAndSettle();
      expect(offset, Offset(20, 20));
    },
  );

  testWidgets(
      "Nested Animator: TweenMap Two tweens (double and Offset): auto start and stop ofter 500ms",
      (WidgetTester tester) async {
    double animationValue1_1;
    Offset animationValue2_1;
    double animationValue1_2;
    Offset animationValue2_2;
    AnimationStatus animationStatue_1;
    AnimationStatus animationStatue_2;
    int numberOfRepeats_1 = 0;
    int numberOfRepeats_2 = 0;

    await tester.pumpWidget(
      Animator(
        tweenMap: {
          "anim1": Tween<double>(begin: 0, end: 1),
          "anim2": Tween<Offset>(begin: Offset.zero, end: Offset(10, 10)),
        },
        statusListener: (status, anim) {
          if (status == AnimationStatus.completed) {
            numberOfRepeats_1++;
          }
        },
        builderMap: (anim) {
          animationValue1_1 = anim["anim1"].value;
          animationValue2_1 = anim["anim2"].value;
          animationStatue_1 = anim["anim1"].status;
          return Animator(
            tweenMap: {
              "anim1": Tween<double>(begin: 0, end: 1),
              "anim2": Tween<Offset>(begin: Offset.zero, end: Offset(10, 10)),
            },
            statusListener: (status, anim) {
              if (status == AnimationStatus.completed) {
                numberOfRepeats_2++;
              }
            },
            builderMap: (anim) {
              animationValue1_2 = anim["anim1"].value;
              animationValue2_2 = anim["anim2"].value;
              animationStatue_2 = anim["anim1"].status;
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
    expect(animationValue2_1, equals(Offset(10, 10)));
    expect(animationStatue_1, equals(AnimationStatus.completed));
    expect(numberOfRepeats_1, equals(1));

    expect(animationValue1_2, equals(1));
    expect(animationValue2_2, equals(Offset(10, 10)));
    expect(animationStatue_2, equals(AnimationStatus.completed));
    expect(numberOfRepeats_2, equals(1));
  });

  testWidgets(
    "default explicit like with tweenMap animation is initialized and started",
    (WidgetTester tester) async {
      final vm = ViewModel1();

      expect(vm.animation, isNull);

      await tester.pumpWidget(
        StateWithMixinBuilder<TickerProvider>(
            mixinWith: MixinWith.tickerProviderStateMixin,
            initState: (_, ticker) => vm.init(ticker),
            dispose: (_, ticker) => vm.disposeAnim(),
            models: [vm],
            builder: (_, __) {
              return Container();
            }),
      );
      expect(vm.value, equals(0));
      expect(vm.animation.status, equals(AnimationStatus.dismissed));

      vm.triggerAnimation();
      await tester.pumpAndSettle();

      expect(vm.value, equals(1));
      expect(vm.animation.status, equals(AnimationStatus.completed));
    },
  );

  testWidgets(
    "default explicit like with tweenMap animation , changing tweenMap",
    (WidgetTester tester) async {
      final vm = ViewModel1();

      expect(vm.animation, isNull);

      await tester.pumpWidget(
        StateWithMixinBuilder<TickerProvider>(
            mixinWith: MixinWith.tickerProviderStateMixin,
            initState: (_, ticker) => vm.init(ticker),
            dispose: (_, ticker) => vm.disposeAnim(),
            models: [vm],
            builder: (_, __) {
              return Container();
            }),
      );
      expect(vm.value, equals(0));
      expect(vm.animation.status, equals(AnimationStatus.dismissed));

      vm.triggerAnimation();
      await tester.pumpAndSettle();

      expect(vm.value, equals(1));
      expect(vm.animation.status, equals(AnimationStatus.completed));
      expect(vm.animationMap["anim1"].toString(),
          contains("Tween<double>(1.0 → 2.0)"));

      vm.animator.tweenMap = {"anim1": Tween<double>(begin: 10, end: 20)};
      vm.triggerAnimation();
      await tester.pumpAndSettle();
      expect(vm.animationMap["anim1"].toString(),
          contains("Tween<double>(10.0 → 20.0)"));

      vm.animator.tweenMap = {
        "anim1": Tween<double>(begin: 10, end: 20),
        "anim2": Tween<double>(begin: 20, end: 30)
      };
      vm.triggerAnimation();
      await tester.pumpAndSettle();
      expect(vm.animationMap["anim1"].toString(),
          contains("Tween<double>(10.0 → 20.0)"));
      expect(vm.animationMap["anim2"].toString(),
          contains("Tween<double>(20.0 → 30.0)"));

      vm.animator.tweenMap = {"anim2": Tween<double>(begin: 20, end: 30)};
      vm.triggerAnimation();
      await tester.pumpAndSettle();
      expect(vm.animationMap["anim1"], isNull);
      expect(vm.animationMap["anim2"].toString(),
          contains("Tween<double>(20.0 → 30.0)"));
    },
  );
  testWidgets(
    "explicit like with tweenMap animation , repeat 4",
    (WidgetTester tester) async {
      final vm = ViewModel1();
      int numberOfRepeats = 0;
      expect(vm.animation, isNull);

      await tester.pumpWidget(
        StateWithMixinBuilder<TickerProvider>(
            mixinWith: MixinWith.tickerProviderStateMixin,
            initState: (_, ticker) => vm.init(ticker),
            dispose: (_, ticker) => vm.disposeAnim(),
            models: [vm],
            builder: (_, __) {
              return Container();
            }),
      );

      vm.addAnimationStatusListener((status) {
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
      });
      vm.animator.repeats = 4;

      expect(vm.value, equals(0));
      expect(vm.animation.status, equals(AnimationStatus.dismissed));
      expect(numberOfRepeats, equals(0));

      vm.triggerAnimation();
      await tester.pumpAndSettle();

      expect(vm.value, equals(1));
      expect(vm.animation.status, equals(AnimationStatus.completed));
      expect(numberOfRepeats, equals(4));

      vm.triggerAnimation();
      await tester.pumpAndSettle();

      expect(vm.value, equals(1));
      expect(vm.animation.status, equals(AnimationStatus.completed));
      expect(numberOfRepeats, equals(8));
    },
  );

  testWidgets(
    "explicit like with tweenMap animation , changing repeats 0 to 2 to 5",
    (WidgetTester tester) async {
      final vm = ViewModel1();
      int numberOfRepeats = 0;
      expect(vm.animation, isNull);

      await tester.pumpWidget(
        StateWithMixinBuilder<TickerProvider>(
            mixinWith: MixinWith.tickerProviderStateMixin,
            initState: (_, ticker) => vm.init(ticker),
            dispose: (_, ticker) => vm.disposeAnim(),
            models: [vm],
            builder: (_, __) {
              return Container();
            }),
      );

      vm.addAnimationStatusListener((status) {
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
      });

      expect(vm.value, equals(0));
      expect(vm.animation.status, equals(AnimationStatus.dismissed));
      expect(numberOfRepeats, equals(0));

      vm.triggerAnimation();
      await tester.pumpAndSettle();

      expect(vm.value, equals(1));
      expect(vm.animation.status, equals(AnimationStatus.completed));
      expect(numberOfRepeats, equals(1));

      numberOfRepeats = 0;
      vm.animator.repeats = 2;
      vm.triggerAnimation();
      await tester.pumpAndSettle();

      expect(vm.value, equals(1));
      expect(vm.animation.status, equals(AnimationStatus.completed));
      expect(numberOfRepeats, equals(2));

      numberOfRepeats = 0;
      vm.animator.repeats = 5;
      vm.triggerAnimation();
      await tester.pumpAndSettle();

      expect(vm.value, equals(1));
      expect(vm.animation.status, equals(AnimationStatus.completed));
      expect(numberOfRepeats, equals(5));
    },
  );

  testWidgets(
    "explicit like with tweenMap animation , changing cycle 0 to 2 to 5",
    (WidgetTester tester) async {
      final vm = ViewModel1();
      int numberOfCycles = 0;
      expect(vm.animation, isNull);

      await tester.pumpWidget(
        StateWithMixinBuilder<TickerProvider>(
            mixinWith: MixinWith.tickerProviderStateMixin,
            initState: (_, ticker) => vm.init(ticker),
            dispose: (_, ticker) => vm.disposeAnim(),
            models: [vm],
            builder: (_, __) {
              return Container();
            }),
      );

      vm.addAnimationStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          numberOfCycles++;
        }
      });

      expect(vm.value, equals(0));
      expect(vm.animation.status, equals(AnimationStatus.dismissed));
      expect(numberOfCycles, equals(0));

      vm.triggerAnimation();
      await tester.pumpAndSettle();

      expect(vm.value, equals(1));
      expect(vm.animation.status, equals(AnimationStatus.completed));
      expect(numberOfCycles, equals(1));

      numberOfCycles = 0;
      vm.animator.cycles = 2;
      vm.triggerAnimation();
      await tester.pumpAndSettle();

      expect(vm.value, equals(1));
      expect(vm.animation.status, equals(AnimationStatus.completed));
      expect(numberOfCycles, equals(2));

      numberOfCycles = 0;
      vm.animator.cycles = 4;
      vm.triggerAnimation();
      await tester.pumpAndSettle();

      expect(vm.value, equals(1));
      expect(vm.animation.status, equals(AnimationStatus.completed));
      expect(numberOfCycles, equals(4));

      numberOfCycles = 0;
      vm.animator.cycles = 6;
      vm.triggerAnimation(reset: true);
      await tester.pumpAndSettle();

      expect(vm.value, equals(0));
      expect(vm.animation.status, equals(AnimationStatus.dismissed));
      expect(
          numberOfCycles, equals(7)); //TODO: 6 cycles + 1 for dismissed reset
    },
  );

  testWidgets(
    "explicit like with tweenMap animation , changing duration",
    (WidgetTester tester) async {
      final vm = ViewModel1();

      expect(vm.animation, isNull);

      await tester.pumpWidget(
        StateWithMixinBuilder<TickerProvider>(
            mixinWith: MixinWith.tickerProviderStateMixin,
            initState: (_, ticker) => vm.init(ticker),
            dispose: (_, ticker) => vm.disposeAnim(),
            models: [vm],
            builder: (_, __) {
              return Container();
            }),
      );
      vm.animator.duration = Duration(milliseconds: 600);
      expect(vm.value, equals(0));
      expect(vm.animation.status, equals(AnimationStatus.dismissed));
      expect(vm.controller.duration, equals(Duration(milliseconds: 600)));

      vm.triggerAnimation();
      await tester.pumpAndSettle();

      vm.animator.duration = Duration(seconds: 1);
      expect(vm.value, equals(0));
      expect(vm.animation.status, equals(AnimationStatus.dismissed));
      expect(vm.controller.duration, equals(Duration(seconds: 1)));

      vm.triggerAnimation();
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    "explicit like with tweenMap animation , changing curve",
    (WidgetTester tester) async {
      final vm = ViewModel1();

      expect(vm.animation, isNull);

      await tester.pumpWidget(
        StateWithMixinBuilder<TickerProvider>(
            mixinWith: MixinWith.tickerProviderStateMixin,
            initState: (_, ticker) => vm.init(ticker),
            dispose: (_, ticker) => vm.disposeAnim(),
            models: [vm],
            builder: (_, __) {
              return Container();
            }),
      );

      expect(vm.value, equals(0));
      expect(vm.animation.status, equals(AnimationStatus.dismissed));
      expect(vm.animation.toString(), contains("Linear"));

      vm.triggerAnimation();
      await tester.pumpAndSettle();

      expect(vm.value, equals(1));
      expect(vm.animation.status, equals(AnimationStatus.completed));
      expect(vm.animation.toString(), contains("Linear"));

      vm.animator.curve = Curves.bounceIn;

      vm.triggerAnimation();
      await tester.pumpAndSettle();

      expect(vm.value, equals(1));
      expect(vm.animation.status, equals(AnimationStatus.completed));
      expect(vm.animation.toString(), contains("BounceIn"));
    },
  );
}

class ViewModel extends StatesRebuilder {
  startAnimation() {
    rebuildStates();
  }
}

class ViewModel1 extends StatesRebuilderWithAnimator<double> {
  double get value => animation.value;
  init(TickerProvider ticker) {
    animator.tweenMap = {"anim1": Tween<double>(begin: 1, end: 2)};
    initAnimation(ticker);

    addAnimationListener(() {
      rebuildStates();
    });
  }
}
