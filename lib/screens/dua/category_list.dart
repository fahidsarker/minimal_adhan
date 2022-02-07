import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/main.dart';
import 'package:minimal_adhan/models/dua/category.dart';
import 'package:minimal_adhan/prviders/duas_provider.dart';
import 'package:minimal_adhan/screens/dua/dua_list_view.dart';
import 'package:minimal_adhan/widgets/CheckedFutureBuilder.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class CategoryList extends StatelessWidget {
  final Database db;

  const CategoryList(this.db);

  @override
  Widget build(BuildContext context) {
    final duaProvider = context.read<DuaProvider>();
    return CheckedFutureBuilder<List<DuaCategory>>(
      future: duaProvider.duaCategories,
      builder: (data) => ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, index) => Padding(
          padding: EdgeInsets.only(
            top: index == 0 ? 16 : 0,
            bottom: index == data.length - 1 ? 32 : 0,
          ),
          child: _CategoryItem(data[index], index),
        ),
        itemCount: data.length,
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final DuaCategory _category;
  final int index;

  const _CategoryItem(this._category, this.index);

  @override
  Widget build(BuildContext context) {
    final duaProvider = context.read<DuaProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider.value(
                value: duaProvider,
                child: DuaListScreen(_category.id, _category.title),
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? onLightCardColor
                : onDarkCardColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              if (index == 0)
                const Icon(
                  Icons.favorite,
                  size: 40,
                )
              else
                CircleAvatar(
                  backgroundColor: context.textTheme.headline6?.color,
                  child: Text(
                    NumberFormat('00', context.appLocale.locale).format(index),
                  ),
                ),
              const SizedBox(
                width: 8.0,
              ),
              Flexible(
                child: Text(
                  _category.title,
                  style: context.textTheme.headline1?.copyWith(
                    color: context.textTheme.headline6?.color,
                    fontSize: context.textTheme.headline4?.fontSize,
                    height: 1.2,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
