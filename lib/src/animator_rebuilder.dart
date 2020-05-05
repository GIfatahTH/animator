import 'package:animator/animator.dart';
import 'package:flutter/widgets.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'package:animator/src/animator_key.dart';

class AnimatorRebuilder extends StatelessWidget {
  ///an [AnimatorKey] class to which you want [Animator] to subscribe.
  final AnimatorKey Function() observe;
  final Widget Function(
    BuildContext context,
    AnimatorKey animatorKey,
    Widget child,
  ) builder;
  final Widget child;
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
