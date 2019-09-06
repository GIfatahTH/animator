import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'animate.dart';
import 'animate_map.dart';
import 'animator.dart';
import 'animation_parameters.dart';

class StatesRebuilderWithAnimator<T> extends StatesRebuilder
    implements ListenerOfStatesRebuilder {
  Animate<T> _animate;
  AnimateMap _animateMap;

  AnimationParameters<T> _animator;
  IAnimationParameters<T> get animator => _animator;

  reSetAnimator(AnimationParameters<T> animator$) {
    _animator = animator$;
    _animate = Animate<T>(animator$.tween, animator$.duration, animator$.curve);
  }

  Animation<T> get animation => _animate?.animation;
  AnimationController get controller => _animate?.controller;
  Map<String, Animation> get animationMap => _animateMap?.animationMap;

  String _tagName;
  String _tagID;
  bool shouldDisposeOnAnimationEnd = false;

  TickerProvider _ticker;
  int _repeatCount;
  bool _isCycle;
  bool skipDismissStatus = false;

  Function(AnimationStatus) _statusListenerForRepeats;

  StatesRebuilderWithAnimator([AnimationParameters<T> animator$]) {
    if (animator$ == null) {
      reSetAnimator(AnimationParameters<T>(this)
        ..setAnimationParameters(null)
        ..triggerOnInit = false);
    } else {
      reSetAnimator(animator$);
    }

    _isCycle = _animator.repeats == null && _animator.cycles != null;
    _statusListenerForRepeats = _getStatusListenerCallBack();
  }

  void initAnimation([TickerProvider ticker]) {
    _ticker = ticker ?? _ticker;
    _animate.ticker = _ticker;
    _animate.setController(ticker);
    _animate.setAnimation();

    if (_animateMap == null) {
      if (_animator.tweenMap != null) {
        _animateMap = AnimateMap(_animator.tweenMap, _animate);
      }
    } else {
      _animateMap.baseAnimate = _animate;
      _animateMap.intAnimation();
    }

    _setRepeatCount(_animator.repeats, _animator.cycles);
    _addAnimationListeners();

    if (_animator.statusListener != null) {
      animation.addStatusListener(
          (status) => _animator.statusListener(status, this));
    }

    if (_animator.triggerOnInit == true) {
      triggerAnimation();
    }

    _addObserverToBloc();
  }

  _addAnimationListeners() {
    animation.addListener(() {
      rebuildStates([TAG_ANIM]);
    });
    if (_animator.customListener != null) {
      animation.addListener(() => _animator.customListener(this));
    }
  }

  void _setRepeatCount(int repeats, int cycles) {
    _repeatCount = repeats == null ? cycles ?? 1 : repeats;
    addAnimationStatusListener(_statusListenerForRepeats);
  }

  void setRepeats(int repeats$) {
    if (repeats$ == null) return;
    _isCycle = false;
    _setRepeatCount(repeats$, null);
  }

  void setCycles(int cycles$) {
    if (cycles$ == null) return;
    _isCycle = true;
    _setRepeatCount(null, cycles$);
  }

  void setDuration(Duration duration) {
    if (duration == null) return;
    _animate?.setDuration(duration);
  }

  void setCurve(Curve curve) {
    if (curve == null) return;
    _animate?.setCurve(curve);
  }

  void setTween<D>(Tween<D> tween) {
    if (tween == null) return;
    _animate?.setTween(tween);
  }

  void setTweenMap(Map<String, Tween> tweenMap) {
    if (tweenMap == null) return;
    if (_animateMap == null) {
      _animateMap = AnimateMap(tweenMap);
    } else {
      _animateMap.setTweenMap(tweenMap);
    }
  }

  void addAnimationStatusListener(void Function(AnimationStatus status) fn) {
    _animate?.removeStatusListener(fn);
    _animate?.addStatusListener(fn);
  }

  void removeAnimationStatusListener(void Function(AnimationStatus status) fn) {
    _animate?.removeStatusListener(fn);
  }

  void addAnimationListener(void Function() fn) {
    _animate?.removeAnimationListener(fn);
    _animate?.addAnimationListener(fn);
  }

  void removeAnimationListener(void Function() fn) {
    _animate?.removeAnimationListener(fn);
  }

  void endAnimationListener(void Function() fn) {
    _animator?.endAnimationListener = (_) {
      fn();
    };
  }

  void triggerAnimation({bool reset = false}) {
    if (reset) {
      skipDismissStatus = true;
      controller?.reset();
      skipDismissStatus = false;
    }
    if (animation.status == AnimationStatus.dismissed) {
      controller.forward();
    } else if (animation.status == AnimationStatus.completed) {
      if (!_isCycle) {
        controller.reset();
        controller.forward();
      } else {
        controller.reverse();
      }
    }
  }

  void _addObserverToBloc() {
    if (_animator.hasBlocs) {
      _tagName = _animator.name ?? "#@deFau_Lt${hashCode}TaG30";
      _tagID = shortHash(this) + UniqueKey().toString();
      _animator.blocs.forEach((b$) {
        b$.addObserver(tag: _tagName, tagID: _tagID, observer: this);
      });
    }
  }

  void _removeObserverFromBloc() {
    if (_animator.hasBlocs) {
      _animator.blocs.forEach((b$) {
        b$.removeObserver(
          tag: _tagName,
          tagID: _tagID,
        );
      });
    }
  }

  void dispose([bool cleanStatesRebuilder = true]) {
    _animate.disposeController();
    _animate.removeListeners();
    if (cleanStatesRebuilder) {
      _removeObserverFromBloc();
    }
  }

  @override
  void update() {
    _setRepeatCount(_animator.repeats, _animator.cycles);
    if (!_isCycle) {
      controller.reset();
      controller.forward();
    } else {
      if (animation.status == AnimationStatus.completed) {
        controller.reverse();
      } else {
        controller.reset();
        controller.forward();
      }
    }
  }

  Function(AnimationStatus) _getStatusListenerCallBack() {
    return (status) {
      if (status == AnimationStatus.completed ||
          (status == AnimationStatus.dismissed &&
              _isCycle &&
              !skipDismissStatus)) {
        if (_repeatCount == 1) {
          if (_animator.endAnimationListener != null) {
            _animator.endAnimationListener(this);
          }
          _setRepeatCount(_animator.repeats, _animator.cycles);
          if (!_animator.hasBlocs && shouldDisposeOnAnimationEnd) {
            _animate.disposeController();
          }
        } else {
          if (status == AnimationStatus.completed) {
            if (_repeatCount > 1) _repeatCount--;
            if (_isCycle) {
              controller.reverse();
            } else {
              controller.reset();
              controller.forward();
            }
          } else if (status == AnimationStatus.dismissed) {
            if (_repeatCount > 1) _repeatCount--;
            controller.forward();
          }
        }
      }
    };
  }
}
