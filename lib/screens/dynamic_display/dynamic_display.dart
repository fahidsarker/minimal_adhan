import 'package:flutter/cupertino.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/prviders/locationProvider.dart';
import 'package:minimal_adhan/screens/Home/Home.dart';
import 'package:minimal_adhan/screens/dynamic_display/widgets/dynamic_content.dart';

class DynamicDisplay extends StatelessWidget {

  final LocationProvider locationProvider;
  const DynamicDisplay(this.locationProvider);

  @override
  Widget build(BuildContext context) {
    return context.isLargeScreen ? LargeDisplayContent(locationProvider) : Home(locationProvider);
  }
}
