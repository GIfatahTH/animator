// part of 'animator.dart';

// ///Widget used to subscribe to a [AnimatorKey] and
// ///rebuild in sync with the [Animator] widget associated with the [AnimatorKey]
// class AnimatorRebuilder<T> extends StatelessWidget {
//   ///an [AnimatorKey] class to which you want [Animator] to subscribe.
//   final AnimatorKey<T> Function() observe;

//   ///The builder of the widget
//   final Widget Function(
//     BuildContext context,
//     AnimatorKey animatorKey,
//     Widget? child,
//   ) builder;

//   ///Widget that you do not want to animate.
//   ///It is the static part of the animated Widget.
//   final Widget? child;

//   ///Widget used to subscribe to a [AnimatorKey] and rebuild in sync with
//   ///the [Animator] widget associated with the [AnimatorKey]
//   AnimatorRebuilder({
//     Key? key,
//     required this.observe,
//     required this.builder,
//     this.child,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final animatorState = observe();
//     return _StateBuilder<AnimatorRebuilder>(
//       (context, widget, ticker, setState) {
//         final animatorKey = observe() as AnimatorKeyImp<T>;
//         animatorKey.addObserver(setState);
//         return _Builder(
//           dispose: () {
//             animatorKey.removeObserver(setState);
//           },
//           didUpdateWidget: (_, __) {},
//           builder: (context, widget) => widget.builder(
//             context,
//             animatorState,
//             child,
//           ),
//         );
//       },
//       widget: this,
//     );
//   }
// }
