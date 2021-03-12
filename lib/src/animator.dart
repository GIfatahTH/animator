import 'package:flutter/material.dart';
part 'state_builder.dart';
part 'animator_state.dart';
part 'animator_key.dart';
part 'animator_rebuilder.dart';

///Ticker mixin enumeration
enum TickerMixin {
  ///tickerProviderStateMixin
  tickerProviderStateMixin,

  ///singleTickerProviderStateMixin
  singleTickerProviderStateMixin,
}

///{@template animator}
///A facade widget that hide the complexity of setting animation in Flutter
///
///It allows you to easily implement almost all the available
///Animation in flutter
///{@endtemplate}
class Animator<T> extends StatelessWidget {
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
    this.tickerMixin,
    // this.observe,
  }) : super(key: key);

  ///A linear interpolation between a beginning and ending value.
  ///
  ///`tween` argument is used for one Tween animation.
  final Tween<T?>? tween;

  ///A span of time, such as 27 days, 4 hours, 12 minutes, and 3 seconds
  final Duration? duration;

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
  final Function(AnimatorState<T>)? customListener;

  ///VoidCallback to be called when animation is finished.
  final Function(AnimatorState<T>)? endAnimationListener;

  ///Function to be called every time the status of the animation changes.
  ///
  ///The customListener is provided with an [AnimationStatus, AnimationSetup]
  ///object.
  final Function(AnimationStatus, AnimatorState<T>)? statusListener;

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

  ///For performance reason the default tickerProvider is of type
  ///`singleTickerProviderStateMixin`.
  ///
  ///use `tickerProviderStateMixin` if many controllers use the same ticker.
  final TickerMixin? tickerMixin;

  // ///an [AnimatorKey] class to which you want [Animator] to subscribe.
  // final AnimatorKey<T> Function() observe;

  ///Return a copy of the this Animator widget with the
  ///defined parameter overrided
  Animator<T> copyWith({
    Tween<T>? tween,
    Map<String, Tween>? tweenMap,
    Duration? duration,
    Curve? curve,
    int? cycles,
    int? repeats,
    dynamic Function(AnimatorState<T>)? customListener,
    dynamic Function(AnimatorState<T>)? endAnimationListener,
    dynamic Function(AnimationStatus, AnimatorState<T>)? statusListener,
  }) {
    return Animator(
      key: key,
      tween: tween ?? this.tween,
      tweenMap: tweenMap ?? this.tweenMap,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      cycles: cycles ?? this.cycles,
      repeats: repeats ?? this.repeats,
      resetAnimationOnRebuild: resetAnimationOnRebuild,
      triggerOnInit: triggerOnInit,
      builder: builder,
      child: child,
      animatorKey: animatorKey,
      customListener: customListener,
      endAnimationListener: endAnimationListener,
      statusListener: statusListener,
      tickerMixin: tickerMixin,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _StateBuilder<Animator<T>>(
      (context, widget, ticker, setState) {
        final animatorState = AnimatorStateImp(this, setState)
          ..initAnimation(ticker);
        Animator<T> animator = widget;
        void resetAnimation({
          Tween<T>? tween,
          Map<String, Tween>? tweenMap,
          Duration? duration,
          Curve? curve,
          int? repeats,
          int? cycles,
        }) {
          animatorState
            ..disposeAnim()
            ..animator = animator.copyWith(
              tween: tween,
              tweenMap: tweenMap,
              duration: duration,
              curve: curve,
              repeats: repeats,
              cycles: cycles,
            )
            ..initAnimation(ticker);
        }

        if (animator.animatorKey != null) {
          (animator.animatorKey as AnimatorKeyImp<T>)
            ..setAnimatorState(animatorState)
            ..callbackRefreshAnim = ({
              Tween<T>? tween,
              Map<String, Tween>? tweenMap,
              Duration? duration,
              Curve? curve,
              int? repeats,
              int? cycles,
            }) {
              resetAnimation(
                tween: tween,
                tweenMap: tweenMap,
                duration: duration,
                curve: curve,
                repeats: repeats,
                cycles: cycles,
              );
            };
        }

        return _Builder(
          dispose: () {
            animatorState.disposeAnim();
          },
          didUpdateWidget: (oldWidget, newWidget) {
            animator = newWidget;
            if (resetAnimationOnRebuild) {
              animatorState
                ..disposeAnim()
                ..animator = animator
                ..initAnimation(ticker);
            }
            if (animator.animatorKey != null) {
              final key = animator.animatorKey! as AnimatorKeyImp<T>;
              key._observers =
                  (oldWidget.animatorKey as AnimatorKeyImp<T>)._observers;
              key
                ..setAnimatorState(animatorState)
                ..callbackRefreshAnim = ({
                  Tween<T>? tween,
                  Map<String, Tween>? tweenMap,
                  Duration? duration,
                  Curve? curve,
                  int? repeats,
                  int? cycles,
                }) {
                  resetAnimation(
                    tween: tween,
                    tweenMap: tweenMap,
                    duration: duration,
                    curve: curve,
                    repeats: repeats,
                    cycles: cycles,
                  );
                };
            }
          },
          builder: (context, widget) {
            return animator.builder(context, animatorState, child);
          },
        );
      },
      isSingleTicker: () {
        return !(tickerMixin == TickerMixin.tickerProviderStateMixin ||
            resetAnimationOnRebuild ||
            animatorKey != null);
      }(),
      widget: this,
    );
  }
}
