import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'states_rebuilder_with_animator.dart';
import 'animation_parameters.dart';

const String TAG_ANIM = 'animationWithAnimator#2597442';

enum TickerMixin {
  tickerProviderStateMixin,
  singleTickerProviderStateMixin,
}

class Animator<T> extends StatefulWidget {
  ///A widget that allows you to easily implement almost all the available
  ///Animation in flutter
  Animator({
    Key key,
    this.tween,
    this.duration,
    this.curve: Curves.linear,
    this.cycles,
    this.repeats,
    this.resetAnimationOnRebuild: false,
    this.builder,
    this.builderMap,
    this.tweenMap,
    this.name,
    this.blocs,
    this.triggerOnInit,
    this.customListener,
    this.endAnimationListener,
    this.statusListener,
    this.tickerMixin,
  })  : assert(() {
          if (builder == null && builderMap == null) {
            throw Exception(
                'You have to define one of the "builder" or "builderMap" argument\n'
                ' - Define the "builder" argument if you have one Tween\n'
                ' - Define the "builderMap" argument if you have many Tweens');
          }
          if (builder != null && builderMap != null) {
            throw Exception(
                'You have to define either builder or "builderMap" argument. you can\'t define both\n'
                ' - Define the "builder" argument if you have one Tween\n'
                ' - Define the "builderMap" argument if you have many Tweens');
          }
          if (builderMap != null && tweenMap == null) {
            throw Exception(
                '"tweenMap" must not be null. If you have one tween use "builder" argument instead');
          }
          if (tweenMap != null && tween != null) {
            throw Exception(
                'Use either "tween" or "tweenMap". If you have one tween use "builder" argument instead');
          }
          if (tweenMap != null && builder != null) {
            throw Exception(
                'Use "builderMap" instead of "builder". If you have one tween use "tween" argument instead');
          }
          return true;
        }()),
        assert(name == null ||
            blocs != null), // blocs must not be null if the tag is given
        super(
          key: resetAnimationOnRebuild ? UniqueKey() : key,
        );

  ///A linear interpolation between a beginning and ending value.
  ///
  ///`tween` argument is used for one Tween animation.
  final Tween<T> tween;

  ///A span of time, such as 27 days, 4 hours, 12 minutes, and 3 seconds
  final Duration duration;

  ///An easing curve, i.e. a mapping of the unit interval to the unit interval.
  final Curve curve;

  ///The number of forward and backward periods the animation performs before stopping
  final int cycles;

  ///The number of forward periods the animation performs before stopping
  final int repeats;

  ///Whether the animation settings are reset when Animator widget
  ///is rebuilt. The default value is false.
  ///
  ///Animation settings are defined by the tween, duration and curve argument.
  final bool resetAnimationOnRebuild;

  ///Whether to start the animation when the Animator widget
  ///is inserted into the tree.
  final bool triggerOnInit;

  ///Function to be called every time the animation value changes.
  ///
  ///The customListener is provided with an [Animation] object.
  final Function(StatesRebuilderWithAnimator<T>) customListener;

  ///VoidCallback to be called when animation is finished.
  final Function(StatesRebuilderWithAnimator<T>) endAnimationListener;

  ///Function to be called every time the status of the animation changes.
  ///
  ///The customListener is provided with an [AnimationStatus, AnimationSetup] object.
  final Function(AnimationStatus, StatesRebuilderWithAnimator<T>)
      statusListener;

  ///The build strategy currently used for one Tween. Animator widget rebuilds
  ///itself every time the animation changes value.
  ///
  ///The builder is provided with an [Animation] object.
  final Widget Function(Animation<T>) builder;

  ///The build strategy currently used for multi-Tween. Animator widget rebuilds
  ///itself every time the animation changes value.
  ///
  ///The `builderMap` is provided with an `Map<String, Animation>` object.
  final Widget Function(Map<String, Animation>) builderMap;

  ///A linear interpolation between a beginning and ending value.
  ///
  ///`tweenMap` argument is used for multi-Tween animation.
  final Map<String, Tween<dynamic>> tweenMap;

  ///The name of your Animator widget.
  ///Many widgets can have the same name.
  ///
  ///It is used to rebuild this widget from your logic classes
  final dynamic name;

  /// The list of your logic classes you want to rebuild this widget from.
  final List<StatesRebuilder> blocs;

  ///For performance reason the default tickerProvider is of type `singleTickerProviderStateMixin`.
  ///
  ///use `tickerProviderStateMixin` if many controllers use the same ticker.
  final TickerMixin tickerMixin;

  @override
  _AnimatorState createState() => _AnimatorState<T>();
}

class _AnimatorState<T> extends State<Animator<T>> {
  StatesRebuilderWithAnimator<T> _animatorBloc;

  @override
  void initState() {
    super.initState();

    _animatorBloc = StatesRebuilderWithAnimator<T>(
        AnimationParameters<T>(_animatorBloc)..setAnimationParameters(widget));
  }

  @override
  Widget build(BuildContext context) {
    return StateWithMixinBuilder<TickerProvider>(
      mixinWith: widget.tickerMixin == TickerMixin.tickerProviderStateMixin
          ? MixinWith.tickerProviderStateMixin
          : MixinWith.singleTickerProviderStateMixin,
      tag: TAG_ANIM,
      models: [_animatorBloc],
      initState: (_, __, ticker) {
        _animatorBloc.shouldDisposeOnAnimationEnd = true;
        _animatorBloc.initAnimation(ticker);
      },
      dispose: (_, __, ___) => _animatorBloc.dispose(),
      builder: (_, __) {
        if (widget.builder != null) {
          return widget.builder(_animatorBloc.animation);
        }
        {
          return widget.builderMap(_animatorBloc.animationMap);
        }
      },
    );
  }
}
