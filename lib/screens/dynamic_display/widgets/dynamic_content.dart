import 'package:flutter/material.dart';
import 'package:minimal_adhan/prviders/locationProvider.dart';
import 'package:minimal_adhan/screens/Home/Home.dart';
import 'package:minimal_adhan/screens/adhan/adhanScreen.dart';
import 'package:minimal_adhan/screens/dynamic_display/widgets/large_screen_side_bar.dart';
import 'package:minimal_adhan/extensions.dart';

class LargeDisplayContent extends StatefulWidget {
  final LocationProvider _locationProvider;

  const LargeDisplayContent(this._locationProvider);

  @override
  State<LargeDisplayContent> createState() => _LargeDisplayContentState();
}

class _LargeDisplayContentState extends State<LargeDisplayContent> {
  Widget currentScreen = const AdhanScreen();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var keyOne = GlobalKey<NavigatorState>();
    var keyTwo = GlobalKey<NavigatorState>();
    return SafeArea(
      child: Row(
        children: [
          Expanded(
            flex: 40,
            child: Container(
              child: WillPopScope(
                onWillPop: () async =>
                    !(await keyOne.currentState?.maybePop() ?? true),
                child: Navigator(
                  key: keyOne,
                  onGenerateRoute: (routeSettings) {
                    return MaterialPageRoute(
                      builder: (context) => Home(
                        widget._locationProvider,
                        onNavigate: (child, index) {
                          if(index != selectedIndex){
                            setState(
                                  () {
                                currentScreen = child;
                                selectedIndex = index;
                              },
                            );
                          }
                        }
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Container(
            height: context.height,
            width: 1,
          ),
          Expanded(
            flex: 60,
            child: WillPopScope(
              onWillPop: () async =>
                  !(await keyTwo.currentState?.maybePop() ?? true),
              child: Navigator(
                key: keyTwo,
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(
                    builder: (context) => currentScreen,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
