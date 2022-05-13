import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/helpers/gps_location_helper.dart';
import 'package:minimal_adhan/localization/supportedLangs.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/GlobalDependencyProvider.dart';
import 'package:minimal_adhan/prviders/locationProvider.dart';
import 'package:minimal_adhan/screens/settings/bottomsheets/AppLanguagePicker.dart';
import 'package:minimal_adhan/screens/settings/settingsScreen.dart';
import 'package:minimal_adhan/screens/welcome/widgets/pageViewModel.dart';
import 'package:minimal_adhan/widgets/coloredCOntainer.dart';
import 'package:minimal_adhan/widgets/loading.dart';
import 'package:provider/provider.dart';

const pageAnimateDUration = Duration(milliseconds: 400);

class WelcomeScreen extends StatefulWidget {
  final bool showWarning;
  final String build;

  const WelcomeScreen({required this.showWarning, required this.build});

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
    final locationProvider = context.watch<LocationProvider>();
    final appLocale = context.appLocale;
    final locationState = locationProvider.locationState;
    const defaultBodyTextStyle = TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
    );

    final pages = [
      PageViewModel(
        title: "Warning - ${widget.build} build",
        bodyWidget: Text(
          "Thank you for trying out the ${widget.build} build. There might be bugs and the app might be un-stable. We appreciate any feedback you provide.",
          style: defaultBodyTextStyle,
          textAlign: TextAlign.center,
        ),
        image: const Center(
          child: Icon(Icons.warning, size: 175, color: Colors.yellow,),
        ),
      ),
      PageViewModel(
        title: "As-salamu alaykum",
        bodyWidget: const Text(
          "Minimal Adhan\nOpen Source | Free | Privacy Focused",
          style: defaultBodyTextStyle,
          textAlign: TextAlign.center,
        ),
        image: Center(
          child: Image.asset(
            'assets/logo_256.png',
            height: 175,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      PageViewModel(
        title: "Your Adhan Companion",
        bodyWidget: const Text(
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
        ),),
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
              child: Text(getAppLocaleOf(context.appLocale.locale).lang),
            ),
          ],
        ),
      ),
      PageViewModel(
        title: appLocale.location,
        image: const Center(
            child: Icon(
          Icons.my_location,
          size: 175,
        ),),
        bodyWidget: Column(
          children: [
            Text(
              appLocale.location_permission_request_short,
              style: context.textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              appLocale.location_privacy_short,
              style: context.textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 8.0,
            ),
            if (locationState is LocationNotAvailable)
              if (locationState.cause ==
                  locationNACausePermissionDeniedForever)
                Text(
                  appLocale.permission_denied,
                  style:
                      context.textTheme.headline6?.copyWith(color: Colors.red),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    locationProvider.updateLocationWithGPS(background: false);
                  },
                  child: Text(appLocale.location_required),
                )
            else if (locationState is LocationFinding)
              const Loading()
            else if (locationState is LocationAvailable) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check,
                    color: Colors.greenAccent,
                  ),
                  const SizedBox(
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
            const SizedBox(
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
                maxLines: 1,
              ),
            ),
          ),
        ),
      ),
      if (locationState is LocationAvailable)
        PageViewModel(
          title: "Setup Complete",
          bodyWidget: const Text(
            "Click done to start your amazing experience!",
            style: defaultBodyTextStyle,
            textAlign: TextAlign.center,
          ),
          image: Center(
            child: Lottie.asset('assets/check_anim.json',
                width: 175, fit: BoxFit.contain, height: 175, reverse: true,),
          ),
        )
      else
        PageViewModel(
          title: "Location is not available",
          bodyWidget: const Text(
            "Are you sure you want to proceed without location?",
            style: defaultBodyTextStyle,
            textAlign: TextAlign.center,
          ),
          image: Center(
            child: Lottie.asset('assets/worning_anim.json',
                width: 175, fit: BoxFit.contain, height: 175, reverse: true,),
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
                physics: const BouncingScrollPhysics(),
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
                              curve: Curves.linear,);
                        }
                      },
                      child: const Text('Skip'),
                    ),
                  ),
                  const Spacer(),
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
                                    color: getColoredContainerColor(context),),),
                          ),
                        )
                    ],
                  ),
                  const Spacer(),
                  if (currentPage >= pages.length - 1)
                    TextButton(
                      onPressed: () {
                        globalProvider.welcomeComplete();
                      },
                      child: const Text('Done'),
                    )
                  else
                    TextButton(
                      onPressed: () {
                        pageController.animateToPage(currentPage + 1,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.linear,);
                      },
                      child: const Text('Next'),
                    ),
                ],
              ),
            )
          ],
        ),
      ),),
    );
  }
}
