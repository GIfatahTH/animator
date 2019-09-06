import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class Animate<T> {
  AnimationController controller;
  Animation<T> get animation => _animation;
  Animation<T> _animation;
  Tween<T> _tween;
  Tween<T> get tween => _tween;

  Duration _duration;
  Duration get duration => _duration;

  Curve _curve;
  Curve get curve => _curve;
  List<void Function()> _animationListener = [];
  List<void Function(AnimationStatus)> _statusListener = [];

  Animate(Tween<T> tween, Duration duration, Curve curve) {
    this._tween = tween;
    this._duration = duration;
    this._curve = curve;
  }

  // void initAnimation([TickerProvider ticker]) {
  //   _ticker = ticker ?? _ticker;
  //   setController(ticker);
  //   setAnimation();
  // }

  TickerProvider ticker;

  void setController([TickerProvider ticker$]) {
    ticker = ticker$ ?? ticker;
    controller = AnimationController(duration: _duration, vsync: ticker);
  }

  void setAnimation() {
    _animation =
        _tween.animate(CurvedAnimation(parent: controller, curve: _curve));

    _animationListener.forEach((fn$) {
      _animation.addListener(fn$);
    });
    _statusListener.forEach((fn$) {
      _animation.addStatusListener(fn$);
    });
  }

  bool _isControllerDisposed() {
    return controller.toString().contains("DISPOSED");
  }

  addAnimationListener(void Function() listener$) {
    animation.addListener(listener$);
    _animationListener.add(listener$);
  }

  removeAnimationListener(void Function() listener$) {
    animation.removeListener(listener$);
    _animationListener.remove(listener$);
  }

  addStatusListener(void Function(AnimationStatus) listener$) {
    animation.addStatusListener(listener$);
    _statusListener.add(listener$);
  }

  removeStatusListener(void Function(AnimationStatus) listener$) {
    animation.removeStatusListener(listener$);
    _statusListener.remove(listener$);
  }

  void setDuration(Duration duration$) {
    if (_duration == duration$) return;
    disposeController();
    _duration = duration$;
    setController();
    setAnimation();
  }

  void setCurve(Curve curve$) {
    if (_curve == curve$) return;
    _curve = curve$;
    setAnimation();
  }

  void setTween<D>(Tween<D> tween$) {
    if (_tween == tween$) return;
    _tween.begin = tween$.begin as T;
    _tween.end = tween$.end as T;
  }

  disposeController() {
    if (!_isControllerDisposed()) {
      controller.dispose();
    }
  }

  removeListeners() {
    _animationListener.clear();
    _statusListener.clear();
  }
}
