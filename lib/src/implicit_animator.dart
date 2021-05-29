import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart' as sb;

///Implicitly animate any parameter that has a corresponding defined flutter
///tween.
///
///
class ImplicitAnimator extends StatefulWidget {
  final Duration duration;
  final Curve curve;
  final int? repeats;
  final int? cycles;
  final void Function()? endAnimationListener;
  final Widget Function(
    BuildContext,
    Animate animate,
  ) builder;

  const ImplicitAnimator({
    Key? key,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.linear,
    this.endAnimationListener,
    this.repeats,
    this.cycles,
    required this.builder,
  }) : super(key: key);

  @override
  _ImplicitAnimatorState createState() => _ImplicitAnimatorState();
}

class _ImplicitAnimatorState extends State<ImplicitAnimator> {
  late sb.InjectedAnimation injectedAnimation = sb.RM.injectAnimation(
    duration: widget.duration,
    curve: widget.curve,
    endAnimationListener: widget.endAnimationListener,
    repeats: widget.repeats ?? widget.cycles,
    shouldReverseRepeats: widget.repeats != null
        ? false
        : widget.cycles != null
            ? true
            : false,
    shouldAutoStart: true,
  );
  Animate? animate;
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

  Animation<double> get curvedAnimation => _injectedAnimation.curvedAnimation;
  sb.Animate setCurve(Curve curve) {
    return animate.setCurve(curve);
  }

  sb.Animate setReverseCurve(Curve curve) {
    return animate.setReverseCurve(curve);
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
    return animate.fromTween(fn, name);
  }
}
