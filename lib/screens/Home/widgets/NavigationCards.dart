import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/widgets/coloredCOntainer.dart';

class NavigationCard extends StatelessWidget {

  final String label;
  final Widget child;
  final void Function() onPressed;
  final double size;


  const NavigationCard({required this.label, required this.size, required this.child,  required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: radius,
        onTap: onPressed,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: getColoredContainerColor(context),
            borderRadius: radius
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  child,
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
