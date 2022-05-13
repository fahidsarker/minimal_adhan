import 'package:flutter/material.dart';
import 'package:minimal_adhan/screens/Home/widgets/dashBoard.dart';

const DASHBOARD_NAVIGATION_ELEMENT_PER_ROW = 2;
class NavigationPanel extends StatelessWidget {

  final List<Widget> _children;
  final int totalRows;
  final ScrollController controller;

  const NavigationPanel._(this._children, this.totalRows, this.controller);

  factory NavigationPanel.build ({required ScrollController controller, required List<Widget> children}){
    if(children.length % DASHBOARD_NAVIGATION_ELEMENT_PER_ROW != 0){
      throw Exception('Invalid Children length - The length must be divisible by 2');
    }
    return NavigationPanel._(children, children.length~/DASHBOARD_NAVIGATION_ELEMENT_PER_ROW, controller);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      physics: const BouncingScrollPhysics(),
      children: [
        Container(
          height: DASHBOARD_TOP_HEIGHT,
        ),
        for(int i=0; i<totalRows; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _children[2*i],
              _children[2*i+1],
            ],
          ),
        const SizedBox(height: 128,)
      ],
    );
  }
}
