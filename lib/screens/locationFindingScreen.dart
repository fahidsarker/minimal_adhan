import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';

class LocationFindingScreen extends StatelessWidget {
  const LocationFindingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/location_na.png', width: 156,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Finding Location...", style: context.textTheme.headline6,),
            ),
            const LinearProgressIndicator()
          ],
        ),
      ),
    );
  }
}
