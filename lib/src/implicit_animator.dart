part of 'animator.dart';

///Implicitly animate any parameter that has a corresponding defined flutter
///tween.
///
///
class ImplicitAnimator extends StatelessWidget {
  final Duration duration;
  final Curve curve;
  final void Function()? endAnimationListener;
  final Widget Function(
    BuildContext,
    T? Function<T>(T? value, [String name]) animate,
  ) builder;

  const ImplicitAnimator({
    Key? key,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.linear,
    this.endAnimationListener,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _StateBuilder<ImplicitAnimator>(
      (context, w, ticker, setState) {
        ImplicitAnimator widget = w;
        bool isAnimating = false;
        bool _isChanged = false;
        bool _isDirty = false;
        bool isInit = true;
        final _curvedTweens = <String, Animatable<dynamic>>{};
        final assertionList = [];

        AnimationController _controller = AnimationController(
          duration: widget.duration,
          vsync: ticker,
        );

        _controller
          ..addListener(() {
            setState();
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              isAnimating = false;
              endAnimationListener?.call();
            }
          });

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

        T? animate<T>(T? value, [String name = '']) {
          name = '$T' + name;
          T? oldValue = _getValue(name);
          if (isAnimating) {
            return oldValue;
          }

          assert(() {
            if (assertionList.contains(name)) {
              assertionList.clear();
              throw ArgumentError('Duplication of $T with the same name is '
                  'not allowed. Use distinct name');
            }
            assertionList.add(name);

            return true;
          }());

          if (value == null && oldValue == null) {
            return null;
          }

          if (isInit) {
            oldValue = value;
          }

          if (oldValue != value && _isDirty) {
            _isChanged = true;
          }

          final tween = _getTween<T?>(oldValue, value);

          _curvedTweens[name] = tween.chain(CurveTween(curve: widget.curve));

          return oldValue;
        }

        void triggerAnimation() {
          if (_isDirty && _isChanged) {
            _isChanged = false;
            _isDirty = false;
            isAnimating = true;
            _controller
              ..value = 0
              ..forward();
          }
        }

        return _Builder(
            dispose: () => _controller.dispose(),
            didUpdateWidget: (oldWidget, newWidget) {
              widget = newWidget;
              _controller.duration = newWidget.duration;
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

Tween<dynamic> _getTween<T>(T? begin, T? end) {
  final val = begin ?? end;
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
  if (val is int) {
    return IntTween(
      begin: begin as int?,
      end: end as int?,
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

  if (val is Matrix4?) {
    return Matrix4Tween(
      begin: begin as Matrix4?,
      end: end as Matrix4?,
    );
  }
  if (val is TextStyle?) {
    return TextStyleTween(
      begin: begin as TextStyle?,
      end: end as TextStyle?,
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

  throw UnimplementedError();
}
