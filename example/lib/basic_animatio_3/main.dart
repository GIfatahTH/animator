import 'package:example/basic_animatio_3/animated_positioned.dart';
import 'package:example/basic_animatio_3/staggered_animation_implicit.dart';
import 'package:flutter/material.dart';

import 'animated_size.dart';
import 'animated_container.dart';
import 'animated_padding.dart';
import 'staggered_animation.dart';

class BasicAnimation3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animator demo"),
      ),
      body: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  void goto(Widget page, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ElevatedButton(
            child: Text("Animated Container"),
            onPressed: () => goto(MyAnimatedContainer(), context),
          ),
          ElevatedButton(
            child: Text("Animated Padding"),
            onPressed: () => goto(MyAnimatedPadding(), context),
          ),
          ElevatedButton(
            child: Text("Animated Positioned"),
            onPressed: () => goto(MyAnimatedPositioned(), context),
          ),
          ElevatedButton(
            child: Text("Staggered Animation"),
            onPressed: () => goto(MyStaggeredWidget(), context),
          ),
          ElevatedButton(
            child: Text("Implicit Staggered Animation"),
            onPressed: () => goto(MyImplicitStaggeredWidget(), context),
          ),
          ElevatedButton(
            child: Text("Opacity Animation"),
            onPressed: () => goto(ImplicitAnimatedSize(), context),
          ),
        ],
      ),
    );
  }
}
