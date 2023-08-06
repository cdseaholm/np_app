import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppStyle {
  static const headingOne =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black);

  static const headingTwo =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black);
}

class DropDownAnimationArrow {
  late AnimationController _animationController;

  DropDownAnimationArrow(AnimationController animationController) {
    _animationController = animationController;
  }

  void toggleAnimation() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  Widget buildAnimatedIcon() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animationController.value * 0.5 * pi,
          child: const Icon(CupertinoIcons.arrow_down),
        );
      },
    );
  }

  void dispose() {}
}
