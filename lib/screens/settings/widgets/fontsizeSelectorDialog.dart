import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/prviders/dependencies/DuaDependencyProvider.dart';
import 'package:provider/provider.dart';

class FontSizeSelector extends StatelessWidget {
  final bool arabic;

  const FontSizeSelector({required this.arabic});

  @override
  Widget build(BuildContext context) {
    final appLocale = context.appLocale;
    final duaDependency = context.watch<DuaDependencyProvider>();
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actions: [
        TextButton(
          onPressed: () {
            duaDependency.changeFontToDefault(isArabic: arabic);
            Navigator.pop(context);
          },
          child:  Text(appLocale.default_mode),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child:  Text(appLocale.close),
        ),
      ],
      title:
          Text(arabic ? appLocale.arabic_font_size : appLocale.other_font_size),
      content: SizedBox(
        height: context.height * 0.4,
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (arabic)
                Text(
                  'معاينة حجم الخط العربي',
                  style: TextStyle(
                    fontFamily: 'Lateef',
                    fontSize: duaDependency.arabicFontSize,
                  ),
                )
              else
                Text(
                  appLocale.preview_of_font,
                  style: TextStyle(fontSize: duaDependency.otherFontSize),
                ),
              const SizedBox(
                height: 16,
              ),
              Slider(
                min: 10,
                max: 70,
                value: arabic
                    ? duaDependency.arabicFontSize
                    : duaDependency.otherFontSize,
                onChanged: (val) => duaDependency.changeFontSize(
                  isArabic: arabic,
                  newSize: val,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
