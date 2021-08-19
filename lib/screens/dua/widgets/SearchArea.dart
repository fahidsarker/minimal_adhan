
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchArea extends StatelessWidget {
  final void Function(String) onChanged;

  SearchArea(this.onChanged);

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context)!;

    return Container(
      /*decoration: BoxDecoration(
        color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black).withOpacity(0.15),
        borderRadius: BorderRadius.circular(80),
      ),*/
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          //contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          hintText: appLocale.search
        ),
      ),
    );
  }
}

