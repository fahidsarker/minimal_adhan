import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';

class UnknownErrorScreen extends StatelessWidget {
  const UnknownErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/warning.png',
              width: 156,
            ),
            Text(
              'UNKNOWN ERROR OCCURRED! Try re-installing the app from the play store',
              style: context.textTheme.headline6,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
