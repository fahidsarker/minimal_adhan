import 'package:flutter/material.dart';
import 'package:minimal_adhan/prviders/dependencies/DuaDependencyProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/GlobalDependencyProvider.dart';
import 'package:provider/provider.dart';
import 'package:minimal_adhan/extensions.dart';

class FontSizeSelector extends StatelessWidget {
  final bool arabic;

  FontSizeSelector({required this.arabic});

  @override
  Widget build(BuildContext context) {
    final globalProvider = context.watch<GlobalDependencyProvider>();
    final appLocale = context.appLocale;
    final duaDependency = context.watch<DuaDependencyProvider>();
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actions: [
        TextButton(
          onPressed: () {
            duaDependency.changeFontToDefault(arabic);
            Navigator.pop(context);
          },
          child: Text('Default'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close'),
        ),
      ],
      title: Text(arabic ? appLocale.arabic_font_size : appLocale.other_font_size),
      content: Container(
        height: context.height * 0.4,
        child: SingleChildScrollView(
          child: Column(
            children: [
              arabic
                  ? Text(
                      'معاينة حجم الخط العربي',
                      style: TextStyle(
                          fontFamily: 'Lateef',
                          fontSize: duaDependency.arabicFontSize),
                    )
                  : Text(
                      'Preview Of Other Font sizes',
                      style: TextStyle(fontSize: duaDependency.otherFontSize),
                    ),
              SizedBox(
                height: 16,
              ),
              Slider(
                min: 10,
                max: 70,
                value: arabic
                    ? duaDependency.arabicFontSize
                    : duaDependency.otherFontSize,
                onChanged: (val) => duaDependency.changeFontSize(arabic, val),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
