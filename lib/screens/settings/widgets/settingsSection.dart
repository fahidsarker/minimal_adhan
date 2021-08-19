import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimal_adhan/screens/settings/widgets/SettingsTile.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/widgets/coloredCOntainer.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<SettingsTile> tiles;
  SettingsSection({required this.title, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: getColoredContainerColor(context),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(title: Text(title, style: TextStyle(color: context.accentColor),),),
          ...tiles,
        ],
      ),
    );
  }
}
