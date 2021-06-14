part of 'animator.dart';

///Widget used to subscribe to a [AnimatorKey] and
///rebuild in sync with the [Animator] widget associated with the [AnimatorKey]
class AnimatorRebuilder<T> extends StatefulWidget {
  ///an [AnimatorKey] class to which you want [Animator] to subscribe.
  final AnimatorKey<T> Function() observe;

  ///The builder of the widget
  final Widget Function(
    BuildContext context,
    AnimatorKey animatorKey,
    Widget? child,
  ) builder;

  ///Widget that you do not want to animate.
  ///It is the static part of the animated Widget.
  final Widget? child;

  ///Widget used to subscribe to a [AnimatorKey] and rebuild in sync with
  ///the [Animator] widget associated with the [AnimatorKey]
  AnimatorRebuilder({
    Key? key,
    required this.observe,
    required this.builder,
    this.child,
  }) : super(key: key);

  @override
  _AnimatorRebuilderState<T> createState() => _AnimatorRebuilderState<T>();
}

class _AnimatorRebuilderState<T> extends State<AnimatorRebuilder<T>> {
  late final AnimatorKeyImp<T> animatorKey =
      widget.observe() as AnimatorKeyImp<T>;
  late VoidCallback disposer;
  @override
  void initState() {
    super.initState();
    disposer = animatorKey.addObserver(() => setState(() {}));
  }

  @override
  void dispose() {
    disposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      animatorKey,
      widget.child,
    );
  }
}
