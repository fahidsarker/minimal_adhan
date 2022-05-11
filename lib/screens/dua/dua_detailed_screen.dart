import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/helpers/dua_helper.dart';
import 'package:minimal_adhan/models/dua/Dua.dart';
import 'package:minimal_adhan/models/dua/DuaDetials.dart';
import 'package:minimal_adhan/prviders/dependencies/DuaDependencyProvider.dart';
import 'package:minimal_adhan/prviders/duas_provider.dart';
import 'package:minimal_adhan/screens/feedback/feedbackTaker.dart';
import 'package:minimal_adhan/screens/feedback/form_links.dart';
import 'package:minimal_adhan/screens/settings/widgets/fontsizeSelectorDialog.dart';
import 'package:minimal_adhan/widgets/coloredCOntainer.dart';
import 'package:minimal_adhan/widgets/loading.dart';
import 'package:provider/provider.dart';

class DuaDetailsScreen extends StatefulWidget {
  final Dua dua;

  const DuaDetailsScreen(this.dua);

  @override
  _DuaDetailsScreenState createState() => _DuaDetailsScreenState();
}

class _DuaDetailsScreenState extends State<DuaDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final duaProvider = context.watch<DuaProvider>();
    final appLocale = context.appLocale;
    final duaDepend = context.watch<DuaDependencyProvider>();

    return FutureBuilder<DuaDetails>(
      future: duaProvider.getDuaDetails(widget.dua.id),
      builder: (_, snapshot) {
        final data = snapshot.data;
        if (data != null) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    duaProvider.toggleFavourite(data.isFavourite, data.id);
                  },
                  icon: Icon(
                    data.isFavourite ? Icons.favorite : Icons.favorite_outline,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (val) {
                    if (val == appLocale.copy) {
                      copyDuaToClipBoard(data);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copied!'),
                        ),
                      );
                    } else if (val == appLocale.report_an_error) {
                      context.push(
                        FeedbackTaker(
                          "Report a dua",
                          getDuaErrorReportForm(data.title),
                        ),
                      );
                    } else if (val == appLocale.arabic_font_size ||
                        val == appLocale.other_font_size) {
                      showDialog(
                        context: context,
                        builder: (_) => ChangeNotifierProvider.value(
                          value: duaDepend,
                          child: FontSizeSelector(
                            arabic: val == appLocale.arabic_font_size,
                          ),
                        ),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return {
                      appLocale.arabic_font_size,
                      appLocale.other_font_size,
                      appLocale.copy,
                      appLocale.report_an_error
                    }.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
              title: Text(data.title),
            ),
            body: _DuaDetailView(snapshot.data!),
          );
        } else {
          return const Scaffold(
            body: Loading(),
          );
        }
      },
    );
  }
}

class _DuaDetailView extends StatelessWidget {
  final DuaDetails _details;

  const _DuaDetailView(this._details);

  @override
  Widget build(BuildContext context) {
    Widget _duaContainer(Widget child) {
      return Container(
        decoration: BoxDecoration(
          color: getColoredContainerColor(context),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        child: child,
      );
    }

    final duaProvider = context.watch<DuaProvider>();
    final duaDependency = duaProvider.dependency;

    final headStyle = context.textTheme.headline1?.copyWith(
      fontSize: duaDependency.otherFontSize,
      color: context.textTheme.headline6?.color,
      fontWeight: FontWeight.normal,
    );
    final noteAndRefStyle = context.textTheme.bodyText1
        ?.copyWith(color: context.textTheme.headline6?.color?.withOpacity(0.5));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _duaContainer(
              SelectableText(
                _details.arabic,
                style: DefaultTextStyle.of(context).style.copyWith(
                      fontFamily: 'Lateef',
                      fontSize: duaDependency.arabicFontSize,
                    ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
            if (_details.transliteration != null) ...[
              _duaContainer(
                SelectableText(
                  _details.transliteration!,
                  style: headStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            if (_details.translation != null) ...[
              _duaContainer(
                SelectableText(
                  _details.translation!,
                  style: headStyle,
                  textAlign: TextAlign.center,
                ),
              )
            ],
            if (_details.notes.isNotEmpty) ...[
              _duaContainer(
                SelectableText(
                  _details.notes,
                  textAlign: TextAlign.center,
                  style: noteAndRefStyle,
                ),
              ),
            ],
            _duaContainer(
              SelectableText(
                _details.reference,
                textAlign: TextAlign.center,
                style: noteAndRefStyle,
              ),
            )
          ],
        ),
      ),
    );
  }
}
