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
  factory AnimatorState(Animator<T> animator, void Function() rebuildStates) {
    return AnimatorStateImp<T>(animator, rebuildStates);
  }

  ///The [AnimationController] for an animation.
  ///
  ///It lets you perform tasks such as:
  ///* paly, reverse, stop animation
  ///* Set the animation to a specific.
  AnimationController get controller;

  ///The [Animation] object
  Animation<T?> get animation;

  ///get the animation of provided name
  ///
  ///It will throw if [Animator.tweenMap] is null
  Animation<R> getAnimation<R>(String name);

  ///The value of the [animation]
  T get value;

  ///The value map of the [Animator.tweenMap];
  R getValue<R>(String name);
}

///Implementation of [AnimatorState]
class AnimatorStateImp<T> implements AnimatorState<T> {
  void Function() rebuildStates;

  ///Implementation of [AnimatorState]
  AnimatorStateImp(Animator<T>? animator, this.rebuildStates) {
    if (animator != null) {
      this.animator = animator;
    }
  }

  ///The animator widget the AnimatorState is associated with
  late Animator<T> animator;
  //
  late AnimationController _controller;
  @override
  AnimationController get controller => _controller;
  //
  Animation<T?>? _animation;
  @override
  Animation<T?> get animation => _animation!;
  @override
  T get value => animation.value!;
  //
  Tween<T?> get _tween {
    return animator.tween ?? (Tween<double>(begin: 0, end: 1) as Tween<T>);
  }

  Duration get _duration => animator.duration!;
  Curve get _curve => animator.curve!;
  //
  late Map<String, Animation> _animationMap;

  @override
  Animation<R> getAnimation<R>(String name) {
    assert(animator.tweenMap != null);
    return _animationMap[name] as Animation<R>;
  }

  @override
  R getValue<R>(String name) {
    assert(animator.tweenMap != null);
    assert(_animationMap[name] != null);
    return _animationMap[name]!.value as R;
  }

  //
  bool get _triggerOnInit => animator.triggerOnInit != null
      ? animator.triggerOnInit!
      : animator.animatorKey != null
          ? false
          : true;
  //
  late int _repeatCount;
  late bool _isCycle;
  bool _skipDismissStatus = false;
  //
  final List<void Function(AnimationStatus)> _statusListener = [];
  late Function(AnimationStatus) _statusListenerForRepeats;

  ///initialize animation
  void initAnimation(TickerProvider ticker) {
    _isCycle = animator.repeats == null && animator.cycles != null;
    _statusListenerForRepeats = _getStatusListenerCallBack();

    _controller = AnimationController(
      duration: _duration,
      vsync: ticker,
    );
    _animation = _tween.animate(
      CurvedAnimation(
        parent: controller,
        curve: _curve,
      ),
    );
    if (animator.tweenMap != null) {
      _animationMap = animator.tweenMap!.map(
        (name, tween) => MapEntry(
          name,
          tween.animate(
            CurvedAnimation(parent: controller, curve: animator.curve!),
          ),
        ),
      );
    }

    _setRepeatCount(animator.repeats, animator.cycles);
    _addAnimationListeners();

    if (animator.statusListener != null) {
      animation.addStatusListener(
        (status) => animator.statusListener!(status, this),
      );
    }

    if (animator.animatorKey != null) {
      animation.addListener(
        () {
          (animator.animatorKey as AnimatorKeyImp)._rebuild();
        },
      );
    }

    if (_triggerOnInit == true) {
      triggerAnimation();
    }
  }

  void _addAnimationListeners() {
    animation.addListener(rebuildStates);
    if (animator.customListener != null) {
      animation.addListener(() => animator.customListener!(this));
    }
  }

  void _setRepeatCount(int? repeats, int? cycles) {
    _repeatCount = repeats == null ? cycles ?? 1 : repeats;
    _addAnimationStatusListener(_statusListenerForRepeats);
  }

  ///
  void _addAnimationStatusListener(void Function(AnimationStatus status) fn) {
    _removeStatusListener(fn);
    _addStatusListener(fn);
  }

  void _addStatusListener(void Function(AnimationStatus) listener) {
    animation.addStatusListener(listener);
    _statusListener.add(listener);
  }

  void _removeStatusListener(void Function(AnimationStatus) listener$) {
    animation.removeStatusListener(listener$);
    _statusListener.remove(listener$);
  }

  ///Start the animation
  void triggerAnimation({bool restart = false}) {
    if (restart) {
      _skipDismissStatus = true;
      controller.reset();
      _skipDismissStatus = false;
    }
    if (animation.status == AnimationStatus.dismissed) {
      controller.forward();
    } else if (animation.status == AnimationStatus.completed) {
      if (!_isCycle) {
        controller
          ..reset()
          ..forward();
      } else {
        controller.reverse();
      }
    }
  }

  ///close animation controller
  void disposeAnim() {
    if (!_isControllerDisposed()) {
      controller.dispose();
    }
    _statusListener.clear();
  }

  bool _isControllerDisposed() {
    return controller.toString().contains('DISPOSED');
  }

  void _disposeController() {
    if (!_isControllerDisposed()) {
      controller.dispose();
    }
  }

  Function(AnimationStatus) _getStatusListenerCallBack() {
    return (status) {
      if (status == AnimationStatus.completed ||
          (status == AnimationStatus.dismissed &&
              _isCycle &&
              !_skipDismissStatus)) {
        if (_repeatCount == 1) {
          if (animator.endAnimationListener != null) {
            animator.endAnimationListener!(this);
          }
          _setRepeatCount(animator.repeats, animator.cycles);
          if (animator.animatorKey == null &&
              animator.resetAnimationOnRebuild != true) {
            _disposeController();
          }
        } else {
          if (status == AnimationStatus.completed) {
            if (_repeatCount > 1) _repeatCount--;
            if (_isCycle) {
              controller.reverse();
            } else {
              controller
                ..reset()
                ..forward();
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
