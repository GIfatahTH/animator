import 'package:animator/src/animator.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

void main() {
  // testWidgets('should instantiate animation Controller and animation objects',
  //     (tester) async {
  //   final animator = Animator<double>(
  //     triggerOnInit: false,
  //     builder: (_, anim, __) {
  //       return Container();
  //     },
  //   );
  //   final animatorBloc = AnimatorState<double>(animator, () {});

  //   (animatorBloc as AnimatorStateImp).initAnimation(_Ticker());

  //   expect(animatorBloc.controller, isNot(isNull));
  //   expect(animatorBloc.animation, isNot(isNull));
  // });

  testWidgets(
      'should initialize animation without starting it (triggerOnInit = false)',
      (WidgetTester tester) async {
    double? animationValue;
    AnimationStatus? animationStatue;

    final animator = Animator<double>(
      triggerOnInit: false,
      builder: (_, anim, __) {
        animationValue = anim.value;
        animationStatue = anim.animation.status;
        return Container();
      },
    );

    expect(animationValue, isNull);
    expect(animationStatue, isNull);

    await tester.pumpWidget(animator);

    expect(animationValue, equals(0));
    expect(animationStatue, equals(AnimationStatus.dismissed));

    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(animationValue, equals(0));
    expect(animationStatue, equals(AnimationStatus.dismissed));
  });

  testWidgets(
      'should auto-starts (triggerOnInit = true) and ends after 1 s (repeat=1)',
      (WidgetTester tester) async {
    double? animationValue;
    AnimationStatus? animationStatue;
    var numberOfRepeats = 0;
    final animator = Animator<double>(
      duration: const Duration(seconds: 1),
      statusListener: (status, anim) {
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
      },
      builder: (_, anim, __) {
        animationValue = anim.value;
        animationStatue = anim.animation.status;
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

  testWidgets('should auto-starts and ends after 500ms (repeat=1) : Tween<int>',
      (WidgetTester tester) async {
    int? animationValue;
    AnimationStatus? animationStatue;
    var numberOfRepeats = 0;
    final animator = Animator<int>(
      tween: IntTween(begin: 0, end: 10), // use IntTween instead of Tween<int>
      statusListener: (status, anim) {
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
      },
      builder: (_, anim, __) {
        animationValue = anim.value;
        animationStatue = anim.animation.status;
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

  testWidgets('should auto-starts (triggerOnInit = true) and repeat 2 times',
      (WidgetTester tester) async {
    double? animationValue;
    AnimationStatus? animationStatue;
    var numberOfRepeats = 0;
    final animator = Animator<double>(
      duration: const Duration(seconds: 1),
      repeats: 2,
      statusListener: (status, anim) {
        animationStatue = status;
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
      },
      builder: (_, anim, __) {
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

  testWidgets('should auto-starts (triggerOnInit = true) and cycle 2 times',
      (WidgetTester tester) async {
    double? animationValue;
    AnimationStatus? animationStatue;
    var numberOfRepeats = 0;
    final animator = Animator<double>(
      duration: const Duration(seconds: 1),
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
      builder: (_, anim, __) {
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

  testWidgets('should auto-starts (triggerOnInit = true) and repeat 5 times',
      (WidgetTester tester) async {
    double? animationValue;
    AnimationStatus? animationStatue;
    var numberOfRepeats = 0;
    var animationIsEndedNumber = 0;

    final animator = Animator<double>(
      duration: const Duration(seconds: 1),
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
      builder: (_, anim, __) {
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

  testWidgets('should auto-starts (triggerOnInit = true) and cycle 5 times',
      (WidgetTester tester) async {
    double? animationValue;
    AnimationStatus? animationStatue;
    var numberOfRepeats = 0;
    var animationIsEndedNumber = 0;
    final animator = Animator<double>(
      duration: const Duration(seconds: 1),
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
      builder: (_, anim, __) {
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

  // testWidgets('should  repeats 0 throw time out error',
  //     (WidgetTester tester) async {
  //   final animator = Animator<double>(
  //     tween: Tween<double>(begin: 0, end: 1),
  //     duration: const Duration(seconds: 1),
  //     curve: Curves.linear,
  //     triggerOnInit: true,
  //     repeats: 0,
  //     builder: (_, anim, __) {
  //       print(anim.value);
  //       return Container();
  //     },
  //   );
  //   await tester.pumpWidget(animator);
  //   await tester.pumpAndSettle();
  // });

  // testWidgets('should  cycle 0 throw time out error',
  //     (WidgetTester tester) async {
  //   final animator = Animator<double>(
  //     tween: Tween<double>(begin: 0, end: 1),
  //     duration: const Duration(seconds: 1),
  //     curve: Curves.linear,
  //     triggerOnInit: true,
  //     cycles: 0,
  //     builder: (_, anim, __) {
  //       print(anim.value);
  //       return Container();
  //     },
  //   );
  //   await tester.pumpWidget(animator);
  //   await tester.pumpAndSettle();
  // });

  testWidgets('should customListener be called each frame',
      (WidgetTester tester) async {
    double? animationValue;
    AnimationStatus? animationStatue;
    var numberOfRepeats = 0;
    double? customAnimationValue;

    final animator = Animator<double>(
      duration: const Duration(seconds: 1),
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
      builder: (_, anim, __) {
        animationValue = anim.value;
        return Container();
      },
    );

    await tester.pumpWidget(animator);

    expect(animationValue, equals(0));

    await tester.pump(Duration(milliseconds: 500));
    expect(customAnimationValue == animationValue, isTrue);

    await tester.pumpAndSettle();

    expect(animationValue, equals(1));
    expect(animationStatue, equals(AnimationStatus.completed));
    expect(numberOfRepeats, equals(1));
    expect(customAnimationValue == animationValue, isTrue);
  });

  testWidgets('should not auto-Start because animatorKey is defined',
      (WidgetTester tester) async {
    double? animationValue;
    AnimationStatus? animationStatue;
    var numberOfRepeats = 0;
    final animator = Animator<double>(
      duration: const Duration(seconds: 1),
      animatorKey: AnimatorKey<double>(),
      statusListener: (status, anim) {
        animationStatue = status;
        if (status == AnimationStatus.completed) {
          numberOfRepeats++;
        }
        if (status == AnimationStatus.dismissed) {
          numberOfRepeats++;
        }
      },
      builder: (_, anim, __) {
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
      'should  auto-Start (triggerOnInit is true '
      'although  animatorKey is defined', (WidgetTester tester) async {
    double? animationValue;
    AnimationStatus? animationStatue;
    var numberOfRepeats = 0;
    final animator = Animator<double>(
      duration: const Duration(seconds: 1),
      animatorKey: AnimatorKey<double>(),
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
      builder: (_, anim, __) {
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
    'should not auto-Start, it will be triggered from the viewModel class',
    (WidgetTester tester) async {
      double? animationValue;
      AnimationStatus? animationStatue;
      var numberOfRepeats = 0;
      final animatorKey = AnimatorKey<double>();
      final animator = Animator<double>(
        duration: const Duration(seconds: 1),
        animatorKey: animatorKey,
        statusListener: (status, anim) {
          animationStatue = status;
          if (status == AnimationStatus.completed) {
            numberOfRepeats++;
          }
        },
        builder: (_, anim, __) {
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

      animatorKey.triggerAnimation();

      await tester.pumpAndSettle();

      expect(animationValue, equals(1));
      expect(animationStatue, equals(AnimationStatus.completed));
      expect(numberOfRepeats, equals(1));

      animatorKey.triggerAnimation();
      await tester.pumpAndSettle();

      expect(animationValue, equals(1));
      expect(animationStatue, equals(AnimationStatus.completed));
      expect(numberOfRepeats, equals(2));
    },
  );

  testWidgets(
    'should not auto-Start, it will be triggered from the viewModel class '
    '(4 repeats)',
    (WidgetTester tester) async {
      double? animationValue;
      AnimationStatus? animationStatue;
      var numberOfRepeats = 0;
      final animatorKey = AnimatorKey<double>();
      final animator = Animator<double>(
        duration: const Duration(seconds: 1),
        animatorKey: animatorKey,
        repeats: 4,
        statusListener: (status, anim) {
          animationStatue = status;
          if (status == AnimationStatus.completed) {
            numberOfRepeats++;
          }
        },
        builder: (_, anim, __) {
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

      animatorKey.triggerAnimation();

      await tester.pumpAndSettle();

      expect(animationValue, equals(1));
      expect(animationStatue, equals(AnimationStatus.completed));
      expect(numberOfRepeats, equals(4));

      animatorKey.triggerAnimation();
      await tester.pumpAndSettle();

      expect(animationValue, equals(1));
      expect(animationStatue, equals(AnimationStatus.completed));
      expect(numberOfRepeats, equals(8));
    },
  );

  testWidgets(
    'should not auto-Start, it will be triggered from the viewModel class '
    '(1 cycle)',
    (WidgetTester tester) async {
      double? animationValue;
      AnimationStatus? animationStatue;
      var numberOfRepeats = 0;
      final animatorKey = AnimatorKey<double>();
      final animator = Animator<double>(
        duration: const Duration(seconds: 1),
        animatorKey: animatorKey,
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
        builder: (_, anim, __) {
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

      animatorKey.triggerAnimation();

      await tester.pumpAndSettle();

      expect(animationValue, equals(1));
      expect(animationStatue, equals(AnimationStatus.completed));
      expect(numberOfRepeats, equals(1));

      animatorKey.triggerAnimation();
      await tester.pumpAndSettle();

      expect(animationValue, equals(0));
      expect(animationStatue, equals(AnimationStatus.dismissed));
      expect(numberOfRepeats, equals(2));

      animatorKey.triggerAnimation();
      await tester.pumpAndSettle();

      expect(animationValue, equals(1));
      expect(animationStatue, equals(AnimationStatus.completed));
      expect(numberOfRepeats, equals(3));
    },
  );

  testWidgets(
    'should not auto-Start, it will be triggered from the viewModel class'
    ' (4 cycle)',
    (WidgetTester tester) async {
      double? animationValue;
      AnimationStatus? animationStatue;
      var numberOfRepeats = 0;
      final animatorKey = AnimatorKey<double>();
      final animator = Animator<double>(
        duration: const Duration(seconds: 1),
        animatorKey: animatorKey,
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
        builder: (_, anim, __) {
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

      animatorKey.triggerAnimation();

      await tester.pumpAndSettle();

      expect(animationValue, equals(0));
      expect(animationStatue, equals(AnimationStatus.dismissed));
      expect(numberOfRepeats, equals(4));

      animatorKey.triggerAnimation();
      await tester.pumpAndSettle();

      expect(animationValue, equals(0));
      expect(animationStatue, equals(AnimationStatus.dismissed));
      expect(numberOfRepeats, equals(8));

      animatorKey.triggerAnimation();
      await tester.pumpAndSettle();

      expect(animationValue, equals(0));
      expect(animationStatue, equals(AnimationStatus.dismissed));
      expect(numberOfRepeats, equals(12));
    },
  );

  testWidgets(
    'should ColorTween tween work',
    (WidgetTester tester) async {
      Color? color;
      final animator = Animator<Color?>(
        tween: ColorTween(begin: Colors.red, end: Colors.blue),
        builder: (_, anim, __) {
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
    'online change of animation setup, resetAnimationOnRebuild = true',
    (WidgetTester tester) async {
      Offset? offset;
      var switcher = true;

      final vm = RM.inject(() => ViewModel());
      await tester.pumpWidget(
        StateBuilder<ViewModel>(
          observe: () => vm,
          builder: (_, __) {
            return Animator<Offset>(
              tween: switcher
                  ? Tween<Offset>(begin: Offset.zero, end: const Offset(1, 1))
                  : Tween<Offset>(
                      begin: const Offset(10, 10), end: const Offset(20, 20)),
              duration: const Duration(seconds: 1),
              resetAnimationOnRebuild: true,
              builder: (_, anim, __) {
                offset = anim.value;
                return Container();
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
    'animation setup should not change resetAnimationOnRebuild = false',
    (WidgetTester tester) async {
      Offset? offset;
      var switcher = true;
      final vm = RM.inject(() => ViewModel());

      await tester.pumpWidget(
        StateBuilder<ViewModel>(
          observe: () => vm,
          builder: (_, __) {
            return Animator<Offset>(
              tween: switcher
                  ? Tween<Offset>(begin: Offset.zero, end: const Offset(1, 1))
                  : Tween<Offset>(
                      begin: const Offset(10, 10), end: const Offset(20, 20)),
              duration: const Duration(seconds: 1),
              builder: (_, anim, __) {
                offset = anim.value;
                return Container();
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
      expect(offset, const Offset(1, 1));

      await tester.pumpAndSettle();
      expect(offset, const Offset(1, 1));
    },
  );

  testWidgets(
    'animation should not start resetAnimationOnRebuild = false',
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
              resetAnimationOnRebuild: false,
              triggerOnInit: false,
              builder: (_, anim, __) {
                offset = anim.value;
                return Container();
              },
            );
          },
        ),
      );

      expect(offset, equals(Offset.zero));

      await tester.pumpAndSettle();

      expect(offset, const Offset(0, 0));

      switcher = false;
      vm.notify();
      await tester.pump();
      expect(offset, const Offset(0, 0));

      await tester.pumpAndSettle();
      expect(offset, const Offset(0, 0));
    },
  );

  // test(
  //     'TweenMap :should throw an exception '
  //     '((builder notEq null && builderMap notEq null))', () {
  //   expect(() {
  //     Animator<double>(
  //         tweenMap: {
  //           'anim1': Tween<int>(begin: 0, end: 1),
  //           'anim2': Tween<int>(begin: 0, end: 1),
  //         },
  //         builder: (_, anim, __) {
  //           return Container();
  //         });
  //   }, throwsException);
  // });

  // test(
  //     'TweenMap :should throw an exception '
  //     '((tweenMap Eq null && builderMap notEq null))', () {
  //   expect(() {
  //     Animator<double>();
  //   }, throwsException);
  // });

  testWidgets('stop and dispose animation when animator is disposed',
      (tester) async {
    var switcher = true;
    var vm = RM.inject(() => ViewModel());
    final widget = MaterialApp(
      home: Scaffold(
        body: StateBuilder<ViewModel>(
          observe: () => vm,
          builder: (_, __) {
            if (switcher == true) {
              return Animator<double>(
                builder: (_, anim, __) {
                  return Text(anim.value.toString());
                },
              );
            }
            return const Text('Stop');
          },
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('0.2'), findsOneWidget);

    switcher = false;
    vm.notify();
    await tester.pumpAndSettle();
    expect(find.text('Stop'), findsOneWidget);
  });

  testWidgets(
    'online change of animation setup, using refreshAnimation',
    (WidgetTester tester) async {
      Offset? offset;

      final animatorKey = AnimatorKey<Offset>();
      await tester.pumpWidget(Animator<Offset>(
        tween: Tween<Offset>(begin: Offset.zero, end: const Offset(1, 1)),
        duration: const Duration(seconds: 1),
        animatorKey: animatorKey,
        builder: (_, anim, __) {
          offset = anim.value;
          return Container();
        },
      ));

      expect(offset, equals(Offset.zero));
      animatorKey.triggerAnimation();
      await tester.pumpAndSettle();
      expect(offset, const Offset(1, 1));

      animatorKey.resetAnimation(
        tween: Tween<Offset>(
            begin: const Offset(10, 10), end: const Offset(20, 20)),
      );
      await tester.pump();
      expect(offset, const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(offset, const Offset(20, 20));
    },
  );

  // testWidgets(
  //   'should throw if both tween and tweenMap are defined',
  //   (WidgetTester tester) async {
  //     expect(
  //         () => Animator<double>(
  //               tween: Tween<double>(),
  //               tweenMap: {},
  //               builder: (_, anim, __) {
  //                 return Container();
  //               },
  //             ),
  //         throwsException);
  //   },
  // );

  testWidgets(
    'should animatorKey as observer works, case it is assigned before observer',
    (tester) async {
      final animatorKey = AnimatorKey<double>();
      final widget = Column(
        children: [
          Animator<double>(
            animatorKey: animatorKey,
            builder: (_, anim, __) {
              return Text('${anim.value}');
            },
          ),
          AnimatorRebuilder(
            observe: () => animatorKey,
            builder: (_, anim, __) {
              return Text('${anim.value}');
            },
          ),
          AnimatorRebuilder(
            observe: () => animatorKey,
            builder: (_, anim, __) {
              return Text('${anim.value}');
            },
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp(
        home: widget,
      ));
      expect(find.text('0.0'), findsNWidgets(3));
      animatorKey.triggerAnimation();
      await tester.pumpAndSettle();
      expect(find.text('1.0'), findsNWidgets(3));
      //
      animatorKey.triggerAnimation();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('0.4'), findsNWidgets(3));
      //
      animatorKey.triggerAnimation(restart: true);
      await tester.pump();
      expect(find.text('0.0'), findsNWidgets(3));
      await tester.pumpAndSettle();
      expect(find.text('1.0'), findsNWidgets(3));
      expect(animatorKey.controller.status, AnimationStatus.completed);
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'animatorKey as observer',
    (tester) async {
      final animatorKey = AnimatorKey<double>(initialValue: 0);
      final widget = Column(
        children: [
          AnimatorRebuilder(
            observe: () => animatorKey,
            builder: (_, anim, __) {
              return Text('${anim.value}');
            },
          ),
          AnimatorRebuilder(
            observe: () => animatorKey,
            builder: (_, anim, __) {
              return Text('${anim.value}');
            },
          ),
          Animator<double>(
            animatorKey: animatorKey,
            child: Text('child'),
            builder: (_, anim, child) {
              return Column(
                children: [
                  child!,
                  Text('${anim.value}'),
                ],
              );
            },
          ),
          AnimatorRebuilder(
            observe: () => animatorKey,
            child: Text('child'),
            builder: (_, anim, child) {
              return Column(
                children: [
                  child!,
                  Text('${anim.value}'),
                ],
              );
            },
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp(
        home: widget,
      ));
      expect(find.text('0.0'), findsNWidgets(4));
      animatorKey.triggerAnimation();
      await tester.pumpAndSettle();
      expect(find.text('1.0'), findsNWidgets(4));
      //
      animatorKey.triggerAnimation();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('0.4'), findsNWidgets(4));
      //
      animatorKey.triggerAnimation(restart: true);
      await tester.pump();
      expect(find.text('0.0'), findsNWidgets(4));
      await tester.pumpAndSettle();
      expect(find.text('1.0'), findsNWidgets(4));
      expect(animatorKey.controller.status, AnimationStatus.completed);
      expect(find.text('child'), findsNWidgets(2));

      await tester.pumpAndSettle();
    },
  );
}

class ViewModel {}
