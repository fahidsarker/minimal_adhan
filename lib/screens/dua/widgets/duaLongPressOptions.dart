import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minimal_adhan/helpers/duaHelper.dart';
import 'package:minimal_adhan/models/dua/DuaDetials.dart';
import 'package:minimal_adhan/prviders/duas_provider.dart';
import 'package:minimal_adhan/screens/feedback/feedbackTaker.dart';
import 'package:minimal_adhan/screens/feedback/form_links.dart';
import 'package:minimal_adhan/widgets/iconedTextButton.dart';
import 'package:minimal_adhan/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DuaLongPressOptions extends StatelessWidget {
  final int duaID;
  DuaLongPressOptions(this.duaID);

  void action(BuildContext context, String message, void Function() act) {
    act();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 500),
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final duaProvider = context.watch<DuaProvider>();
    final appLocale = AppLocalizations.of(context)!;
    return FutureBuilder<DuaDetails>(
      future: duaProvider.getDuaDetails(duaID),
      builder: (ctx, snap) {
        final data = snap.data;
        if (data == null) {
          return Loading();
        }
        return AlertDialog(
          title: Text(data.title),
          actions: [
            IconedTextButton(
              iconData: Icons.copy,
              text: appLocale.copy,
              color: Colors.black,
              onPressed: () => action(context, 'Copied to clipboard!',
                  () => copyDuaToClipBoard(data)),
            ),
            IconedTextButton(
              iconData: data.isFavourite
                  ? Icons.favorite_outlined
                  : Icons.favorite_outline,
              text: data.isFavourite
                  ? appLocale.remove_from_fav
                  : appLocale.add_to_fav,
              color: Colors.black,
              onPressed: () => action(
                  context,
                  data.isFavourite
                      ? 'Removed From Favourite'
                      : 'Added to favourite',
                  () => duaProvider.toggleFavourite(data.isFavourite, duaID)),
            ),
            IconedTextButton(
              iconData: Icons.report,
              text: appLocale.report_an_error,
              color: Colors.red,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_)=>FeedbackTaker(getDuaErrorReportForm(data.title))));
              },
            ),
          ],
        );
      },
    );
  }
}
