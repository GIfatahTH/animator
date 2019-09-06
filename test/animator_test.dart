import 'package:animator/src/animation_parameters.dart';
import 'package:animator/src/animator.dart';
import 'package:animator/src/states_rebuilder_with_animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

void main() {
  test("should throw error if both builder or builderMap are not provided", () {
    expect(() {
      Animator(
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(seconds: 1),
        curve: Curves.linear,
      );
    }, throwsException);
  });

  test("should instantiate animation Controller and animation objects", () {
    final animator = Animator(
      triggerOnInit: false,
      builder: (anim) => null,
    );
    var animatorBloc;
    animatorBloc = StatesRebuilderWithAnimator(
        AnimationParameters(animatorBloc)..setAnimationParameters(animator));

    expect(animatorBloc.controller, isNull);
    expect(animatorBloc.animation, isNull);

    animatorBloc.initAnimation(_Ticker());

    expect(animatorBloc.controller, isNot(isNull));
    expect(animatorBloc.animation, isNot(isNull));
  });

  testWidgets(
      "should initialize animation without starting it (triggerOnInit = false)",
      (WidgetTester tester) async {
    double animationValue;
    AnimationStatus animationStatue;

    final animator = Animator(
      triggerOnInit: false,
      builder: (anim) {
        animationValue = anim.value;
        animationStatue = anim.status;
        return Container();
      },
    );

    expect(animationValue, isNull);
    expect(animationStatue, isNull);

    await tester.pumpWidget(animator);

    expect(animationValue, equals(0));
    expect(animationStatue, equals(AnimationStatus.dismissed));

    await tester.pumpAndSettle(Duration(seconds: 1));
    expect(animationValue, equals(0));
    expect(animationStatue, equals(AnimationStatus.dismissed));
  });

  testWidgets(
      "should auto-starts (triggerOnInit = true) and ends after 1 seconds (repeat=1)",
      (WidgetTester tester) async {
    double animationValue;
    AnimationStatus animationStatue;
    int numberOfRepeats = 0;
    final animator = Animator(
      duration: Duration(seconds: 1),
      statusListener: (status, anim) {
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
      },
      builder: (anim) {
        animationValue = anim.value;
        animationStatue = anim.status;
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
      "should auto-starts (triggerOnInit = true) and ends after 500ms (repeat=1) : Tween<int>",
      (WidgetTester tester) async {
    int animationValue;
    AnimationStatus animationStatue;
    int numberOfRepeats = 0;
    final animator = Animator<int>(
      tween: IntTween(begin: 0, end: 10), // use IntTween instead of Tween<int>
      statusListener: (status, anim) {
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
      },
      builder: (anim) {
        animationValue = anim.value;
        animationStatue = anim.status;
        return Container();
      },
    );

    expect(animationValue, isNull);
    expect(animationStatue, isNull);

    await tester.pumpWidget(animator);

    expect(animationValue, equals(0));
    expect(animationStatue, equals(AnimationStatus.forward));

    await tester.pumpAndSettle();

    expect(animationValue, equals(10));
    expect(animationStatue, equals(AnimationStatus.completed));
    expect(numberOfRepeats, equals(1));
  });

  testWidgets("should auto-starts (triggerOnInit = true) and repeat 2 times",
      (WidgetTester tester) async {
    double animationValue;
    AnimationStatus animationStatue;
    int numberOfRepeats = 0;
    final animator = Animator(
      duration: Duration(seconds: 1),
      repeats: 2,
      statusListener: (status, anim) {
        animationStatue = status;
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
      },
      builder: (anim) {
        animationValue = anim.value;
        return Container();
      },
    );

    await tester.pumpWidget(animator);

    expect(animationValue, equals(0));

    await tester.pumpAndSettle();
    expect(animationValue, equals(1));
    expect(animationStatue, equals(AnimationStatus.completed));
    expect(numberOfRepeats, equals(2));
  });

  testWidgets("should auto-starts (triggerOnInit = true) and cycle 2 times",
      (WidgetTester tester) async {
    double animationValue;
    AnimationStatus animationStatue;
    int numberOfRepeats = 0;
    final animator = Animator(
      duration: Duration(seconds: 1),
      cycles: 2,
      statusListener: (status, anim) {
        animationStatue = status;
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
        if (status == AnimationStatus.dismissed) {
          numberOfRepeats++;
        }
      },
      builder: (anim) {
        animationValue = anim.value;
        return Container();
      },
    );

    await tester.pumpWidget(animator);

    expect(animationValue, equals(0));

    await tester.pumpAndSettle();

    expect(animationValue, equals(0));
    expect(animationStatue, equals(AnimationStatus.dismissed));
    expect(numberOfRepeats, equals(2));
  });

  testWidgets("should auto-starts (triggerOnInit = true) and repeat 5 times",
      (WidgetTester tester) async {
    double animationValue;
    AnimationStatus animationStatue;
    int numberOfRepeats = 0;
    int animationIsEndedNumber = 0;

    final animator = Animator(
      duration: Duration(seconds: 1),
      repeats: 5,
      statusListener: (status, anim) {
        animationStatue = status;
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
      },
      endAnimationListener: (anim) {
        animationIsEndedNumber++;
      },
      builder: (anim) {
        animationValue = anim.value;
        return Container();
      },
    );

    await tester.pumpWidget(animator);

    expect(animationValue, equals(0));

    await tester.pumpAndSettle();

    expect(animationValue, equals(1));
    expect(animationStatue, equals(AnimationStatus.completed));
    expect(numberOfRepeats, equals(5));
    expect(animationIsEndedNumber, equals(1));
  });

  testWidgets("should auto-starts (triggerOnInit = true) and cycle 5 times",
      (WidgetTester tester) async {
    double animationValue;
    AnimationStatus animationStatue;
    int numberOfRepeats = 0;
    int animationIsEndedNumber = 0;
    final animator = Animator(
      duration: Duration(seconds: 1),
      cycles: 5,
      statusListener: (status, anim) {
        animationStatue = status;
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
        if (status == AnimationStatus.dismissed) {
          numberOfRepeats++;
        }
      },
      endAnimationListener: (anim) {
        animationIsEndedNumber++;
      },
      builder: (anim) {
        animationValue = anim.value;
        return Container();
      },
    );

    await tester.pumpWidget(animator);

    expect(animationValue, equals(0));

    await tester.pumpAndSettle();

    expect(animationValue, equals(1));
    expect(animationStatue, equals(AnimationStatus.completed));
    expect(numberOfRepeats, equals(5));
    expect(animationIsEndedNumber, equals(1));
  });

  // testWidgets("should  repeats 0 throw time out error",
  //     (WidgetTester tester) async {
  //   final animator = Animator(
  //     tween: Tween<double>(begin: 0, end: 1),
  //     duration: Duration(seconds: 1),
  //     curve: Curves.linear,
  //     triggerOnInit: true,
  //     repeats: 0,
  //     builder: (anim) {
  //       print(anim.value);
  //       return Container();
  //     },
  //   );
  //   await tester.pumpWidget(animator);
  //   await tester.pumpAndSettle();
  // });

  // testWidgets("should  cycle 0 throw time out error",
  //     (WidgetTester tester) async {
  //   final animator = Animator(
  //     tween: Tween<double>(begin: 0, end: 1),
  //     duration: Duration(seconds: 1),
  //     curve: Curves.linear,
  //     triggerOnInit: true,
  //     cycles: 0,
  //     builder: (anim) {
  //       print(anim.value);
  //       return Container();
  //     },
  //   );
  //   await tester.pumpWidget(animator);
  //   await tester.pumpAndSettle();
  // });

  testWidgets("should customListener be called each frame",
      (WidgetTester tester) async {
    double animationValue;
    AnimationStatus animationStatue;
    int numberOfRepeats = 0;
    double customAnimationValue;

    final animator = Animator(
      duration: Duration(seconds: 1),
      cycles: 1,
      customListener: (anim) {
        customAnimationValue = anim.animation.value;
      },
      statusListener: (status, anim) {
        animationStatue = status;
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
        if (status == AnimationStatus.dismissed) {
          numberOfRepeats++;
        }
      },
      builder: (anim) {
        animationValue = anim.value;
        return Container();
      },
    );

    await tester.pumpWidget(animator);

    expect(animationValue, equals(0));

    await tester.pumpAndSettle();

    expect(animationValue, equals(1));
    expect(animationStatue, equals(AnimationStatus.completed));
    expect(numberOfRepeats, equals(1));
    expect(customAnimationValue == animationValue, isTrue);
  });

  testWidgets("should not auto-Start because blocs are defined",
      (WidgetTester tester) async {
    double animationValue;
    AnimationStatus animationStatue;
    int numberOfRepeats = 0;
    final vm = ViewModel();
    final animator = Animator(
      duration: Duration(seconds: 1),
      blocs: [vm],
      statusListener: (status, anim) {
        animationStatue = status;
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
        if (status == AnimationStatus.dismissed) {
          numberOfRepeats++;
        }
      },
      builder: (anim) {
        animationValue = anim.value;
        return Container();
      },
    );

    await tester.pumpWidget(animator);

    expect(animationValue, equals(0));

    await tester.pumpAndSettle();

    expect(animationValue, equals(0));
    expect(animationStatue, isNull);
    expect(numberOfRepeats, equals(0));
  });

  testWidgets(
      "should  auto-Start because triggerOnInit is true although  blocs are defined",
      (WidgetTester tester) async {
    double animationValue;
    AnimationStatus animationStatue;
    int numberOfRepeats = 0;
    final vm = ViewModel();
    final animator = Animator(
      duration: Duration(seconds: 1),
      blocs: [vm],
      triggerOnInit: true,
      statusListener: (status, anim) {
        animationStatue = status;
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
        if (status == AnimationStatus.dismissed) {
          numberOfRepeats++;
        }
      },
      builder: (anim) {
        animationValue = anim.value;
        return Container();
      },
    );

    await tester.pumpWidget(animator);

    expect(animationValue, equals(0));

    await tester.pumpAndSettle();

    expect(animationValue, equals(1));
    expect(animationStatue, equals(AnimationStatus.completed));
    expect(numberOfRepeats, equals(1));
  });

  testWidgets(
    "should not auto-Start, it will be triggered from the viewModel class",
    (WidgetTester tester) async {
      double animationValue;
      AnimationStatus animationStatue;
      int numberOfRepeats = 0;
      final vm = ViewModel();
      final animator = Animator(
        duration: Duration(seconds: 1),
        blocs: [vm],
        statusListener: (status, anim) {
          animationStatue = status;
          if (status == AnimationStatus.completed) {
            numberOfRepeats++;
          }
        },
        builder: (anim) {
          animationValue = anim.value;
          return Container();
        },
      );

      await tester.pumpWidget(animator);

      expect(animationValue, equals(0));

      await tester.pumpAndSettle();

      expect(animationValue, equals(0));
      expect(animationStatue, null);
      expect(numberOfRepeats, equals(0));

      vm.startAnimation();

      await tester.pumpAndSettle();

      expect(animationValue, equals(1));
      expect(animationStatue, equals(AnimationStatus.completed));
      expect(numberOfRepeats, equals(1));

      vm.startAnimation();
      await tester.pumpAndSettle();

      expect(animationValue, equals(1));
      expect(animationStatue, equals(AnimationStatus.completed));
      expect(numberOfRepeats, equals(2));
    },
  );

  testWidgets(
    "should not auto-Start, it will be triggered from the viewModel class (4 repeats)",
    (WidgetTester tester) async {
      double animationValue;
      AnimationStatus animationStatue;
      int numberOfRepeats = 0;
      final vm = ViewModel();
      final animator = Animator(
        duration: Duration(seconds: 1),
        blocs: [vm],
        repeats: 4,
        statusListener: (status, anim) {
          animationStatue = status;
          if (status == AnimationStatus.completed) {
            numberOfRepeats++;
          }
        },
        builder: (anim) {
          animationValue = anim.value;
          return Container();
        },
      );

      await tester.pumpWidget(animator);

      expect(animationValue, equals(0));

      await tester.pumpAndSettle();

      expect(animationValue, equals(0));
      expect(animationStatue, null);
      expect(numberOfRepeats, equals(0));

      vm.startAnimation();

      await tester.pumpAndSettle();

      expect(animationValue, equals(1));
      expect(animationStatue, equals(AnimationStatus.completed));
      expect(numberOfRepeats, equals(4));

      vm.startAnimation();
      await tester.pumpAndSettle();

      expect(animationValue, equals(1));
      expect(animationStatue, equals(AnimationStatus.completed));
      expect(numberOfRepeats, equals(8));
    },
  );

  testWidgets(
    "should not auto-Start, it will be triggered from the viewModel class (1 cycle)",
    (WidgetTester tester) async {
      double animationValue;
      AnimationStatus animationStatue;
      int numberOfRepeats = 0;
      final vm = ViewModel();
      final animator = Animator(
        duration: Duration(seconds: 1),
        blocs: [vm],
        cycles: 1,
        statusListener: (status, anim) {
          animationStatue = status;
          if (status == AnimationStatus.completed) {
            numberOfRepeats++;
          }
          if (status == AnimationStatus.dismissed) {
            numberOfRepeats++;
          }
        },
        builder: (anim) {
          animationValue = anim.value;
          return Container();
        },
      );

      await tester.pumpWidget(animator);

      expect(animationValue, equals(0));

      await tester.pumpAndSettle();

      expect(animationValue, equals(0));
      expect(animationStatue, null);
      expect(numberOfRepeats, equals(0));

      vm.startAnimation();

      await tester.pumpAndSettle();

      expect(animationValue, equals(1));
      expect(animationStatue, equals(AnimationStatus.completed));
      expect(numberOfRepeats, equals(1));

      vm.startAnimation();
      await tester.pumpAndSettle();

      expect(animationValue, equals(0));
      expect(animationStatue, equals(AnimationStatus.dismissed));
      expect(numberOfRepeats, equals(2));

      vm.startAnimation();
      await tester.pumpAndSettle();

      expect(animationValue, equals(1));
      expect(animationStatue, equals(AnimationStatus.completed));
      expect(numberOfRepeats, equals(3));
    },
  );

  testWidgets(
    "should not auto-Start, it will be triggered from the viewModel class (4 cycle)",
    (WidgetTester tester) async {
      double animationValue;
      AnimationStatus animationStatue;
      int numberOfRepeats = 0;
      final vm = ViewModel();
      final animator = Animator(
        duration: Duration(seconds: 1),
        blocs: [vm],
        cycles: 4,
        statusListener: (status, anim) {
          animationStatue = status;
          if (status == AnimationStatus.completed) {
            numberOfRepeats++;
          }
          if (status == AnimationStatus.dismissed) {
            numberOfRepeats++;
          }
        },
        builder: (anim) {
          animationValue = anim.value;
          return Container();
        },
      );

      await tester.pumpWidget(animator);

      expect(animationValue, equals(0));

      await tester.pumpAndSettle();

      expect(animationValue, equals(0));
      expect(animationStatue, null);
      expect(numberOfRepeats, equals(0));

      vm.startAnimation();

      await tester.pumpAndSettle();

      expect(animationValue, equals(0));
      expect(animationStatue, equals(AnimationStatus.dismissed));
      expect(numberOfRepeats, equals(4));

      vm.startAnimation();
      await tester.pumpAndSettle();

      expect(animationValue, equals(0));
      expect(animationStatue, equals(AnimationStatus.dismissed));
      expect(numberOfRepeats, equals(8));

      vm.startAnimation();
      await tester.pumpAndSettle();

      expect(animationValue, equals(0));
      expect(animationStatue, equals(AnimationStatus.dismissed));
      expect(numberOfRepeats, equals(12));
    },
  );

  testWidgets(
    "should ColorTween tween work",
    (WidgetTester tester) async {
      Color color;
      final animator = Animator(
        tween: ColorTween(begin: Colors.red, end: Colors.blue),
        builder: (anim) {
          color = anim.value;
          return Container();
        },
      );

      await tester.pumpWidget(animator);

      expect(color, equals(Colors.red));

      await tester.pumpAndSettle();

      expect(color, equals(Colors.blue));
    },
  );

  testWidgets(
    "online change of animation setup, resetAnimationOnRebuild = true",
    (WidgetTester tester) async {
      Offset offset;
      bool switcher = true;
      final vm = ViewModel();

      await tester.pumpWidget(
        StateBuilder(
          viewModels: [vm],
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
                return Container();
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
    "animation setup should not change resetAnimationOnRebuild = false",
    (WidgetTester tester) async {
      Offset offset;
      bool switcher = true;
      final vm = ViewModel();

      await tester.pumpWidget(
        StateBuilder(
          viewModels: [vm],
          builder: (_, __) {
            return Animator(
              tween: switcher
                  ? Tween<Offset>(begin: Offset.zero, end: Offset(1, 1))
                  : Tween<Offset>(begin: Offset(10, 10), end: Offset(20, 20)),
              duration: Duration(seconds: 1),
              builder: (anim) {
                offset = anim.value;
                return Container();
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
      expect(offset, Offset(1, 1));

      await tester.pumpAndSettle();
      expect(offset, Offset(1, 1));
    },
  );

  testWidgets(
    "animation should not start resetAnimationOnRebuild = false",
    (WidgetTester tester) async {
      Offset offset;
      bool switcher = true;
      final vm = ViewModel();

      await tester.pumpWidget(
        StateBuilder(
          viewModels: [vm],
          builder: (_, __) {
            return Animator<Offset>(
              tickerMixin: TickerMixin.tickerProviderStateMixin,
              tween: switcher
                  ? Tween<Offset>(begin: Offset.zero, end: Offset(1, 1))
                  : Tween<Offset>(begin: Offset(10, 10), end: Offset(20, 20)),
              duration: Duration(seconds: 1),
              resetAnimationOnRebuild: true,
              triggerOnInit: false,
              builder: (anim) {
                offset = anim.value;
                return Container();
              },
            );
          },
        ),
      );

      expect(offset, equals(Offset.zero));

      await tester.pumpAndSettle();

      expect(offset, Offset(0, 0));

      switcher = false;
      vm.rebuildStates();
      await tester.pump();
      expect(offset, Offset(10, 10));

      await tester.pumpAndSettle();
      expect(offset, Offset(10, 10));
    },
  );

  testWidgets(
    "default explicit like animation is initialized but not started",
    (WidgetTester tester) async {
      final vm = ViewModel1();

      expect(vm.animation, isNull);

      await tester.pumpWidget(
        StateWithMixinBuilder<TickerProvider>(
            mixinWith: MixinWith.tickerProviderStateMixin,
            initState: (_, __, ticker) => vm.init(ticker),
            dispose: (_, __, ticker) => vm.dispose(),
            viewModels: [vm],
            builder: (_, __) {
              return Container();
            }),
      );
      expect(vm.value, equals(0));
      expect(vm.animation.status, equals(AnimationStatus.dismissed));

      await tester.pumpAndSettle();

      expect(vm.value, equals(0));
      expect(vm.animation.status, equals(AnimationStatus.dismissed));
    },
  );

  testWidgets(
    "default explicit like animation is initialized and started",
    (WidgetTester tester) async {
      final vm = ViewModel1();

      expect(vm.animation, isNull);

      await tester.pumpWidget(
        StateWithMixinBuilder<TickerProvider>(
            mixinWith: MixinWith.tickerProviderStateMixin,
            initState: (_, __, ticker) => vm.init(ticker),
            dispose: (_, __, ticker) => vm.dispose(),
            viewModels: [vm],
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
    "default explicit like animation (set repeat to 2 then to 5)",
    (WidgetTester tester) async {
      final vm = ViewModel1();
      int numberOfRepeats = 0;
      AnimationStatus _status;

      expect(vm.animation, isNull);

      await tester.pumpWidget(
        StateWithMixinBuilder<TickerProvider>(
            mixinWith: MixinWith.tickerProviderStateMixin,
            initState: (_, __, ticker) => vm.init(ticker),
            dispose: (_, __, ticker) => vm.dispose(),
            viewModels: [vm],
            builder: (_, __) {
              return Container();
            }),
      );

      vm.addAnimationStatusListener((status) {
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
        _status = status;
      });

      expect(vm.value, equals(0));
      expect(numberOfRepeats, equals(0));
      expect(_status, null);
      vm.animator.repeats = 2;
      vm.triggerAnimation();
      await tester.pumpAndSettle();

      expect(vm.value, equals(1));
      expect(numberOfRepeats, equals(2));
      expect(_status, equals(AnimationStatus.completed));

      numberOfRepeats = 0;
      vm.animator.repeats = 5;

      vm.triggerAnimation();
      await tester.pumpAndSettle();

      expect(vm.value, equals(1));
      expect(numberOfRepeats, equals(5));
      expect(_status, equals(AnimationStatus.completed));
    },
  );

  testWidgets(
    "default implicit like animation (set cycles to 1, 2 then to 5)",
    (WidgetTester tester) async {
      final vm = ViewModel1();
      int numberOfRepeats = 0;
      AnimationStatus _status;

      expect(vm.animation, isNull);

      await tester.pumpWidget(
        StateWithMixinBuilder<TickerProvider>(
            mixinWith: MixinWith.tickerProviderStateMixin,
            initState: (_, __, ticker) => vm.init(ticker),
            dispose: (_, __, ticker) => vm.dispose(),
            viewModels: [vm],
            builder: (_, __) {
              return Container();
            }),
      );

      vm.addAnimationStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          numberOfRepeats++;
        }
        _status = status;
      });

      expect(vm.value, equals(0));
      expect(numberOfRepeats, equals(0));
      expect(_status, null);
      vm.animator.cycles = 1;
      vm.triggerAnimation();
      await tester.pumpAndSettle();

      expect(vm.value, equals(1));
      expect(numberOfRepeats, equals(1));
      expect(_status, equals(AnimationStatus.completed));

      vm.animator.cycles = 2;
      vm.triggerAnimation(reset: true);
      numberOfRepeats = 0;
      await tester.pumpAndSettle();

      expect(vm.value, equals(0));
      expect(numberOfRepeats, equals(2));
      expect(_status, equals(AnimationStatus.dismissed));

      numberOfRepeats = 0;
      vm.animator.cycles = (5);
      vm.triggerAnimation();
      await tester.pumpAndSettle();

      expect(vm.value, equals(1));
      expect(numberOfRepeats, equals(5));
      expect(_status, equals(AnimationStatus.completed));
    },
  );

  testWidgets(
    "default implicit like animation (endAnimationListener)",
    (WidgetTester tester) async {
      final vm = ViewModel1();
      // int numberOfRepeats = 0;
      // AnimationStatus _status;
      // int endAnimationCount = 0;

      expect(vm.animation, isNull);

      await tester.pumpWidget(
        StateWithMixinBuilder<TickerProvider>(
            mixinWith: MixinWith.tickerProviderStateMixin,
            initState: (_, __, ticker) => vm.init(ticker),
            dispose: (_, __, ticker) => vm.dispose(),
            viewModels: [vm],
            builder: (_, __) {
              return Container();
            }),
      );

      // vm.addAnimationStatusListener((status) {
      //   print(status);
      //   if (status == AnimationStatus.completed ||
      //       status == AnimationStatus.dismissed) {
      //     numberOfRepeats++;
      //   }
      //   _status = status;
      // });

      // vm.endAnimationListener(() {
      //   endAnimationCount++;
      // });

      // expect(vm.value, equals(0));
      // expect(numberOfRepeats, equals(0));
      // expect(_status, null);
      // expect(endAnimationCount, 0);
      // // vm.setCycles(1);
      // vm.triggerAnimation();
      // await tester.pumpAndSettle();

      // expect(vm.value, equals(1));
      // expect(numberOfRepeats, equals(1));
      // expect(_status, equals(AnimationStatus.completed));
      // expect(endAnimationCount, 1);

      // numberOfRepeats = 0;
      // vm.setCycles(2);
      // vm.triggerAnimation();
      // await tester.pumpAndSettle();

      // expect(vm.value, equals(0));
      // expect(numberOfRepeats, equals(2));
      // expect(_status, equals(AnimationStatus.dismissed));
      // expect(endAnimationCount, 2);

      // numberOfRepeats = 0;
      // vm.setCycles(5);
      // vm.triggerAnimation();
      // await tester.pumpAndSettle();

      // expect(vm.value, equals(1));
      // expect(numberOfRepeats, equals(5));
      // expect(_status, equals(AnimationStatus.completed));
      // expect(endAnimationCount, 3);
    },
  );

  testWidgets(
    "explicit like animation (changing duration to 1s then to 5s)",
    (WidgetTester tester) async {
      final vm = ViewModel1();

      int numberOfRepeats = 0;

      await tester.pumpWidget(
        StateWithMixinBuilder<TickerProvider>(
            mixinWith: MixinWith.tickerProviderStateMixin,
            initState: (_, __, ticker) => vm.init(ticker),
            dispose: (_, __, ticker) => vm.dispose(),
            viewModels: [vm],
            builder: (_, __) {
              return Container();
            }),
      );

      vm.endAnimationListener(() {
        numberOfRepeats++;
      });
      vm.animator.duration = Duration(seconds: 1);
      vm.triggerAnimation();
      await tester.pumpAndSettle();

      expect(vm.controller.duration.inSeconds, equals(1));
      expect(numberOfRepeats, equals(1));
      vm.animator.duration = Duration(seconds: 5);

      vm.triggerAnimation();
      await tester.pumpAndSettle();

      expect(vm.controller.duration.inSeconds, equals(5));
      expect(numberOfRepeats, equals(2));
    },
  );

  testWidgets(
    "explicit like animation (changing curves to  bounceIn then to )",
    (WidgetTester tester) async {
      final vm = ViewModel1();

      // int numberOfRepeats = 0;

      await tester.pumpWidget(
        StateWithMixinBuilder<TickerProvider>(
            mixinWith: MixinWith.tickerProviderStateMixin,
            initState: (_, __, ticker) => vm.init(ticker),
            dispose: (_, __, ticker) => vm.dispose(),
            viewModels: [vm],
            builder: (_, __) {
              return Container();
            }),
      );

      vm.endAnimationListener(() {
        // print(vm.animation.isCompleted);
        // numberOfRepeats++;
      });
      vm.animator.curve = (Curves.bounceIn);
      vm.triggerAnimation();
      await tester.pumpAndSettle();

      expect(vm.animation.toString(), contains("BounceIn"));
      // expect(numberOfRepeats, equals(1));

      vm.animator.curve = (Curves.easeInBack);

      vm.triggerAnimation();
      await tester.pumpAndSettle();
      expect(vm.animation.toString(), contains("Cubic"));

      // expect(numberOfRepeats, equals(2));
    },
  );

  testWidgets(
    "explicit like animation (changing tween to   then to )",
    (WidgetTester tester) async {
      final vm = ViewModel1();

      await tester.pumpWidget(
        StateWithMixinBuilder<TickerProvider>(
            mixinWith: MixinWith.tickerProviderStateMixin,
            initState: (_, __, ticker) => vm.init(ticker),
            dispose: (_, __, ticker) => vm.dispose(),
            viewModels: [vm],
            builder: (_, __) {
              return Container();
            }),
      );

      vm.animator.tween = Tween(begin: 10, end: 20);
      vm.triggerAnimation();
      await tester.pumpAndSettle();

      expect(vm.animation.toString(), contains("Tween<double>(10.0 → 20.0)"));
      // expect(numberOfRepeats, equals(1));

      vm.animator.tween = Tween(begin: 50, end: -50);

      vm.triggerAnimation();
      await tester.pumpAndSettle();
      expect(vm.animation.toString(), contains("Tween<double>(50.0 → -50.0)"));

      // expect(numberOfRepeats, equals(2));
    },
  );

  test(
      "TweenMap :should throw an exception ((tweenMap notEq null && builder notEq null))",
      () {
    expect(() {
      Animator(
        tweenMap: {
          "anim1": Tween(begin: 0, end: 1),
          "anim2": Tween(begin: 0, end: 1),
        },
        builder: (anim) {
          return Container();
        },
      );
    }, throwsException);
  });

  test(
      "TweenMap :should throw an exception ((builder notEq null && builderMap notEq null))",
      () {
    expect(() {
      Animator(
        tweenMap: {
          "anim1": Tween(begin: 0, end: 1),
          "anim2": Tween(begin: 0, end: 1),
        },
        builder: (anim) {
          return Container();
        },
        builderMap: (_) => Container(),
      );
    }, throwsException);
  });

  test(
      "TweenMap :should throw an exception ((tweenMap Eq null && builderMap notEq null))",
      () {
    expect(() {
      Animator(
        builderMap: (_) => Container(),
      );
    }, throwsException);
  });
}

class ViewModel1 extends StatesRebuilderWithAnimator<double> {
  double get value => animation.value;
  init(TickerProvider ticker) {
    initAnimation(ticker);

    addAnimationListener(() {
      rebuildStates();
    });
  }
}

class ViewModel extends StatesRebuilder {
  startAnimation() {
    rebuildStates();
  }
}

class _Ticker extends State with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return null;
  }
}
