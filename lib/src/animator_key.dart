import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../animator.dart';

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
abstract class AnimatorKey<T> implements StatesRebuilder<T>, AnimatorState<T> {
  ///{@macro animatorKey}
  factory AnimatorKey({T initialValue, Map<String, dynamic> initialMapValue}) {
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
class AnimatorKeyImp<T> extends AnimatorStateImp<T> implements AnimatorKey<T> {
  ///Implementation of [AnimatorKey]
  AnimatorKeyImp(this._initialValue, this._initialMapValue) : super(null) {
    _animatorState = AnimatorStateImp<T>(null);
  }

  final T _initialValue;

  final Map<String, dynamic> _initialMapValue;
  AnimatorStateImp<T> _animatorState;

  ///Get the associated [AnimatorState]
  AnimatorStateImp<T> get animatorState => _animatorState;
  set animatorState(AnimatorStateImp<T> anim) {
    _animatorState = anim;
  }

  // T initialValue;
  // AnimatorKey({this.initialValue});
  ///set the [AnimatorState] associated with this AnimatorKey
  void setAnimatorState(AnimatorState<T> anim) {
    //dispose and copy observers from the default animation to the new one
    animatorState
        //   ..disposeAnim()
        .copy(anim as StatesRebuilder<dynamic>);

    animatorState = anim as AnimatorStateImp<T>;
  }

  ///CallBack used to refresh animation.
  void Function({
    Tween<T> tween,
    Map<String, Tween> tweenMap,
    Duration duration,
    Curve curve,
    int repeats,
    int cycles,
  }) callbackRefreshAnim;

  ///Change animation setting and refresh it,
  ///
  ///To start animation enchain it with [AnimatorState.triggerAnimation].
  @override
  void refreshAnimation({
    Tween<T> tween,
    Map<String, Tween> tweenMap,
    Duration duration,
    Curve curve,
    int repeats,
    int cycles,
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
  Animation<T> get animation => _animatorState.animation;
  @override
  T get value => animation?.value ?? _initialValue;
  //

  @override
  Animation<R> getAnimation<R>(String name) {
    return _animatorState.getAnimation<R>(name);
  }

  @override
  R getValue<R>(String name) => _animatorState.getValue<R>(name);
  //
  @override
  void triggerAnimation({bool restart = false}) {
    _animatorState.triggerAnimation(restart: restart);
  }

  @override
  void addObserver({ObserverOfStatesRebuilder observer, String tag}) {
    _animatorState.addObserver(observer: observer, tag: tag);
  }

  @override
  void removeObserver({ObserverOfStatesRebuilder observer, String tag}) {
    _animatorState.removeObserver(observer: observer, tag: tag);
  }
}
