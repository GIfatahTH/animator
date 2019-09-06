import 'package:flutter/widgets.dart';

import 'animate.dart';



class AnimateMap {
  Map<String, Tween> _tweenMap = {};
  final Map<String, Animation> _animationMap = {};
  Map<String, Animation> get animationMap => _animationMap;

  Animate _baseAnimate;
  set baseAnimate(Animate baseAnimate) => _baseAnimate = baseAnimate;

  AnimateMap(Map<String, Tween> tweenMap, [Animate baseAnimate]) {
    _tweenMap = tweenMap ?? {};
    if (baseAnimate != null) {
      _baseAnimate = baseAnimate;
      intAnimation();
    }
  }

  intAnimation() {
    if (_baseAnimate != null) {
      _tweenMap?.forEach((k$, tween$) {
        _animationMap.addAll({
          k$: tween$.animate(CurvedAnimation(
              parent: _baseAnimate.controller, curve: _baseAnimate.curve))
        });
      });
    }
  }

  void setTweenMap(Map<String, Tween> tweenMap$) {
    if (_tweenMap.isEmpty) {
      _tweenMap = tweenMap$;
    } else {
      tweenMap$.forEach(
        (k$, tween$) {
          if (_tweenMap[k$] != null) {
            _tweenMap[k$].begin = tweenMap$[k$].begin;
            _tweenMap[k$].end = tweenMap$[k$].end;
          } else {
            _tweenMap[k$] = tween$;
            _animationMap.addAll({
              k$: tween$.animate(CurvedAnimation(
                  parent: _baseAnimate.controller, curve: _baseAnimate.curve))
            });
          }
        },
      );
      var tweenMapTemps$ = {};
      tweenMapTemps$.addAll(_tweenMap);
      tweenMapTemps$.forEach(
        (k$, tween$) {
          if (tweenMap$[k$] == null) {
            _tweenMap.remove(k$);
            _animationMap.remove(k$);
          }
        },
      );
    }
  }
}
