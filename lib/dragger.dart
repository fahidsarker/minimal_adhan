import 'package:flutter/cupertino.dart';
import 'package:minimal_adhan/extensions.dart';

class Dragger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: context.width * 0.15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: context.secondaryColor,
      ),
    );
  }
}
