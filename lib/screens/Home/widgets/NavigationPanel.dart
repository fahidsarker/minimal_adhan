import 'package:flutter/material.dart';

const DASHBOARD_NAVIGATION_ELEMENT_PER_ROW = 2;
class NavigationPanel extends StatelessWidget {

  final List<Widget> _children;
  final int totalRows;

  NavigationPanel._(this._children, this.totalRows);

  factory NavigationPanel.build ({required List<Widget> children}){
    if(children.length % DASHBOARD_NAVIGATION_ELEMENT_PER_ROW != 0){
      throw Exception('Invalid Child');
    }
    return NavigationPanel._(children, children.length~/DASHBOARD_NAVIGATION_ELEMENT_PER_ROW);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for(int i=0; i<totalRows; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _children[2*i],
              _children[2*i+1],
            ],
          ),
        SizedBox(height: 128,)
      ],
    );
  }
}
