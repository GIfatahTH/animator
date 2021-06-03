import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:states_rebuilder/states_rebuilder.dart' as sb;

///Implicitly animate any parameter that has a corresponding defined flutter
///tween.
///
///
class AnimateWidget extends StatefulWidget {
  final Duration duration;
  final Duration? reverseDuration;
  final Curve curve;
  final Curve? reverseCurve;
  final int? repeats;
  final int? cycles;
  final double lowerBound;
  final double upperBound;
  final double? initialValue;
  final AnimationBehavior animationBehavior;
  final void Function()? endAnimationListener;
  final bool triggerOnInit;
  final bool triggerOnRebuild;
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
    // shouldAutoStart: true,
    animationBehavior: widget.animationBehavior,
  );
  Animate? animate;
  @override
  void initState() {
    super.initState();
    if (widget.triggerOnInit)
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
        if (animate!._hasTween) {
          injectedAnimation.triggerAnimation();
        }
      });
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
  final sb.Animate animate;
  final sb.InjectedAnimation _injectedAnimation;
  bool _hasTween = false;

  Animation<double> get curvedAnimation => _injectedAnimation.curvedAnimation;
  Animate setCurve(Curve curve) {
    animate.setCurve(curve);
    return this;
  }

  Animate setReverseCurve(Curve curve) {
    animate.setReverseCurve(curve);
    return this;
  }

  Animate._(this.animate, this._injectedAnimation);

  ///Implicitly animate to the given value
  T? call<T>(T? value, [String name = '']) {
    return animate.call(value, name);
  }

  ///Set animation explicitly by defining the Tween.
  ///
  ///The callback exposes the currentValue value
  T? fromTween<T>(Tween<T?> Function(T? currentValue) fn, [String? name]) {
    _hasTween = true;
    return animate.fromTween(fn, name);
  }
}
