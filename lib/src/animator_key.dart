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
  //{@macro animatorKey}
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
  Animation<T> get animation;

  @override
  T get value;
  @override
  Animation<R> getAnimation<R>(String name);
  @override
  R getValue<R>(String name);
}

class AnimatorKeyImp<T> implements AnimatorKey<T> {
  final T? initialValue;
  final Map<String, dynamic>? initialMapValue;

  AnimatorKeyImp(this.initialValue, this.initialMapValue);
  AnimatorState<T>? _animatorState;

  @override
  Animation<T> get animation => _animatorState!.animation;

  @override
  AnimationController get controller => _animatorState!.controller;

  @override
  Animation<R> getAnimation<R>(String name) {
    return _animatorState!.getAnimation(name);
  }

  @override
  R getValue<R>(String name) {
    if (_animatorState == null) {
      return initialMapValue![name] as R;
    }
    return _animatorState!.getValue(name);
  }

  @override
  void resetAnimation(
      {Tween<T>? tween,
      Map<String, Tween>? tweenMap,
      Duration? duration,
      Curve? curve,
      int? repeats,
      int? cycles}) {
    _animatorState!
      ..resetAnimation(
        tween: tween,
        tweenMap: tweenMap,
        duration: duration,
        curve: curve,
        repeats: repeats,
        cycles: cycles,
      )
      ..triggerAnimation(restart: true);
  }

  @override
  void triggerAnimation({bool restart = false}) {
    _animatorState!.triggerAnimation(restart: restart);
  }

  @override
  T get value {
    if (_animatorState == null) {
      return initialValue!;
    }
    return _animatorState!.value;
  }

  void _rebuild() {
    _observers.forEach((setState) => setState());
  }

  List<VoidCallback> _observers = [];

  VoidCallback addObserver(VoidCallback setState) {
    _observers.add(setState);
    return () => _observers.remove(setState);
  }
}

// ///Implementation of [AnimatorKey]
// class AnimatorKeyImp<T> implements AnimatorKey<T> {
//   ///Implementation of [AnimatorKey]
//   AnimatorKeyImp(this._initialValue, this._initialMapValue) {
//     _animatorState = AnimatorStateImp<T>(null, () {});
//   }

//   final T? _initialValue;

//   final Map<String, dynamic>? _initialMapValue;
//   late AnimatorStateImp<T> _animatorState;

//   // T initialValue;
//   // AnimatorKey({this.initialValue});
//   ///set the [AnimatorState] associated with this AnimatorKey
//   void setAnimatorState(AnimatorState<T> anim) {
//     _animatorState = anim as AnimatorStateImp<T>;
//   }

//   ///CallBack used to refresh animation.
//   void callbackRefreshAnim({
//     Tween<T?>? tween,
//     Map<String, Tween>? tweenMap,
//     Duration? duration,
//     Curve? curve,
//     int? repeats,
//     int? cycles,
//   }) =>
//       _animatorState
//         ..resetAnimation(
//           tween: tween ?? _animatorState.animator.tween,
//           tweenMap: tweenMap ?? _animatorState.animator.tweenMap,
//           duration: duration ?? _animatorState.animator.duration,
//           curve: curve ?? _animatorState.animator.curve,
//           repeats: repeats ?? _animatorState.animator.repeats,
//           cycles: cycles ?? _animatorState.animator.cycles,
//         )
//         ..triggerAnimation(restart: true);

//   ///Change animation setting and refresh it,
//   ///
//   ///By default animation is triggered. If you want the opposite
//   ///set [autoStart] to false
//   @override
//   @override
//   void resetAnimation(
//       {Tween<T?>? tween,
//       Map<String, Tween>? tweenMap,
//       Duration? duration,
//       Curve? curve,
//       int? repeats,
//       int? cycles}) {
//     callbackRefreshAnim(
//       tween: tween,
//       tweenMap: tweenMap,
//       duration: duration,
//       curve: curve,
//       repeats: repeats,
//       cycles: cycles,
//     );
//   }

//   @override
//   AnimationController get controller => _animatorState.controller;
//   @override
//   Animation<T> get animation => _animatorState.animation;
//   @override
//   T get value => _animatorState._controller != null
//       ? _animatorState.value
//       : _initialValue!;
//   //

//   @override
//   Animation<R> getAnimation<R>(String name) {
//     assert(_animatorState.animator.tweenMap != null);
//     return _animatorState.getAnimation<R>(name);
//   }

//   @override
//   R getValue<R>(String name) => _animatorState._controller != null
//       ? _animatorState.getValue<R>(name)
//       : _initialMapValue![name] as R;
//   //
//   @override
//   void triggerAnimation({bool restart = false}) {
//     _animatorState.triggerAnimation(restart: restart);
//   }


