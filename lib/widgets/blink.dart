import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedBlink extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const AnimatedBlink({required this.child, required this.duration});

  @override
  _AnimatedBlinkState createState() => _AnimatedBlinkState();
}

class _AnimatedBlinkState extends State<AnimatedBlink> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: widget.duration);
    _animationController.repeat(); //todo fix it by using reverse
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
