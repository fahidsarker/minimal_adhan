import 'dart:io';

import 'package:flutter/material.dart';

class PlatformDependentWidget extends StatelessWidget {
  final bool isAndroid;
  final bool isIOS;
  final Widget child;

  const PlatformDependentWidget({
    this.isAndroid = false,
    this.isIOS = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return isAndroid
        ? Platform.isAndroid
            ? child
            : Container()
        : isIOS
            ? Platform.isIOS
                ? child
                : Container()
            : Container();
  }
}
