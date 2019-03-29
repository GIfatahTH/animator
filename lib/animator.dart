import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class SDe extends StatefulWidget {
  @override
  AnimationSetup createState() => AnimationSetup();
}

/// `AnimationSetup` allows you to setup your Animation by defining : `tween`, `duration`, `curve`.
class AnimationSetup extends State<SDe> with TickerProviderStateMixin {
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
  AnimationSetup({
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

  VoidCallback _listener, _customListener;
  Function(AnimationStatus) _statusListener;
  Function(AnimationStatus) _repeatstatusListener;

  int _cycles;
  int _repeats;

  /// Add statusListener to be called every time the status of the animation changes.
  void statusListener(void Function(AnimationStatus, AnimationSetup) listener) {
    if (_statusListener != null) {
      animation?.removeStatusListener(_statusListener);
    }
    animation?.removeStatusListener(_repeatstatusListener);

    _statusListener = (status) {
      listener(status, this);
    };
    animation?.addStatusListener(_statusListener);
  }

  /// Initialize animation by adding listener.
  /// You can define the number of repeats and trigger your animation
  ///
  /// You can add customListener : any Function you want to call every
  /// time the value of the animation changes.
  ///
  /// You can also and endAnimationListener : any Function you want to call
  /// every time the animation ends (for example to trigger other animation).
  initAnimation({
    StatesRebuilder bloc,
    List<State> states,
    List<String> ids,
    bool trigger = false,
    int cycles,
    int repeats,
    bool dispose = false,
    Function(AnimationSetup) customListener,
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

    if (_listener == null) {
      assert(bloc != null);
      assert(states != null || ids != null);
      _bloc = bloc;
      _listener = () {
        bloc.rebuildStates(states: states, ids: ids);
      };
    }

    animation.addListener(_listener);

    if (customListener != null) {
      _customListener = () => customListener(this);
      animation.addListener(_customListener);
    }

    if (_statusListener != null) {
      animation.addStatusListener(_statusListener);
    }

    if (cycles != null) {
      _cycles = cycles;
      _addCycleStatusListener(cycles, dispose, endAnimationListener);
    } else {
      _repeats = repeats ?? 1;
      _addRepeatStatusListener(_repeats, dispose, endAnimationListener);
    }

    if (trigger == true) {
      controller.forward();
    }
  }

  /// Starts running this animation forwards (towards the end).
  triggerAnimation(
      {int cycles, int repeats, bool dispose = false, bool reset = false}) {
    initAnimation(
        repeats: repeats ?? _repeats,
        cycles: cycles ?? _cycles,
        dispose: dispose);
    if (reset && (cycles == null && _cycles == null)) {
      controller.reset();
    }
    if (controller.isDismissed) {
      controller.forward();
    } else if (controller.isCompleted && (cycles != null || _cycles != null)) {
      controller.reverse();
    } else {
      controller.reset();
      controller.forward();
    }
  }

  /// Add listeners you want to calls every time animation ticks.
  ///
  /// if reset is true  previous listener are removed
  addListeners({List<State> states, List<String> ids, bool reset = true}) {
    if (reset) {
      animation.removeListener(_listener);
    }

    _listener = () {
      _bloc.rebuildStates(states: states, ids: ids);
    };

    animation.addListener(_listener);
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
    Function(AnimationSetup) customListener,
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
      if (_statusListener != null) {
        animation?.removeStatusListener(_statusListener);
      }
      _statusListener = null;
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

  _addCycleStatusListener(
      int cycles, bool dispose, VoidCallback endAnimationListener) {
    animation.removeStatusListener(_repeatstatusListener);
    if (cycles == 0) {
      _repeatstatusListener = (AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
        if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      };
    } else {
      _repeatstatusListener = (AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          cycles--;
          if (cycles <= 0) {
            animation.removeStatusListener(_repeatstatusListener);
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
            animation.removeStatusListener(_repeatstatusListener);
            if (dispose) disposeAnimation();
            if (endAnimationListener != null) endAnimationListener();
            return;
          } else {
            controller.forward();
          }
        }
      };
    }
    animation.addStatusListener(_repeatstatusListener);
  }

  _addRepeatStatusListener(
      int repeats, bool dispose, VoidCallback endAnimationListener) {
    animation.removeStatusListener(_repeatstatusListener);
    if (repeats == 0) {
      _repeatstatusListener = (AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          controller.reset();
          controller.forward();
        }
      };
    } else {
      _repeatstatusListener = (AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          repeats--;
          if (repeats <= 0) {
            animation.removeStatusListener(_repeatstatusListener);
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
    animation.addStatusListener(_repeatstatusListener);
  }

  /// Remove listener, statusListener and dispose the animation controller
  disposeAnimation() {
    animation.removeListener(_listener);
    animation.removeListener(_customListener);
    animation.removeStatusListener(_statusListener);
    if (!controllerIsDisposed) {
      controller?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Animator extends StatefulWidget {
  ///A widget that allows you to easily implement almost all the available
  ///Animation in flutter
  Animator(
      {Key key,
      this.tween,
      this.duration: const Duration(milliseconds: 500),
      this.curve: Curves.linear,
      this.cycles,
      this.repeats,
      this.animateOnRebuild: true,
      this.resetAnimationOnRebuild: true,
      this.builder,
      this.builderMap,
      this.tweenMap,
      this.stateID,
      this.blocs,
      this.customListener,
      this.endAnimationListener,
      this.statusListener})
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

  ///A linear interpolation between a beginning and ending value.
  ///
  ///`tween` argument is used for one Tween animation.
  final Tween tween;

  ///A span of time, such as 27 days, 4 hours, 12 minutes, and 3 seco
  final Duration duration;

  ///An easing curve, i.e. a mapping of the unit interval to the unit interval.
  final Curve curve;

  ///The number of forward and backward periods the animation performs before stopping
  final int cycles;

  ///The number of forward periods the animation performs before stopping
  final int repeats;

  ///Whether the animation is automatically restarted when Animator widget
  ///is rebuilt. The default value is true
  final bool animateOnRebuild;

  ///Whether the animation settings are reset when Animator widget
  ///is rebuilt. The default value is false.
  ///
  ///Animation settings are defined by the tween, duration and curve argument.
  final bool resetAnimationOnRebuild;

  ///Function to be called every time the animation value changes.
  ///
  ///The customListener is provided with an [Animation] object.
  final Function(AnimationSetup) customListener;

  ///VoidCallback to be called when animation is finished.
  final VoidCallback endAnimationListener;

  ///Function to be called every time the status of the animation changes.
  ///
  ///The customListener is provided with an [AnimationStatus, AnimationSetup] object.
  final Function(AnimationStatus, AnimationSetup) statusListener;

  ///The build strategy currently used for one Tween. Animator widget rebuilds
  ///itself every time the animation changes value.
  ///
  ///The builder is provided with an [Animation] object.
  final Widget Function(Animation) builder;

  ///The build strategy currently used for multi-Tween. Animator widget rebuilds
  ///itself every time the animation changes value.
  ///
  ///The `builderMap` is provided with an `Map<String, Animation>` object.
  final Widget Function(Map<String, Animation>) builderMap;

  ///A linear interpolation between a beginning and ending value.
  ///
  ///`tweenMap` argument is used for multi-Tween animation.
  final Map<String, Tween<dynamic>> tweenMap;

  ///The unique name of your Animator widget.
  ///
  ///It is used to rebuild this widget from your logic classes
  final String stateID;

  /// The list of your logicclasses you want to rebuild this widget from.
  final List<StatesRebuilder> blocs;

  @override
  _AnimatorState createState() => _AnimatorState();
}

class _AnimatorState extends State<Animator> {
  AnimationSetup _animationSetup;
  Map<String, Animation> get _animationMap => _animationSetup.animationMap;
  Animation get _animation => _animationSetup.animation;
  final _bloc = StatesRebuilder();

  @override
  void initState() {
    super.initState();
    if (widget.stateID != null && widget.stateID != "") {
      if (widget.blocs != null) {
        widget.blocs.forEach(
          (b) {
            if (b == null) return;
            b.addState(widget.stateID, this);
          },
        );
      }
    }
    _initAnim("animattionWithAnimtor#2597442");
  }

  @override
  void didUpdateWidget(Animator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animateOnRebuild && widget.resetAnimationOnRebuild) {
      _initAnim("animattionWithAnimtor#2597442");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      stateID: 'animattionWithAnimtor#2597442',
      blocs: [_bloc],
      didUpdateWidget: (_, __) {
        if (widget.animateOnRebuild) {
          _animationSetup.triggerAnimation();
        }
      },
      builder: (_) {
        if (widget.builder != null) {
          return widget.builder(_animation);
        } else {
          return widget.builderMap(_animationMap);
        }
      },
    );
  }

  @override
  void dispose() {
    if (widget.stateID != null && widget.stateID != "") {
      if (widget.blocs != null) {
        widget.blocs.forEach(
          (b) {
            if (b == null) return;
            if (b.stateMap[widget.stateID].hashCode == this.hashCode) {
              b.stateMap.remove(widget.stateID);
            }
          },
        );
      }
    }
    _animationSetup.disposeAnimation();
    super.dispose();
  }

  void _initAnim(String id) {
    _animationSetup = AnimationSetup(
      tween: widget.tween ?? Tween<double>(begin: 0, end: 1),
      tweenMap: widget.tweenMap,
      duration: widget.duration,
      curve: widget.curve,
    );

    _animationSetup.initAnimation(
      bloc: _bloc,
      ids: [id],
      cycles: widget.cycles,
      repeats: widget.repeats,
      customListener: widget.customListener,
      endAnimationListener: widget.endAnimationListener,
      trigger: true,
      dispose: !widget.animateOnRebuild,
    );

    if (widget.statusListener != null) {
      _animationSetup.statusListener(widget.statusListener);
    }
  }
}
