import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';

class SearchArea extends StatelessWidget {
  final void Function(String) onChanged;

  const SearchArea(this.onChanged);

  @override
  Widget build(BuildContext context) {
    final appLocale = context.appLocale;

    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        hintText: appLocale.search,
      ),
    );
  }
}
