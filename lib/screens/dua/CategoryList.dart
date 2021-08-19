import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimal_adhan/helpers/SQLHelper.dart';
import 'package:minimal_adhan/main.dart';
import 'package:minimal_adhan/models/dua/category.dart';
import 'package:minimal_adhan/prviders/duas_provider.dart';
import 'package:minimal_adhan/screens/dua/dua_list_view.dart';
import 'package:sqflite/sqflite.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:provider/provider.dart';
import 'package:minimal_adhan/extensions.dart';

class CategoryList extends StatelessWidget {
  final Database db;

  CategoryList(this.db);



  @override
  Widget build(BuildContext context) {
    final duaProvider = context.read<DuaProvider>();
    return FutureBuilder<List<DuaCategory>>(
      future: duaProvider.duaCategories,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemBuilder: (_, index) =>
                _CategoryItem(snapshot.data![index], index),
            itemCount: snapshot.data!.length,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final DuaCategory _category;
  final int index;

  _CategoryItem(this._category, this.index);

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
                  child: DuaListScreen(_category.id, _category.title)),
            ),
          );
        },
        child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? onLightCardColor
                    : onDarkCardColor,
                borderRadius: BorderRadius.circular(8.0)),
            child: Row(
              children: [
                index == 0
                    ? Icon(Icons.favorite, size: 40,)
                    : CircleAvatar(
                        child: Text(NumberFormat('00',context.appLocale.locale).format(index)),
                        backgroundColor: context.textTheme.headline6?.color,
                      ),
                SizedBox(
                  width: 8.0,
                ),
                Flexible(
                  child: Text(
                    _category.title,
                    style: context.textTheme.headline1?.copyWith(
                        color: context.textTheme.headline6?.color,
                        fontSize: context.textTheme.headline4?.fontSize,
                    height: 1.2,),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
