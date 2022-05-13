import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/models/dua/Dua.dart';
import 'package:minimal_adhan/prviders/duas_provider.dart';
import 'package:minimal_adhan/screens/dua/dua_detailed_screen.dart';
import 'package:minimal_adhan/screens/dua/widgets/duaLongPressOptions.dart';
import 'package:minimal_adhan/widgets/coloredCOntainer.dart';
import 'package:provider/provider.dart';

class DuaRow extends StatelessWidget {
  final Dua dua;

  const DuaRow(this.dua);

  @override
  Widget build(BuildContext context) {
    final duaProvider = context.read<DuaProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => MultiProvider(
                      providers: [
                        ChangeNotifierProvider.value(
                          value: duaProvider.dependency,
                        ),
                        ChangeNotifierProvider.value(value: duaProvider)
                      ],
                      child: DuaDetailsScreen(dua),
                    ),),
          );
        },
        onLongPress: () => showDialog(
            context: context,
            builder: (_) => ChangeNotifierProvider.value(
                  value: duaProvider,
                  child: DuaLongPressOptions(dua.id),
                ),),
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          decoration: BoxDecoration(
              color: getColoredContainerColor(context),
              borderRadius: BorderRadius.circular(8.0),),
          child: Column(
            children: [
              const SizedBox(
                height: 8.0,
              ),
              Text(
                dua.title,
                textAlign: TextAlign.center,
                style: context.textTheme.headline1?.copyWith(
                    fontSize: context.textTheme.headline5?.fontSize,
                    color: context.textTheme.headline6?.color,
                    fontWeight: FontWeight.normal,),
              ),
              const SizedBox(
                height: 8.0,
              ),
              const Divider(
                thickness: 3.0,
              ),
              Text(
                dua.arabic,
                style: DefaultTextStyle.of(context).style.copyWith(
                      fontFamily: 'Lateef',
                      fontSize: 40,
                    ),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.rtl,
              )
            ],
          ),
        ),
      ),
    );
  }
}
