part of 'animator.dart';

///{@template animatorKey}
///A kay that provides access to the [AnimatorState] of the [Animator] widget
///It is associated with.
///
///By using [AnimatorKey] you can start, stop, resume, add animation listener or
///add status animation listener to an [Animator] widget from outside.
///
///You can also reconfigure animation and restart is using the
///[AnimatorKey.refreshAnimation] method.
///{@endtemplate}
abstract class AnimatorKey<T> implements AnimatorState<T> {
  ///{@macro animatorKey}
  factory AnimatorKey(
      {T? initialValue, Map<String, dynamic>? initialMapValue}) {
    return AnimatorKeyImp<T>(initialValue, initialMapValue);
  }

  ///Trigger the animation.
  ///
  ///By default if animation is running and [triggerAnimation] is called again,
  ///it will be ignored.
  ///
  ///If animation is dismissed or completed, animation
  ///will be inverted and started.
  ///
  ///When restart parameter is set to true, animation will be reset and
  ///restarted.
  void triggerAnimation({bool restart = false});

  @override
  AnimationController get controller;
  @override
  Animation<T?> get animation;

  @override
  T get value;
  @override
  Animation<R> getAnimation<R>(String name);
  @override
  R getValue<R>(String name);

  ///Reconfigure and restart animation.
  ///
  ///If no parameter is defined, it will use the parameters defined in the
  ///[Animator] widget this [AnimatorKey] is associated with.
  ///
  ///Any defined non null parameter will override the same parameter in the
  ///[Animator] widget.
  ///
  ///By default animation will restart after reconfiguration. If you want not,
  ///set [autoStart] to false
  void refreshAnimation({
    Tween<T> tween,
    Map<String, Tween> tweenMap,
    Duration duration,
    Curve curve,
    int repeats,
    int cycles,
    bool autoStart = true,
  });
}

///Implementation of [AnimatorKey]
class AnimatorKeyImp<T> implements AnimatorKey<T> {
  ///Implementation of [AnimatorKey]
  AnimatorKeyImp(this._initialValue, this._initialMapValue) {
    _animatorState = AnimatorStateImp<T>(null, () {});
  }

  final T? _initialValue;

  final Map<String, dynamic>? _initialMapValue;
  late AnimatorStateImp<T> _animatorState;

  // T initialValue;
  // AnimatorKey({this.initialValue});
  ///set the [AnimatorState] associated with this AnimatorKey
  void setAnimatorState(AnimatorState<T> anim) {
    _animatorState = anim as AnimatorStateImp<T>;
  }

  ///CallBack used to refresh animation.
  late void Function({
    Tween<T>? tween,
    Map<String, Tween>? tweenMap,
    Duration? duration,
    Curve? curve,
    int? repeats,
    int? cycles,
  }) callbackRefreshAnim;

  ///Change animation setting and refresh it,
  ///
  ///By default animation is triggered. If you want the opposite
  ///set [autoStart] to false
  @override
  void refreshAnimation({
    Tween<T>? tween,
    Map<String, Tween>? tweenMap,
    Duration? duration,
    Curve? curve,
    int? repeats,
    int? cycles,
    bool autoStart = true,
  }) {
    callbackRefreshAnim(
      tween: tween,
      tweenMap: tweenMap,
      duration: duration,
      curve: curve,
      repeats: repeats,
      cycles: cycles,
    );
    if (autoStart) {
      triggerAnimation();
    }
  }

  @override
  AnimationController get controller => _animatorState.controller;
  @override
  Animation<T?> get animation => _animatorState.animation;
  @override
  T get value => _animatorState._animation?.value ?? _initialValue!;
  //

  @override
  Animation<R> getAnimation<R>(String name) {
    assert(_animatorState.animator.tweenMap != null);
    final result = _animatorState._animationMap[name] as Animation<R>?;

    return result ?? (_initialMapValue![name] as Animation<R>);
  }

  @override
  R getValue<R>(String name) => _animatorState.getValue<R>(name);
  //
  @override
  void triggerAnimation({bool restart = false}) {
    _animatorState.triggerAnimation(restart: restart);
  }

  void _rebuild() {
    _observers.forEach((setState) => setState());
  }

  List<VoidCallback> _observers = [];

  void addObserver(bool Function() setState) {
    _observers.add(setState);
  }

  void removeObserver(bool Function() setState) {
    _observers.remove(setState);
  }
}
