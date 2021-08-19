import 'package:flutter/material.dart';
import 'package:minimal_adhan/models/dua/Dua.dart';
import 'package:minimal_adhan/prviders/duas_provider.dart';
import 'package:minimal_adhan/screens/dua/widgets/DuaRow.dart';
import 'package:minimal_adhan/screens/dua/widgets/SearchArea.dart';
import 'package:minimal_adhan/widgets/loading.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final duaProvider = context.read<DuaProvider>();
    return Scaffold(
      appBar: AppBar(
        title: SearchArea(
          (val) {
            setState(
              () {
                search = val;
              },
            );
          },
        ),
      ),
      body: FutureBuilder<List<Dua>>(
        future: duaProvider.searchDuas(search),
        builder: (_, snap) {
          final data = snap.data;
          if (data != null) {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemBuilder: (_, i) => ChangeNotifierProvider.value(
                  value: duaProvider, child: DuaRow(data[i])),
              itemCount: data.length,
            );
          } else {
            return Loading();
          }
        },
      ),
    );
  }
}
