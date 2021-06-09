## [3.1.0]
* add `AnimateWidget` for implicit and explicit animation.

## [3.0.0]
* update to null safety

## [2.0.2]
* update dependencies

## [2.0.1]
* update dependencies

## [2.0.0]
## Breaking changes:
* Remove explicit-like animation.
* Remove `BuilderMap`.
* Change the signature of the `builder` parameter.
    ```dart
    Animator<T>(
        builder : (BuildContext context, AnimatorKey animatorState, Widget child) {
            //to get animation value:
            final T value =  animatorState.value;
            //to get Animation object:
            final Animation<T> animation =  animatorState.animation;
            //to get AnimationController object:
            final AnimationController animation =  animatorState.controller;
            //to get animation value form tweenMap
            final R value =animatorState.getValue<R>('animName');
            //To get Animation object from tweenMap
            final Animation<R> value =animatorState.getAnimation<R>('animName');
        }
    )
    ```
## New features
* Add child parameter to `Animator` widget
* Add `AnimatorKey`. It is similar to Flutter global key. It allows to control the animation from outside the Animator widget it is associated with. #24.

Example:
```dart
final animatorKey = AnimatorKey();

//..
//..
Animator(
    animatorKey: animatorKey,
    builder: (context, anim, child) {
        //....
    }
)

//By default, the animation will not start when the Animator is inserted in the widget tree.
//To start the animation from some Button in the widget tree outside the builder of the Animator.

onPressed: (){
    animatorKey.triggerAnimation();

    //You can  forward, start, reverse animation
    animatorKey.controller.stop,
    

    //You can configure the animation online and reset the setting and restart the animation
    animatorKey.refreshAnimation(
        tween: Tween(...),//new tween
        duration : Duration(...),
        curve : Curve(...),
        repeats : ....,
        cycles : ...
    );

}
```

* Add the `AnimatorRebuilder` widget. It can subscribe to an “AnimatorKey”. It will be animated in synchronization with the Animator widget with which `animatorKey` is associated.

Example:

```dart
final animatorKey = AnimatorKey<T>(initialValue: 10);

//..
//..
Animator(
    animatorKey: animatorKey,
    builder: (context, anim, child) {
        //....
    }
);
//

//In another place in the widget tree : 

AnimatorRebuilder(
    observe:()=> animatorKey,
    builder: (context, anim, child) {
        //....
        //this widget receives the same animation object of the Animator above.
    }
);
```

## [1.0.0+5].
1. Add Continuos integration and code coverage support.

## [1.0.0+3].
1. Update to use states_rebuilder: ^1.8.0

## [1.0.0+1].
1. Refactor code.
2. Fix typos.


## [1.0.0].
1. You can nest Animator Widget with different tween, duration and curve.
2. Refactor code and test it.
3. Explicit-like animation are used with `StateWithMixinBuilder` widget.
4. Update to use states_rebuilder: ^1.5.0.


## [0.1.4].
1. update to use states_rebuilder: ^1.3.2

## [0.1.3].
1. update to use states_rebuilder: ^1.3.1
2. Fiw typos

## [0.1.2].
1. update to use states_rebuilder: ^1.2.0
2. resetAnimationOnRebuild default to false.

## [0.1.1].
1. Remove animateOnRebuild and add triggerOnInit.
2. Improve the logic
3. Changed `stateID` to `name`

## [0.1.0].
1. Extend the functionality of Animator widget by the following arguments:
    * `customListener` and `statusListener`: to listen to the animation and animation status;
    * `animateOnRebuild` and `resetAnimationOnRebuild`: to control whether the animation should restart or reset when Animator widget is rebuilt;
    * `stateID` and `blocs` : to rebuild the Animator widget from the logic blocs using the states_builder package.

2. Fix some typos and improve the documentation

## [0.0.1] - initial release.

