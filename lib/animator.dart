import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

/// `AnimationSetup` allows you to setup your Animation by defining : `tween`, `duration`, `curve`.
class AniamtionSetup extends State with TickerProviderStateMixin {
  ///A linear interpolation between a beginning and ending value.
  ///
  ///The default `tween` is Tween<double>(begin: 0, end: 1).
  Tween tween;

  /// Map of Tween of different types.
  Map<String, Tween> tweenMap;

  /// A span of time, such as 27 days, 4 hours, 12 minutes, and 3 seconds.
  ///
  /// The default `duration` is Duration(milliseconds: 500).
  final Duration duration;

  /// An easing curve, i.e. a mapping of the unit interval to the unit interval.
  ///
  /// The default `curve` is Curves.linear.
  Curve curve;

  StatesRebuilder _bloc;

  ///The current value of the animation.
  get value => animation?.value ?? tween.begin;

  Map<String, dynamic> _valueMap = {};

  ///Map of current values of the animationMap.
  Map<String, dynamic> get valueMap {
    animationMap.forEach((k, v) {
      _valueMap[k] = v?.value;
    });
    return _valueMap;
  }

  bool get controllerIsDisposed => '$controller'.contains("DISPOSED");
  AniamtionSetup({
    Tween tween,
    this.tweenMap,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.linear,
  }) {
    this.tween = tween ?? Tween<double>(begin: 0, end: 1);
  }

  AnimationController controller;
  Animation animation;

  // Map of animation, keys are the same as key of tweenMap
  Map<String, Animation> animationMap = {};

  VoidCallback _listner, _customListener;
  Function(AnimationStatus) _statusListner;
  Function(AnimationStatus) _repeatstatusListner;

  int _cycles;
  int _repeats;

  /// Add statusListener to be called every time the status of the animation changes.
  void statusListener(void Function(AnimationStatus, AniamtionSetup) listener) {
    if (_statusListner != null) {
      animation?.removeStatusListener(_statusListner);
    }
    animation?.removeStatusListener(_repeatstatusListner);

    _statusListner = (status) {
      listener(status, this);
    };
    animation?.addStatusListener(_statusListner);
  }

  /// Initialize animation by adding listener.
  /// You can define the number of repeats and trigger your animation
  ///
  /// You can add customListener : any Function you want to call every
  /// time the value of the animation changes.
  ///
  /// You can also and endAnimationListner : any Function you want to call
  /// every time the animation ends (for example to trigger other animation).
  initAnimation({
    StatesRebuilder bloc,
    List<State> states,
    List<String> ids,
    bool trigger = false,
    int cycles,
    int repeats,
    bool dispose = false,
    Function(AniamtionSetup) customListener,
    VoidCallback endAnimationListener,
  }) {
    if (controller == null || controllerIsDisposed) {
      controller = AnimationController(duration: duration, vsync: this);
    }

    animation =
        tween.animate(CurvedAnimation(parent: controller, curve: curve));

    if (tweenMap != null) {
      animationMap = {};
      tweenMap?.forEach((k, v) {
        animationMap[k] =
            v.animate(CurvedAnimation(parent: controller, curve: curve));
      });
    }

    if (_listner == null) {
      assert(bloc != null);
      assert(states != null || ids != null);
      _bloc = bloc;
      _listner = () {
        bloc.rebuildStates(states: states, ids: ids);
      };
    }

    animation.addListener(_listner);

    if (customListener != null) {
      _customListener = () => customListener(this);
      animation.addListener(_customListener);
    }

    if (_statusListner != null) {
      animation.addStatusListener(_statusListner);
    }

    if (cycles != null) {
      _cycles = cycles;
      _addCycleStatusListner(cycles, dispose, endAnimationListener);
    } else if (repeats != null) {
      _repeats = repeats;
      _addRepeatStatusListner(repeats, dispose, endAnimationListener);
    }

    if (trigger == true) {
      controller.forward();
    }
  }

  /// Starts running this animation forwards (towards the end).
  triggerAnimation({int cycles, int repeats, bool dispose = false}) {
    initAnimation(
        repeats: repeats ?? _repeats,
        cycles: cycles ?? _cycles,
        dispose: dispose);
    if (controller.isDismissed) {
      controller.forward();
    } else if (controller.isCompleted) {
      controller.reverse();
    } else {
      controller.reset();
      controller.forward();
    }
  }

  /// Add listners you want to calls every time animation ticks.
  ///
  /// if reset is true  previous listener are removed
  addListners({List<State> states, List<String> ids, bool reset = true}) {
    if (reset) {
      animation.removeListener(_listner);
    }

    _listner = () {
      _bloc.rebuildStates(states: states, ids: ids);
    };

    animation.addListener(_listner);
  }

  /// Change any of the animation parameters.
  /// such as tween, duration, curve, cycles and repeats.
  changeAnimatioSetup({
    Tween tween,
    Map<String, Tween> tweenMap,
    bool resetTweenMap = false,
    final Duration duration,
    final Curve curve,
    bool trigger = false,
    int cycles,
    int repeats,
    bool dispose: false,
    Function(AniamtionSetup) customListener,
    VoidCallback endAnimationListener,
  }) {
    if (tween != null) {
      this.tween = tween;
    }

    if (tweenMap != null) {
      if (resetTweenMap) {
        this.tweenMap = tweenMap;
      } else {
        this.tweenMap.addAll(tweenMap);
      }
    }

    if (duration != null) {
      controller.duration = duration;
    }

    if (curve != null) {
      this.curve = curve;
    }
    if (cycles != null || repeats != null) {
      if (_statusListner != null) {
        animation?.removeStatusListener(_statusListner);
      }
      _statusListner = null;
    }

    initAnimation(
      trigger: trigger,
      cycles: cycles,
      repeats: repeats,
      customListener: customListener,
      endAnimationListener: endAnimationListener,
      dispose: dispose,
    );
  }

  _addCycleStatusListner(
      int cycles, bool dispose, VoidCallback endAnimationListener) {
    if (cycles == 0) {
      _repeatstatusListner = (AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
        if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      };
    } else {
      _repeatstatusListner = (AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          cycles--;
          if (cycles <= 0) {
            if (dispose) disposeAnimation();
            if (endAnimationListener != null) endAnimationListener();
            return;
          } else {
            controller.reverse();
          }
        }
        if (status == AnimationStatus.dismissed) {
          cycles--;
          if (cycles <= 0) {
            if (dispose) disposeAnimation();
            if (endAnimationListener != null) endAnimationListener();
            return;
          } else {
            controller.forward();
          }
        }
      };
    }
    animation.addStatusListener(_repeatstatusListner);
  }

  _addRepeatStatusListner(
      int repeats, bool dispose, VoidCallback endAnimationListener) {
    if (repeats == 0) {
      _repeatstatusListner = (AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          controller.reset();
          controller.forward();
        }
      };
    } else {
      _repeatstatusListner = (AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          repeats--;
          if (repeats <= 0) {
            if (dispose) disposeAnimation();
            if (endAnimationListener != null) endAnimationListener();
            return;
          } else {
            controller.reset();
            controller.forward();
          }
        }
      };
    }
    animation.addStatusListener(_repeatstatusListner);
  }

  // Remove listener, statusListner and dispose the animation controller
  disposeAnimation() {
    animation.removeListener(_listner);
    animation.removeListener(_customListener);
    animation.removeStatusListener(_statusListner);
    if (!'$controller'.contains("DISPOSED")) {
      controller?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Animator extends StatefulWidget {
  final Tween tween;
  final Duration duration;
  final Curve curve;
  final int cycles;
  final int repeats;
  final VoidCallback endAnimationListener;

  final Widget Function(Animation) builder;
  final Widget Function(Map<String, Animation>) builderMap;

  final Map<String, Tween<dynamic>> tweenMap;

  Animator(
      {Key key,
      this.tween,
      this.duration: const Duration(milliseconds: 500),
      this.curve: Curves.linear,
      this.cycles,
      this.repeats: 1,
      this.builder,
      this.builderMap,
      this.tweenMap,
      this.endAnimationListener})
      : assert(() {
          if (builder == null && builderMap == null) {
            throw FlutterError(
                'You have to define one of the "builder" or "builderMap" argument\n'
                ' - Define the "builder" argument if you have one Tween\n'
                ' - Define the "builderMap" argument if you have many Tweens');
          }
          if (builder != null && builderMap != null) {
            throw FlutterError(
                'You have to define either buider or "builderMap" argument. you can\'t define both\n'
                ' - Define the "builder" argument if you have one Tween\n'
                ' - Define the "builderMap" argument if you have many Tweens');
          }
          if (builderMap != null && tweenMap == null) {
            throw FlutterError(
                '"tweenMap" must not be null. If you have one tween use "builder" argument instead');
          }
          return true;
        }()),
        super(key: key);

  @override
  _AnimatorState createState() => _AnimatorState();
}

class _AnimatorState extends State<Animator> {
  AniamtionSetup _animationSetup;
  Map<String, Animation> get _animationMap => _animationSetup.animationMap;
  Animation get _animation => _animationSetup.animation;
  final _bloc = StatesRebuilder();
  @override
  void initState() {
    super.initState();
    _animationSetup = AniamtionSetup(
      tween: widget.tween ?? Tween<double>(begin: 0, end: 1),
      tweenMap: widget.tweenMap,
      duration: widget.duration,
      curve: widget.curve,
    );
    _animationSetup.initAnimation(
      bloc: _bloc,
      states: [this],
      cycles: widget.cycles,
      repeats: widget.repeats,
      endAnimationListener: widget.endAnimationListener,
      trigger: true,
      dispose: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return widget.builder(_animation);
    } else {
      return widget.builderMap(_animationMap);
    }
  }

  @override
  void dispose() {
    _animationSetup.disposeAnimation();
    super.dispose();
  }
}
