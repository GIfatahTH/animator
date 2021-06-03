import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

part 'animator_key.dart';
part 'animator_rebuilder.dart';
part 'animator_state.dart';
part 'child.dart';

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
  late final injectedAnimation = RM.injectAnimation(
    duration: widget.duration,
    curve: widget.curve ?? Curves.linear,
    repeats: widget.repeats ?? widget.cycles,
    shouldReverseRepeats:
        widget.repeats != null ? false : widget.cycles != null,
    shouldAutoStart:
        widget.triggerOnInit ?? (widget.animatorKey != null ? false : true),
    endAnimationListener: widget.endAnimationListener != null
        ? () => widget.endAnimationListener!(animatorState)
        : null,
    onInitialized: (injectedAnimation) {
      if (widget.animatorKey != null) {
        final key = widget.animatorKey as AnimatorKeyImp<T>;
        injectedAnimation.controller!.addListener(() => key._rebuild());
      }
      if (widget.customListener != null) {
        injectedAnimation.controller!.addListener(customListener);
      }
      if (widget.statusListener != null) {
        injectedAnimation.controller!.addStatusListener(statusListener);
      }
    },
  );
  late AnimatorState<T> animatorState;

  @override
  void initState() {
    super.initState();
    animatorState = AnimatorStateImp(
      injected: injectedAnimation,
      animator: widget,
    );
    final key = widget.animatorKey as AnimatorKeyImp<T>?;
    key?._animatorState = animatorState;
  }

  late VoidCallback customListener = () {
    widget.customListener!(animatorState);
  };
  late void Function(AnimationStatus) statusListener =
      (AnimationStatus status) {
    widget.statusListener!(status, animatorState);
  };

  @override
  void didUpdateWidget(covariant Animator<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final animatorImp = animatorState as AnimatorStateImp<T>;
    animatorImp.animator = widget;
    if (widget.resetAnimationOnRebuild) {
      animatorImp
        ..resetAnimation(
          tween: oldWidget.tween != widget.tween ? widget.tween : null,
          tweenMap:
              oldWidget.tweenMap != widget.tweenMap ? widget.tweenMap : null,
          repeats: oldWidget.repeats != widget.repeats ? widget.repeats : null,
          cycles: oldWidget.cycles != widget.cycles ? widget.cycles : null,
          curve: oldWidget.curve != widget.curve ? widget.curve : null,
          duration:
              oldWidget.duration != widget.duration ? widget.duration : null,
        )
        ..triggerAnimation(restart: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return On.animation(
      (animate) {
        animate.shouldAlwaysRebuild = true;
        return widget.builder(context, animatorState, widget.child);
      },
    ).listenTo(
      injectedAnimation,
      key: widget.key,
    );
  }
}
