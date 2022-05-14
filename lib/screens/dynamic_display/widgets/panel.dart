import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';

class Panel extends StatelessWidget {

  final Widget child;
  const Panel(this.child);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.panelWidth,
      child: MaterialApp(
        home: child,
      ),
    );
  }
}
