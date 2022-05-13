import 'package:flutter/material.dart';
import 'package:minimal_adhan/models/dua/Dua.dart';
import 'package:minimal_adhan/prviders/duas_provider.dart';
import 'package:minimal_adhan/screens/dua/widgets/DuaRow.dart';
import 'package:minimal_adhan/screens/dua/widgets/SearchArea.dart';
import 'package:minimal_adhan/widgets/CheckedFutureBuilder.dart';
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
        elevation: 0,
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
      body: CheckedFutureBuilder<List<Dua>>(
        future: duaProvider.searchDuas(search),
        builder: (data) => ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (_, i) => ChangeNotifierProvider.value(
              value: duaProvider, child: Padding(
                padding:  EdgeInsets.only(top: i == 0 ? 16 : 0, bottom: i == data.length -1 ? 32 : 0),
                child: DuaRow(data[i]),
              ),),
          itemCount: data.length,
        ),
      ),
    );
  }
}
