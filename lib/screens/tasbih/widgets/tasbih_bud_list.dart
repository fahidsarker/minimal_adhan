import 'package:flutter/material.dart';
import 'package:minimal_adhan/screens/tasbih/widgets/tasbih_bud.dart';

class TasbihView extends StatelessWidget {

  final PageController _controller;


  const TasbihView(this._controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: PageView.builder(
          reverse: true,
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          itemBuilder: (_, __) {
            return const TasbihBud();
          },
      ),
    );
  }
}
