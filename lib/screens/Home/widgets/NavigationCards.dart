import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/widgets/coloredCOntainer.dart';

import 'NavigationPanel.dart';

class NavigationCard extends StatelessWidget {

  Widget _getNavImage(String name, double size) => Image.asset(
    'assets/screen_icons/$name.png',
    width: size, fit: BoxFit.fitWidth,
  );

  final String label;
  final Widget? child;
  final String? imageURI;
  final void Function() onPressed;

  const NavigationCard({required this.label,  this.imageURI,  this.child,  required this.onPressed}): assert(!(imageURI == null && child == null), "Both image and child can not be null!");

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    final width = context.isLargeScreen ? context.width : min(
      156.0,
      (context.width - 50) / DASHBOARD_NAVIGATION_ELEMENT_PER_ROW,
    );

    final height = context.isLargeScreen ? null : width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: radius,
        onTap: onPressed,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: getColoredContainerColor(context),
            borderRadius: radius
          ),
          child: context.isLargeScreen ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                child ?? _getNavImage(imageURI!, 50),
                const SizedBox(width: 8,),
                Text(label, style: context.textTheme.headline6,)
              ],
            )
          ) : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  child ?? _getNavImage(imageURI!, width * 0.6),
                  const SizedBox(height: 8,),
                  Text(label, style: context.textTheme.headline6,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
