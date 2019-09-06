import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'animator.dart';
import 'states_rebuilder_with_animator.dart';

abstract class IAnimationParameters<T> {
  Tween<T> _tween;
  Tween<T> get tween => _tween;
  set tween(Tween<T> tween) {
    _tween = tween;
    animatorBloc?.setTween(tween);
  }

  Duration _duration;
  Duration get duration => _duration;
  set duration(Duration duration) {
    _duration = duration;
    animatorBloc?.setDuration(duration);
  }

  Curve _curve;
  Curve get curve => _curve;
  set curve(Curve curve) {
    _curve = curve;
    animatorBloc?.setCurve(curve);
  }

  int _cycles;
  int get cycles => _cycles;
  set cycles(int cycles) {
    _cycles = cycles;
    animatorBloc?.setCycles(cycles);
  }

  int _repeats;
  int get repeats => _repeats;
  set repeats(int repeats) {
    _repeats = repeats;
    animatorBloc?.setRepeats(repeats);
  }

  Map<String, Tween<dynamic>> _tweenMap;
  Map<String, Tween<dynamic>> get tweenMap => _tweenMap;
  set tweenMap(Map<String, Tween<dynamic>> tweenMap) {
    _tweenMap = tweenMap;
    animatorBloc?.setTweenMap(tweenMap);
  }

  StatesRebuilderWithAnimator<T> animatorBloc;
}

class AnimationParameters<T> extends IAnimationParameters<T> {
  bool resetAnimationOnRebuild;
  bool triggerOnInit;
  Function(StatesRebuilderWithAnimator<T>) customListener;
  Function(StatesRebuilderWithAnimator<T>) endAnimationListener;
  Function(AnimationStatus, StatesRebuilderWithAnimator<T>) statusListener;
  Widget Function(Animation<T>) builder;
  Widget Function(Map<String, Animation>) builderMap;
  dynamic name;
  List<StatesRebuilder> blocs;

  bool hasBlocs;

  AnimationParameters(StatesRebuilderWithAnimator<T> animatorBloc$) {
    animatorBloc = animatorBloc$;
  }

  setAnimationParameters(Animator<T> widget) {
    if (widget == null) {
      widget = Animator<T>(
        builder: (_) => null,
      );
    }
    tween = widget.tween ?? Tween<double>(begin: 0, end: 1);
    tweenMap = widget.tweenMap;
    duration = widget.duration ?? Duration(milliseconds: 500);
    curve = widget.curve ?? Curves.linear;
    cycles = widget.cycles;
    repeats = widget.repeats;
    resetAnimationOnRebuild = widget.resetAnimationOnRebuild ?? false;
    customListener = widget.customListener;
    endAnimationListener = widget.endAnimationListener;
    statusListener = widget.statusListener;
    name = widget.name;
    blocs = widget.blocs;

    hasBlocs = blocs != null;
    triggerOnInit = widget.triggerOnInit ?? !hasBlocs;
  }
}
