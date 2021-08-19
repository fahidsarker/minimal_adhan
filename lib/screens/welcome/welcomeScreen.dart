import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:minimal_adhan/helpers/GPS_location_helper.dart';
import 'package:minimal_adhan/localization/supportedLangs.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/DuaDependencyProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/GlobalDependencyProvider.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/screens/settings/bottomsheets/AppLanguagePicker.dart';
import 'package:minimal_adhan/screens/settings/bottomsheets/madhabChooser.dart';
import 'package:minimal_adhan/screens/settings/settingsScreen.dart';
import 'package:minimal_adhan/screens/welcome/widgets/pageViewModel.dart';
import 'package:minimal_adhan/widgets/coloredCOntainer.dart';
import 'package:minimal_adhan/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const pageAnimateDUration = const Duration(milliseconds: 400);

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int currentPage = 0;
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final globalProvider = context.watch<GlobalDependencyProvider>();
    final adhanDependency = context.watch<AdhanDependencyProvider>();
    final duaDependency = context.read<DuaDependencyProvider>();
    final appLocale = AppLocalizations.of(context)!;
    final locationState = adhanDependency.locationState;
    final defaultBodyTextStyle = const TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
    );

    final pages = [
      PageViewModel(
        title: "As-salamu alaykum",
        bodyWidget: Text(
          "Minimal Adhan\nOpen Source | Free | Privacy Focused",
          style: defaultBodyTextStyle,
          textAlign: TextAlign.center,
        ),
        image: Center(
          child: Image.asset(
            'assets/logo.png',
            height: 175,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      PageViewModel(
        title: "Your Adhan Companion",
        bodyWidget: Text(
          "Adhan Timing, Qibla Compass and Selection of duas in a single app.",
          style: defaultBodyTextStyle,
          textAlign: TextAlign.center,
        ),
        image: Center(child: Image.asset("assets/mosque.png", height: 175.0)),
      ),
      PageViewModel(
        title: "Language",
        image: const Center(
            child: Icon(
          Icons.language,
          size: 175,
        )),
        bodyWidget: Column(
          children: [
            Text(
              'To get started, choose a language.',
              style: context.textTheme.headline6,
            ),
            ElevatedButton(
              onPressed: () {
                buildBottomSheet(AppLanguagePicker(), context);
              },
              child: Text(getSupportedLangInfo(context.appLocale.locale, 'lang')
                  as String),
            ),
          ],
        ),
      ),
      PageViewModel(
        title: "Location",
        image: const Center(
            child: Icon(
          Icons.my_location,
          size: 175,
        )),
        bodyWidget: Column(
          children: [
            Text(
              appLocale.location_permison_request_short,
              style: context.textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              appLocale.location_privacy_short,
              style: context.textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 8.0,
            ),
            if (locationState is LocationNotAvailable)
              if (locationState.cause ==
                  LOCATION_NA_CAUSE_PERMISSION_DENIED_FOREVER)
                Text(
                  appLocale.permission_denied,
                  style:
                      context.textTheme.headline6?.copyWith(color: Colors.red),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    adhanDependency.updateLocationWithGPS(background: false);
                  },
                  child: Text(appLocale.location_required),
                )
            else if (locationState is LocationFinding)
              Loading()
            else if(locationState is LocationAvailable)
              ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check,
                      color: Colors.greenAccent,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      appLocale.location_found,
                      style: context.textTheme.headline6
                          ?.copyWith(color: Colors.greenAccent),
                    ),
                  ],
                ),
                Text(locationState.locationInfo.address),
              ],
          ],
        ),
      ),
      PageViewModel(
        title: appLocale.madhab,
        bodyWidget: Row(
          children: [
            Expanded(
              child: ListTile(
                title: Text(appLocale.hanafi_madhab),
                subtitle: Text(appLocale.hanafi_asr_desc),
                tileColor: adhanDependency.madhabIndex == 0
                    ? Colors.greenAccent
                    : getColoredContainerColor(context),
                onTap: () {
                  adhanDependency.changeMadhab(0);
                },
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: ListTile(
                title: Text(appLocale.shafi_madhab),
                subtitle: Text(appLocale.shafi_asr_desc),
                tileColor: adhanDependency.madhabIndex == 1
                    ? Colors.greenAccent
                    : getColoredContainerColor(context),
                onTap: () {
                  adhanDependency.changeMadhab(1);
                },
              ),
            ),
          ],
        ),
        image: Center(
          child: CircleAvatar(
            radius: 120,
            backgroundColor: getColoredContainerColor(context),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AutoSizeText(
                appLocale.adhan_asr,
                style: context.textTheme.headline1,
              ),
            ),
          ),
        ),
      ),
      if (locationState is LocationAvailable)
        PageViewModel(
          title: "Setup Complete",
          bodyWidget: Text(
            "Click done to start your amazing experience!",
            style: defaultBodyTextStyle,
            textAlign: TextAlign.center,
          ),
          image: Center(
            child: Lottie.asset('assets/check_anim.json',
                width: 175, fit: BoxFit.contain, height: 175, reverse: true),
          ),
        )
      else
        PageViewModel(
          title: "Location is not available",
          bodyWidget: Text(
            "Are you sure you want to proceed without location?",
            style: defaultBodyTextStyle,
            textAlign: TextAlign.center,
          ),
          image: Center(
            child: Lottie.asset('assets/worning_anim.json',
                width: 175, fit: BoxFit.contain, height: 175, reverse: true),
          ),
        )
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness:
            Theme.of(context).brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
          body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                physics: BouncingScrollPhysics(),
                children: pages,
                onPageChanged: (val) => setState(() {
                  currentPage = val;
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Opacity(
                    opacity: currentPage < pages.length - 1 ? 1 : 0,
                    child: TextButton(
                      onPressed: () {
                        if (currentPage < pages.length - 1) {
                          pageController.animateToPage(pages.length - 1,
                              duration: const Duration(milliseconds: 450),
                              curve: Curves.linear);
                        }
                      },
                      child: Text('Skip'),
                    ),
                  ),
                  Spacer(),
                  Wrap(
                    children: [
                      for (int i = 0; i < pages.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                                color: i == currentPage
                                    ? Colors.greenAccent
                                    : null,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: getColoredContainerColor(context))),
                          ),
                        )
                    ],
                  ),
                  Spacer(),
                  if (currentPage >= pages.length - 1)
                    TextButton(
                      onPressed: () {
                        globalProvider.welcomeComplete();
                      },
                      child: Text('Done'),
                    )
                  else
                    TextButton(
                      onPressed: () {
                        pageController.animateToPage(currentPage + 1,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.linear);
                      },
                      child: Text('Next'),
                    ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
