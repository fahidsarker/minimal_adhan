import 'package:flutter/material.dart';
import 'package:minimal_adhan/prviders/locationProvider.dart';
import 'package:minimal_adhan/prviders/multi_panel_nav_provider.dart';
import 'package:minimal_adhan/screens/Home/Home.dart';
import 'package:minimal_adhan/screens/adhan/adhanScreen.dart';
import 'package:minimal_adhan/screens/dynamic_display/widgets/large_display_screen_content.dart';
import 'package:minimal_adhan/screens/dynamic_display/widgets/large_screen_side_bar.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:provider/provider.dart';

class LargeDisplayView extends StatelessWidget {
  final LocationProvider _locationProvider;

  const LargeDisplayView(this._locationProvider);



  @override
  Widget build(BuildContext context) {
    final keyOne = GlobalKey<NavigatorState>();
    final keyTwo = GlobalKey<NavigatorState>();
    final navProvider = MultiPanelNavProvider();
    navProvider.popALl=()=>keyTwo.currentState?.popUntil((route)=>route.isFirst);

    return SafeArea(
      child: Row(
        children: [
          Expanded(
            flex: (100 * (1 - context.contentPanelRatio)).toInt(),
            child: WillPopScope(
              onWillPop: () async =>
                  !(await keyOne.currentState?.maybePop() ?? true),
              child: Navigator(
                key: keyOne,
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(
                    builder: (context) => Home(
                      _locationProvider,
                      onNavigate: navProvider.navigate,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: context.height,
            width: 1,
          ),
          Expanded(
            flex: (100 * context.contentPanelRatio).toInt(),
            child: ChangeNotifierProvider.value(
              value: navProvider,
              child: LargeDisplayContent(keyTwo: keyTwo),
            ),
          ),
        ],
      ),
    );
  }
}
