part of 'animator.dart';

///Implicitly animate any parameter that has a corresponding defined flutter
///tween.
///
///
class ImplicitAnimator extends StatelessWidget {
  final Duration duration;
  final Curve curve;
  final int? repeats;
  final int? cycles;
  final void Function()? endAnimationListener;
  final Widget Function(
    BuildContext,
    Animate animate,
  ) builder;

  const ImplicitAnimator({
    Key? key,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.linear,
    this.endAnimationListener,
    this.repeats,
    this.cycles,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _StateBuilder<ImplicitAnimator>(
      (context, w, ticker, setState) {
        ImplicitAnimator widget = w;
        bool isAnimating = false;
        bool? _isChanged;
        bool _isDirty = false;
        bool isInit = true;
        final _tweens = <String, Tween<dynamic>>{};
        final _curvedTweens = <String, Animatable<dynamic>>{};
        final assertionList = [];

        bool isCycle = false;
        bool skipDismissStatus = false;
        int repeatCount = 0;

        AnimationController _controller = AnimationController(
          duration: widget.duration,
          vsync: ticker,
        );

        final Function(AnimationStatus) repeatStatusListenerListener =
            (status) {
          if (status == AnimationStatus.completed ||
              (status == AnimationStatus.dismissed &&
                  isCycle &&
                  !skipDismissStatus)) {
            if (repeatCount == 1) {
              isAnimating = false;
              endAnimationListener?.call();

              WidgetsBinding.instance!.scheduleFrameCallback((_) {
                setState(); //TODO Check me. Used to trigger a rebuild after animation ends
              });
            } else {
              if (status == AnimationStatus.completed) {
                if (repeatCount > 1) repeatCount--;
                if (isCycle) {
                  _controller.reverse();
                } else {
                  _controller
                    ..value = 0
                    ..forward();
                }
              } else if (status == AnimationStatus.dismissed) {
                if (repeatCount > 1) repeatCount--;

                _controller.forward();
              }
            }
          }
        };

        _controller
          ..addListener(() {
            setState();
          })
          ..addStatusListener(repeatStatusListenerListener);

        T? _getValue<T>(String name) {
          try {
            final val = _curvedTweens[name]?.evaluate(_controller);
            return val;
          } catch (e) {
            if (e is TypeError) {
              //For tween that accept null value but when evaluated throw a Null
              //is not subtype of T (where T is the type). [Tween.transform]
              return null;
            }
            rethrow;
          }
        }

        T? _animateTween<T>(dynamic Function(T? begin) fn, String name) {
          T? currentValue = _getValue(name);
          if (isAnimating) {
            return currentValue;
          }
          assert(() {
            if (assertionList.contains(name)) {
              assertionList.clear();
              throw ArgumentError('Duplication of <$T> with the same name is '
                  'not allowed. Use distinct name');
            }
            assertionList.add(name);

            return true;
          }());

          final cachedTween = _tweens[name];
          final tween = fn(currentValue);
          if (tween == null) {
            return null;
          }

          if (isInit) {
            currentValue = tween.begin;
            _curvedTweens[name] = tween.chain(CurveTween(curve: widget.curve));
            _tweens[name] = tween;
            if (tween.begin == tween.end) {
              return tween.begin;
            }
            _isChanged = true;
            _isDirty = true;
          } else if ((cachedTween?.end != tween.end ||
                  cachedTween?.begin != tween.begin) &&
              _isDirty) {
            _curvedTweens[name] = tween.chain(CurveTween(curve: widget.curve));
            _tweens[name] = tween;
            _isChanged = true;
          }

          if (tween.begin == tween.end) {
            return tween.begin;
          }
          //At this point controller.value == 1 or 2
          assert(_controller.value == 0.0 || _controller.value == 1.0);
          return currentValue ?? tween.lerp(_controller.value);
        }

        T? animateValue<T>(T? value, [String name = '']) {
          name = '$T' + name;

          return _animateTween<T>(
            (begin) => _getTween(isInit ? value : begin, value),
            name,
          );
        }

        T? animateTween<T>(dynamic Function(T? begin) fn, [String name = '']) {
          name = 'Tween<$T>' + name + '_TwEeN_';
          return _animateTween(fn, name);
        }

        final Animate animate = Animate._(
          value: animateValue,
          formTween: animateTween,
        ).._controller = CurvedAnimation(parent: _controller, curve: curve);

        void triggerAnimation() {
          if (_isDirty && _isChanged == true) {
            _isChanged = false;
            _isDirty = false;
            isAnimating = true;
            skipDismissStatus = true;
            _controller.value = 0;
            skipDismissStatus = false;
            repeatCount = _setRepeatCount(widget.repeats, widget.cycles);
            isCycle = widget.repeats == null && widget.cycles != null;
            _controller.forward();
          }
        }

        return _Builder(
            dispose: () => _controller.dispose(),
            didUpdateWidget: (oldWidget, newWidget) {
              widget = newWidget;
              _controller.duration = newWidget.duration;
              animate._controller = CurvedAnimation(
                parent: _controller,
                curve: curve,
              );
              if (isAnimating) {
                isAnimating = false;
              }
              _isDirty = true;
            },
            builder: (context, widget) {
              final child = widget.builder(context, animate);
              assertionList.clear();
              isInit = false;
              triggerAnimation();
              return child;
            });
      },
      widget: this,
    );
  }
}

Tween<dynamic>? _getTween<T>(T? begin, T? end) {
  final val = begin ?? end;
  if (val == null) {
    return null;
  }
  if (val is double?) {
    return Tween(
      begin: begin as double?,
      end: end as double?,
    );
  }

  if (val is Color?) {
    return ColorTween(
      begin: begin as Color?,
      end: end as Color?,
    );
  }
  if (val is Offset?) {
    return Tween<Offset>(
      begin: begin as Offset?,
      end: end as Offset?,
    );
  }
  if (val is Size) {
    return SizeTween(
      begin: begin as Size?,
      end: end as Size?,
    );
  }

  if (val is AlignmentGeometry?) {
    return AlignmentGeometryTween(
      begin: begin as AlignmentGeometry?,
      end: end as AlignmentGeometry?,
    );
  }

  if (val is EdgeInsetsGeometry?) {
    return EdgeInsetsGeometryTween(
      begin: begin as EdgeInsetsGeometry?,
      end: end as EdgeInsetsGeometry?,
    );
  }

  if (val is Decoration?) {
    return DecorationTween(
      begin: begin as Decoration?,
      end: end as Decoration?,
    );
  }

  if (val is BoxConstraints?) {
    return BoxConstraintsTween(
      begin: begin as BoxConstraints?,
      end: end as BoxConstraints?,
    );
  }

  if (val is TextStyle?) {
    return TextStyleTween(
      begin: begin as TextStyle?,
      end: end as TextStyle?,
    );
  }

  if (val is Rect) {
    return RectTween(
      begin: begin as Rect?,
      end: end as Rect?,
    );
  }

  if (val is RelativeRect) {
    return RelativeRectTween(
      begin: begin as RelativeRect?,
      end: end as RelativeRect?,
    );
  }

  if (val is int) {
    return IntTween(
      begin: begin as int?,
      end: end as int?,
    );
  }

  if (val is BorderRadius?) {
    return BorderRadiusTween(
      begin: begin as BorderRadius?,
      end: end as BorderRadius?,
    );
  }

  if (val is ThemeData?) {
    return ThemeDataTween(
      begin: begin as ThemeData?,
      end: end as ThemeData?,
    );
  }

  if (val is Matrix4?) {
    return Matrix4Tween(
      begin: begin as Matrix4?,
      end: end as Matrix4?,
    );
  }

  throw UnimplementedError('The $T property has no built-in tween. '
      'Please use [Animate.fromTween] and define your tween');
}

class Animate {
  final T? Function<T>(T? value, [String name]) _value;
  final T? Function<T>(Tween<T?> Function(T? currentValue) fn, [String name])
      formTween;

  Animate._({
    required T? Function<T>(T? value, [String name]) value,
    required this.formTween,
  }) : _value = value;

  T? call<T>(T? value, [String name = '']) => _value.call<T>(value, name);
  late Animation<double> _controller;
  Animation<double> get curvedController => _controller;
}
