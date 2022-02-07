import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/helpers/SQLHelper.dart';
import 'package:minimal_adhan/prviders/dependencies/DuaDependencyProvider.dart';
import 'package:minimal_adhan/prviders/duas_provider.dart';
import 'package:minimal_adhan/screens/dua/category_list.dart';
import 'package:minimal_adhan/screens/dua/searchScreen.dart';
import 'package:provider/provider.dart';

class DuaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final duaDependency = context.watch<DuaDependencyProvider>();
    final appLocale = context.appLocale;
    final duaProvider =
        DuaProvider(globalAppDatabase, appLocale, duaDependency);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          appLocale.dua,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider.value(
                    value: duaProvider,
                    child: SearchScreen(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: ChangeNotifierProvider(
        create: (_) => duaProvider,
        child: CategoryList(globalAppDatabase),
      ),
    );
  }
}
