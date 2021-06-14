part of 'animator.dart';

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
    Tween<T>? tween,
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
  Animator<T> animator;
  AnimatorStateImp({
    required this.injected,
    required this.animator,
  });
  final Map<String, Animation<dynamic>> _animationMap = {};
  Animation<T>? _animation;
  late Tween<T> _tween = animator.tween == null && (T == dynamic || T == double)
      ? Tween(begin: 0.0, end: 1.0) as Tween<T>
      : _tween = animator.tween!;

  late Map<String, Tween<dynamic>>? _tweenMap = animator.tweenMap;
  @override
  Animation<T> get animation {
    if (_animation != null) {
      return _animation!;
    }

    return _animation ??= _tween.animate(injected.curvedAnimation);
  }

  @override
  AnimationController get controller => injected.controller!;

  @override
  Animation<R> getAnimation<R>(String name) {
    assert(_tweenMap?.isNotEmpty == true);
    var anim = _animationMap[name];
    if (anim != null) {
      return anim as Animation<R>;
    }
    anim = _tweenMap![name]!.animate(injected.curvedAnimation);
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
    Tween<T>? tween,
    Map<String, Tween>? tweenMap,
    Duration? duration,
    Curve? curve,
    int? repeats,
    int? cycles,
  }) {
    if (tween != null) {
      _animation = null;
      _tween = tween;
    }
    if (tweenMap != null) {
      _animationMap.clear();
      _tweenMap = tweenMap;
    }
    if (curve != null) {
      _animation = null;
    }
    injected.resetAnimation(
      duration: duration,
      curve: curve,
      repeats: repeats ?? cycles,
      shouldReverseRepeats: repeats != null
          ? false
          : cycles != null
              ? true
              : null,
    );
  }

  @override
  void triggerAnimation({bool restart = false}) {
    injected.triggerAnimation(restart: restart);
  }

  void dispose() {
    _animation = null;
    _animationMap.clear();
  }
}
