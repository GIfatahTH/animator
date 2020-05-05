import 'package:animator/animator.dart';
import 'package:flutter/widgets.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'package:animator/src/animator_key.dart';

///Widget used to subscribe to a [AnimatorKey] and
///rebuild in sync with the [Animator] widget associated with the [AnimatorKey]
class AnimatorRebuilder extends StatelessWidget {
  ///an [AnimatorKey] class to which you want [Animator] to subscribe.
  final AnimatorKey Function() observe;

  ///The builder of the widget
  final Widget Function(
    BuildContext context,
    AnimatorKey animatorKey,
    Widget child,
  ) builder;

  ///Widget that you do not want to animate.
  ///It is the static part of the animated Widget.
  final Widget child;

  ///Widget used to subscribe to a [AnimatorKey] and rebuild in sync with
  ///the [Animator] widget associated with the [AnimatorKey]
  AnimatorRebuilder({
    Key key,
    @required this.observe,
    @required this.builder,
    this.child,
  })  : assert(observe != null),
        assert(builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final animatorState = observe();
    assert(animatorState != null);
    return StateBuilder<dynamic>(
      observe: observe,
      builder: (context, _) {
        return builder(context, animatorState, child);
      },
    );
  }
}
