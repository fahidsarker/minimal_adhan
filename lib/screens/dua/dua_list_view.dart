import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minimal_adhan/models/dua/Dua.dart';
import 'package:minimal_adhan/prviders/dependencies/DuaDependencyProvider.dart';
import 'package:minimal_adhan/prviders/duas_provider.dart';
import 'package:minimal_adhan/screens/dua/widgets/DuaRow.dart';
import 'package:minimal_adhan/widgets/coloredCOntainer.dart';
import 'package:minimal_adhan/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:minimal_adhan/extensions.dart';

class DuaListScreen extends StatelessWidget {
  final int categoryID;
  final String categoryTitle;

  DuaListScreen(this.categoryID, this.categoryTitle);

  @override
  Widget build(BuildContext context) {
    final duaProvider = context.watch<DuaProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: FutureBuilder<List<Dua>>(
        future: duaProvider.getDuasOfCategory(categoryID),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty){
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (_, i) => DuaRow(snapshot.data![i]),
                itemCount: snapshot.data!.length,
              );
            } else{
              return Center(
                child: Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    color: getColoredContainerColor(context),
                    borderRadius: BorderRadius.circular(context.width-32)
                  ),
                  child: SvgPicture.asset('assets/box.svg', width: 128, fit: BoxFit.fitWidth,),
                ),
              );
            }
          } else {
            return Loading();
          }
        },
      ),
    );
  }
}
