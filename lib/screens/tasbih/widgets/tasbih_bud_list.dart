import 'package:flutter/material.dart';
import 'package:minimal_adhan/screens/tasbih/widgets/tasbih_bud.dart';

class TasbihView extends StatelessWidget {

  final PageController _controller;


  TasbihView(this._controller);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        reverse: true,
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, __) {
          return const TasbihBud();
        },
        itemCount: null,

    );
  }
}
