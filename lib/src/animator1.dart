import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

// part 'animator_key.dart';
// part 'animator_rebuilder.dart';
// part 'animator_state.dart';
// part 'child.dart';
// part 'implicit_animator.dart';
// part 'state_builder.dart';

///{@template animatorState}
///The state of [Animator] widget.
///
///From the parameter defined in the [Animator] widget, it instantiates
///the animation.
///
///{@endtemplate}
abstract class AnimatorState<T> {
  ///{@macro animatorState}

  void resetAnimation({
    Tween<T?>? tween,
    Map<String, Tween>? tweenMap,
    Duration? duration,
    Curve? curve,
    int? repeats,
    int? cycles,
  });

  void triggerAnimation({bool restart = false});

  ///The [AnimationController] for an animation.
  ///
  ///It lets you perform tasks such as:
  ///* paly, reverse, stop animation
  ///* Set the animation to a specific.
  AnimationController get controller;

  ///The [Animation] object
  Animation<T> get animation;

  ///get the animation of provided name
  ///
  ///It will throw if [Animator.tweenMap] is null
  Animation<R> getAnimation<R>(String name);

  ///The value of the [animation]
  T get value;

  ///The value map of the [Animator.tweenMap];
  R getValue<R>(String name);
}

class AnimatorStateImp<T> implements AnimatorState<T> {
  final InjectedAnimation injected;
  final Animator<T> animator;
  AnimatorStateImp({
    required this.injected,
    required this.animator,
  });
  Map<String, Animation<dynamic>> _animationMap = {};
  Animation<T>? _animation;
  @override
  Animation<T> get animation =>
      _animation ??= animator.tween!.animate(injected.curvedAnimation);

  @override
  AnimationController get controller => injected.controller!;

  @override
  Animation<R> getAnimation<R>(String name) {
    assert(animator.tweenMap?.isNotEmpty == true);
    var anim = _animationMap[name];
    if (anim != null) {
      return anim as Animation<R>;
    }
    anim = animator.tweenMap![name]!.animate(injected.curvedAnimation);
    _animationMap[name] = anim;
    return anim as Animation<R>;
  }

  @override
  T get value => animation.value;

  @override
  R getValue<R>(String name) {
    final anim = getAnimation(name);
    return anim.value as R;
  }

  @override
  void resetAnimation({
    Tween<T?>? tween,
    Map<String, Tween>? tweenMap,
    Duration? duration,
    Curve? curve,
    int? repeats,
    int? cycles,
  }) {
    // TODO: implement resetAnimation
  }

  @override
  void triggerAnimation({bool restart = false}) {
    injected.triggerAnimation();
  }

  void dispose() {
    _animation = null;
    _animationMap.clear();
  }
}

class AnimatorKey<T> {}

///{@template animator}
///A facade widget that hide the complexity of setting animation in Flutter
///
///It allows you to easily implement almost all the available
///Animation in flutter
///{@endtemplate}
class Animator<T> extends StatefulWidget {
  ///{@macro animator}
  Animator({
    Key? key,
    this.tween,
    this.tweenMap,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.linear,
    this.cycles,
    this.repeats,
    this.resetAnimationOnRebuild = false,
    this.triggerOnInit,
    required this.builder,
    this.child,
    this.animatorKey,
    this.customListener,
    this.endAnimationListener,
    this.statusListener,
    // this.tickerMixin,
    // this.observe,
  }) : super(key: key); //TODO check T==dynamic || tween != null

  ///A linear interpolation between a beginning and ending value.
  ///
  ///`tween` argument is used for one Tween animation.
  final Tween<T>? tween;

  ///A span of time, such as 27 days, 4 hours, 12 minutes, and 3 seconds
  final Duration duration;

  ///An easing curve, i.e. a mapping of the unit interval to the unit interval.
  final Curve? curve;

  ///The number of forward and backward periods the animation
  ///performs before stopping
  final int? cycles;

  ///The number of forward periods the animation performs before stopping
  final int? repeats;

  ///Whether the animation settings are reset when Animator widget
  ///is rebuilt. The default value is false.
  ///
  ///Animation settings are defined by the tween, duration and curve argument.
  final bool resetAnimationOnRebuild;

  ///Whether to start the animation when the Animator widget
  ///is inserted into the tree.
  final bool? triggerOnInit;

  ///Function to be called every time the animation value changes.
  ///
  ///The customListener is provided with an [Animation] object.
  final void Function(AnimatorState<T>)? customListener;

  ///VoidCallback to be called when animation is finished.
  final void Function(AnimatorState<T>)? endAnimationListener;

  ///Function to be called every time the status of the animation changes.
  ///
  ///The customListener is provided with an [AnimationStatus, AnimationSetup]
  ///object.
  final void Function(AnimationStatus, AnimatorState<T>)? statusListener;

  ///The build strategy currently used for one Tween. Animator widget rebuilds
  ///itself every time the animation changes value.
  ///
  ///The builder is provided with an [Animation] object.
  final Widget Function(
    BuildContext context,
    AnimatorState<T> animatorState,
    Widget? child,
  ) builder;

  ///Widget that you do not want to animate.
  ///It is the static part of the animated Widget.
  final Widget? child;
  // ///The build strategy currently used for multi-Tween. Animator widget rebuilds
  // ///itself every time the animation changes value.
  // ///
  // ///The `builderMap` is provided with an `Map<String, Animation>` object.
  // final Widget Function(Map<String, Animation>) builderMap;

  ///A linear interpolation between a beginning and ending value.
  ///
  ///`tweenMap` argument is used for multi-Tween animation.
  final Map<String, Tween<dynamic>>? tweenMap;

  ///The name of your Animator widget.
  ///Many widgets can have the same name.
  ///
  ///It is used to rebuild this widget from your logic classes
  // final dynamic name;

  /// The list of your logic classes you want to rebuild this widget from.
  // final List<StatesRebuilder> blocs;

  final AnimatorKey<T>? animatorKey;

  @override
  _AnimatorState<T> createState() => _AnimatorState<T>();
}

class _AnimatorState<T> extends State<Animator<T>> {
  /*
    Key? key,
    this.tween,
    this.tweenMap,
    
    this.resetAnimationOnRebuild = false,
    required this.builder,
    this.child,
    this.animatorKey,
    */
  late final animation = RM.injectAnimation(
    duration: widget.duration,
    curve: widget.curve ?? Curves.linear,
    repeats: widget.repeats ?? widget.cycles,
    shouldReverseRepeats:
        widget.repeats != null ? false : widget.cycles != null,
    shouldAutoStart: widget.triggerOnInit ?? true, //TODO check default value
    endAnimationListener: widget.endAnimationListener != null
        ? () => widget.endAnimationListener!(animatorState)
        : null,
  );
  late AnimatorState<T> animatorState;
  late VoidCallback customListener = () {
    widget.customListener!(animatorState);
  };
  late void Function(AnimationStatus) statusListener =
      (AnimationStatus status) {
    widget.statusListener!(status, animatorState);
  };
  @override
  void dispose() {
    if (widget.customListener != null) {
      animation.controller!.removeListener(customListener);
    }
    if (widget.statusListener != null) {
      animation.controller!.removeStatusListener(statusListener);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    throw On.animation(
      (_) {
        return widget.builder(context, animatorState, widget.child);
      },
    ).listenTo(
      animation,
      onInitialized: () {
        if (widget.customListener != null) {
          animation.controller!.addListener(customListener);
        }
        if (widget.statusListener != null) {
          animation.controller!.addStatusListener(statusListener);
        }
      },
    );
  }
}
