import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:minimal_adhan/extensions.dart';

class LocationFindingScreen extends StatelessWidget {
  const LocationFindingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset('assets/location_anim.json', width: context.width, fit:BoxFit.fitWidth),
    );
  }
}
