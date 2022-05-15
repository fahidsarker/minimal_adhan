import 'package:flutter/material.dart';
import 'package:minimal_adhan/prviders/multi_panel_nav_provider.dart';
import 'package:provider/provider.dart';

class LargeDisplayContent extends StatelessWidget {
  final GlobalKey<NavigatorState> keyTwo;
  const LargeDisplayContent({required this.keyTwo});

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<MultiPanelNavProvider>();

    return WillPopScope(
      onWillPop: () async =>
      !(await keyTwo.currentState?.maybePop() ?? true),
      child: Navigator(
        key: keyTwo,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => navProvider.currentPage,
          );
        },
      ),
    );
  }
}
