import 'package:flutter/material.dart';
import 'package:minimal_adhan/helpers/SQLHelper.dart';
import 'package:minimal_adhan/prviders/dependencies/DuaDependencyProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minimal_adhan/screens/dua/CategoryList.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/screens/dua/searchScreen.dart';
import 'package:minimal_adhan/screens/dua/widgets/SearchArea.dart';
import 'package:provider/provider.dart';
import '../../prviders/duas_provider.dart';
import 'package:sqflite/sqflite.dart';

class DuaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final duaDependency = context.watch<DuaDependencyProvider>();
    final appLocale = AppLocalizations.of(context)!;

    return FutureBuilder<Database>(
      future: getDatabase(),
      builder: (_, snapshot) {
        final data = snapshot.data;
        if (data != null) {
          final duaProvider = DuaProvider(data, appLocale, duaDependency);
          return Scaffold(
            appBar: AppBar(
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
                                  value: duaProvider, child: SearchScreen())));
                    },
                    icon: Icon(Icons.search))
              ],
            ),
            body: ChangeNotifierProvider(
              create: (_) => duaProvider,
              child: CategoryList(data),
            ),
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
