import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/models/Tasbih.dart';
import 'package:minimal_adhan/prviders/TasbihProvider.dart';
import 'package:minimal_adhan/screens/tasbih/create_tasbih/create_tasbih_dialog.dart';
import 'package:minimal_adhan/screens/tasbih/widgets/tasbih_tile.dart';
import 'package:minimal_adhan/widgets/CheckedFutureBuilder.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

class TasbihScreen extends StatelessWidget {
  const TasbihScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tasbihProvider = context.watch<TasbihProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasbih"),
      ), //todo add applocale

      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            builder: (_) => ChangeNotifierProvider.value(
                  value: tasbihProvider,
                  child: CreateTasbihScreen(),
                ),
            context: context),
        child: Icon(Icons.add),
      ),

      body: CheckedFutureBuilder<List<Tasbih>>(
        future: tasbihProvider.allTasbih,
        builder: (val) => ListView.builder(
          itemBuilder: (_, i) => TasbihTile(val[i]),
          itemCount: val.length,
        ),
      ),
    );
  }
}
