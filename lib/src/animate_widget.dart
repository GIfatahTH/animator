import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:states_rebuilder/states_rebuilder.dart' as sb;

///Implicitly and explicitly animate its child.
///
///You set the animation parameters such as `duration`, `reverseDuration`, `curve`,
///`reverseCurve`; `lowerBound`, `upperBound`, `initialValue` and `animationBehavior`.
///
///You can set the number of repeats or cycle that animation will perform before
///stops.
///
///You can listen to animation end using `endAnimationListener`
///
///You can also control when the animation will starts by setting one of
///`triggerOnInit`, `triggerOnRebuild`, `resetOnRebuild`.
///
class AnimateWidget extends StatefulWidget {
  ///Animation duration
  final Duration duration;

  ///The length of time this animation should last when
  ///going in reverse.
  final Duration? reverseDuration;

  ///Animation curve, It defaults to Curves.linear
  final Curve curve;

  ///Animation curve to be used when the animation is going in reverse.
  final Curve? reverseCurve;

  ///The value at which this animation is deemed to be dismissed.

  final double lowerBound;

  ///The value at which this animation is deemed to be completed.

  final double upperBound;

  ///The AnimationController's value the animation start with.

  final double? initialValue;

  ///The behavior of the controller when [AccessibilityFeatures.disableAnimations] is true.

  final AnimationBehavior animationBehavior;

  /// The number of times the animation repeats (always from start to end).
  ///
  /// A value of zero means that the animation will repeats infinity.

  final int? repeats;

  ///The number of times the animation cycles, animation will repeat by
  ///alternating between begin and end on each repeat.
  ///
  ///A value of zero means that the animation will cycle infinity.
  final int? cycles;

  ///Callback to be fired after animation ends (After purge of repeats and cycle)
  final void Function()? endAnimationListener;

  ///When it is set to true, animation will auto start after first initialized.
  final bool triggerOnInit;

  ///When it is set to true, animation will try to trigger on rebuild.
  ///
  ///If animation is completed (stopped at the upperBound) then the animation
  ///is reversed, and if the animation is dismissed (stopped at the lowerBound)
  ///then the animation is forwarded. IF animation is running nothing will happen.
  final bool triggerOnRebuild;

  ///When set to true, animation will reset and restart from its lowerBound
  final bool resetOnRebuild;
  final Widget Function(
    BuildContext,
    Animate animate,
  ) builder;

  const AnimateWidget({
    Key? key,
    this.initialValue,
    this.lowerBound = 0.0,
    this.upperBound = 1.0,
    this.duration = const Duration(milliseconds: 500),
    this.reverseDuration,
    this.curve = Curves.linear,
    this.reverseCurve,
    this.repeats,
    this.cycles,
    this.endAnimationListener,
    this.animationBehavior = AnimationBehavior.normal,
    this.triggerOnInit = true,
    this.triggerOnRebuild = false,
    this.resetOnRebuild = false,
    required this.builder,
  }) : super(key: key);

  @override
  _AnimateWidgetState createState() => _AnimateWidgetState();
}

class _AnimateWidgetState extends State<AnimateWidget> {
  late sb.InjectedAnimation injectedAnimation = sb.RM.injectAnimation(
    initialValue: widget.initialValue,
    duration: widget.duration,
    reverseDuration: widget.reverseDuration,
    curve: widget.curve,
    reverseCurve: widget.reverseCurve,
    lowerBound: widget.lowerBound,
    upperBound: widget.upperBound,
    endAnimationListener: widget.endAnimationListener,
    repeats: widget.repeats ?? widget.cycles,
    shouldReverseRepeats: widget.repeats != null
        ? false
        : widget.cycles != null
            ? true
            : false,
    animationBehavior: widget.animationBehavior,
  );
  Animate? animate;
  @override
  void initState() {
    super.initState();
    if (widget.triggerOnInit)
      SchedulerBinding.instance!.addPostFrameCallback(
        (_) {
          if (animate!._hasTween) {
            injectedAnimation.triggerAnimation();
          }
        },
      );
  }

  @override
  void didUpdateWidget(covariant AnimateWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.triggerOnRebuild || widget.resetOnRebuild) {
      final repeatCounts = oldWidget.repeats != widget.repeats
          ? widget.repeats
          : oldWidget.cycles != widget.cycles
              ? widget.cycles
              : null;
      injectedAnimation
        ..resetAnimation(
          repeats: repeatCounts,
          shouldReverseRepeats:
              repeatCounts != null ? widget.repeats == null : null,
          curve: oldWidget.curve != widget.curve ? widget.curve : null,
          duration:
              oldWidget.duration != widget.duration ? widget.duration : null,
          reverseDuration: oldWidget.reverseDuration != widget.reverseDuration
              ? widget.reverseDuration
              : null,
          reverseCurve: oldWidget.reverseCurve != widget.reverseCurve
              ? widget.reverseCurve
              : null,
        )
        ..triggerAnimation(restart: widget.resetOnRebuild);
    }
  }

  @override
  Widget build(BuildContext context) {
    return sb.On.animation(
      (animate) {
        this.animate ??= Animate._(animate, injectedAnimation);
        return widget.builder(context, this.animate!);
      },
    ).listenTo(injectedAnimation);
  }
}

class Animate {
  final sb.Animate _animate;
  final sb.InjectedAnimation _injectedAnimation;
  bool _hasTween = false;

  Animation<double> get curvedAnimation {
    _hasTween = true;
    return _injectedAnimation.curvedAnimation;
  }

  AnimationController get controller => _injectedAnimation.controller!;

  Animate setCurve(Curve curve) {
    _animate.setCurve(curve);
    return this;
  }

  Animate setReverseCurve(Curve curve) {
    _animate.setReverseCurve(curve);
    return this;
  }

  Animate._(this._animate, this._injectedAnimation);

  ///Implicitly animate to the given value
  T? call<T>(T? value, [String name = '']) {
    return _animate.call(value, name);
  }

  ///Set animation explicitly by defining the Tween.
  ///
  ///The callback exposes the currentValue value
  T? fromTween<T>(Tween<T?> Function(T? currentValue) fn, [String? name]) {
    _hasTween = true;
    return _animate.fromTween(fn, name);
  }
}
