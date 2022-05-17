# Minimal Adhan

<a href='https://play.google.com/store/apps/details?id=com.muhammadfahid.minimaladhan'> <img src="screenshots/get_play.svg" width="248"> </a>

</br>

<img src="logos/logo.png" width="248">

<br/>
An Open-Sourced Adhan app for the ummah.<br/>

<b> Built With FLutter </b>

![95%](https://progress-bar.dev/95/?title=Completed:&width=120&color=babaca&suffix=%)
![stability-wip](https://img.shields.io/badge/stability-work_in_progress-lightgrey.svg)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

<table>
  <tr>
    <td><img src = "screenshots/scrnsht.gif" width = 320/></td>
    <td><img src = "screenshots/light/2.png" width = 320/></td>
    <td><img src = "screenshots/light/3.png" width = 320/></td>
    <td><img src = "screenshots/light/4.png" width = 320/></td>
  </tr>
  
  <tr>
    <td><img src = "screenshots/dark/2.png" width = 320/></td>
    <td><img src = "screenshots/dark/3.png" width = 320/></td>
    <td><img src = "screenshots/dark/4.png" width = 320/></td>
    <td><img src = "screenshots/dark/1.png" width = 320/></td>
  </tr>
</table>

<hr></hr>

## Features

<ul>
  <li><h3> Zero Data Collection Without users concern </h3></li>
  <li> 
    Multiple language support 
    <ul>
      <li> <a href = "https://github.com/MuhammadFahidSarker/minimal_adhan/blob/master/lib/localization/langs/app_en.arb" > English </a></li>
      <li> <a href = "https://github.com/MuhammadFahidSarker/minimal_adhan/blob/master/lib/localization/langs/app_ar.arb" > Arabic </a></li>
      <li> <a href = "https://github.com/MuhammadFahidSarker/minimal_adhan/blob/master/lib/localization/langs/app_bn.arb" > Bangla </a></li>
      <li> Your contribution ❤️ </li>
    </ul>
  </li>
  <li>
    <b>Adhan Timings:</b>
    <ul>
      <li>5 Prayer Times </li>
      <li>Sunrise Time</li>
      <li>Midnight Time (For Qiam-ul-layl)</li>
      <li>Last Third of night Time (For Qiam-ul-layl)</li>
    </ul>
  </li>
  <li> Qibla Direction and compass </li>
  <li> Essential Duas with translations and transliteration in multiple languages </li>
  <li> Tasbih </li>
  <li> Mosque Finder </li>
  <li> 
    Able to configure adhan time calculation parameters 
    <ul>
      <li> Calculation methods </li>
      <li> Madhab (School of thoughts) </li>
      <li> High Latitude rules </li>
      <li> Adhan Visibility </li>
      <li> Manual Corrections </li>
      <li><a href = "https://github.com/iamriajul/adhan-dart"> See More </a> </li>
    </ul>
  </li>
  <li> Adhan Notification 
    <ul>
      <li>On Time Notification</li>
      <li>Persistent Notification</li>
    </ul>
  </li>
</ul>

<hr></hr>

## Development

<ul>
  <li>
    Dependencies:
    <ul>
      <li> <a href="https://pub.dev/packages/adhan/versions/" > adhan </a> </li>
      <li> <a href = "https://pub.dev/packages/geolocator/versions/" > geolocator </a></li>
      <li> <a href = "https://pub.dev/packages/intl/versions/" > intl </a></li>
      <li> <a href = "https://pub.dev/packages/auto_size_text/versions/" > auto_size_text </a></li>
      <li> <a href = "https://pub.dev/packages/webview_flutter" > webview_flutter </a></li>
      <li> <a href = "https://pub.dev/packages/provider/versions/" > provider </a></li>
      <li> <a href = "https://pub.dev/packages/hijri/versions" > hijri </a></li>
      <li> <a href = "https://pub.dev/packages/geocoding" > geocoding </a></li>
      <li> <a href = "https://pub.dev/packages/shared_preferences" > shared_preferences </a></li>
      <li> <a href = "https://pub.dev/packages/flutter_compass/versions/" > flutter_compass </a></li>
      <li> <a href = "https://pub.dev/packages/flutter_svg" > flutter_svg </a></li>
      <li> <a href = "https://pub.dev/packages/lottie" > lottie </a></li>
      <li> <a href = "https://pub.dev/packages/sqflite/versions" > sqflite </a></li>
      <li> <a href = "https://pub.dev/packages/scrollable_positioned_list/versions/" > scrollable_positioned_list </a></li>
      <li> <a href = "https://pub.dev/packages/package_info_plus/versions/" > package_info_plus </a></li>
      <li> <a href = "https://pub.dev/packages/android_alarm_manager_plus" > android_alarm_manager_plus </a></li>
      <li> <a href = "https://pub.dev/packages/flutter_local_notifications" > flutter_local_notifications </a></li>
      </ul>
  </li>
</u>

<hr></hr>

## Contribute to this project?

<hr></hr>

## Contributions
## Contribute to this project?
### Translating the app
1. Create an` app_<lang_code>.arb` (e.g. app_ar.arb) file in `minimal_adhan/locales/langs`
2. Copy contents of `minimal_adhan/locales/langs/app_lang_template.arb` to the newly created file.
3. Fill up the translations. You can find both description and english keyword/sentence in the description param of the keys. e.g:
   From:
```arb
{
  "@__________________________________________Global_Page": {
  },
  "locale": "",
  "@locale": {
    "description": "Name of Locale.",
    "eg_english": "en"
  },
  "direction": "",
  "@direction": {
    "description": "Language direction - Either Left-To-Right (ltr) or Right-To-left(rtl).",
    "eg_english": "ltr"
  },
  "current_lang": "",
  "@current_lang": {
    "description": "Name of this language in its language",
    "eg_english": "English"
  },
```
To:
```arb
{
  "@__________________________________________Global_Page": {
  },
  "locale": "ar",
  "@locale": {
    "description": "Name of Locale.",
    "eg_english": "en"
  },
  "direction": "rlt",
  "@direction": {
    "description": "Language direction - Either Left-To-Right (ltr) or Right-To-left(rtl).",
    "eg_english": "ltr"
  },
  "current_lang": "العربية",
  "@current_lang": {
    "description": "Name of this language in its language",
    "eg_english": "English"
  },
  "one": "١",
  "@one": {
    "description": "Translation of the digit 1",
    "eg_english": "1"
  },
```
4. Create an  `app_<lang_code>.dart` (keep the name same as the .arb file).
5. `import 'package:minimal_adhan/models/app_local.dart';`
6. Create a new class here named `Locale<LanguageName>` (e.g.  LocaleArabic) and extend the `AppLocale` class:
```dart
class LocaleArabic extends AppLocale{
}
```
7. Create a **const constructor** and pass the language code to the super block: `const LocaleArabic(): super('ar');`
8. Ovveride getter **languageName** :
```dart
  @override
  String get languageName => '(Beta) عربى';
```
9. Ovveride getter **duaElementsAvailable** (This tells the app if there is dua translations/transliterations available for this language):
```dart
  @override
  bool get duaElementsAvailable => false;
```
10. Ovveride the getter **fontFamily** (This is nullable and only return value if font is added to this app (see 'Add Custom Fonts' section ). otherwise, return null):
```dart
  @override
  String? get fontFamily => 'lateef';
```
11. Ovveride the function `TextTheme getTextTheme(BuildContext context)` and return a textTheme(it can be a default one i.e. `Theme.of(context).textTheme` or a modified one.):
```dart
@override
  TextTheme getTextTheme(BuildContext context){
    return context.textTheme
        .copyWith(
      headline1: context.textTheme.headline1?.copyWith(height: 1.0),
      headline5: context.textTheme.headline5?.copyWith(
        height: 1.0,
      ),
      headline6: context.textTheme.headline6?.copyWith(
        height: 1.5,
      ),
    )
        .apply(
      fontFamily: fontFamily,
    );
  }
```


### Translations

<ul>
<li>Arabic - Musaab Brother</li>
<li>Bangla - Rhyme Rubayet</li>
</ul>

### Icons

- <a href="https://www.flaticon.com/free-icons/islam" title="islam icons">Islam icons created by Freepik - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/mosque" title="mosque icons">Mosque icons created by Freepik - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/compass" title="compass icons">Compass icons created by Freepik - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/tasbih" title="tasbih icons">Tasbih icons created by Freepik - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/quran" title="Quran icons">Quran icons created by kmg design - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/dua" title="dua icons">Dua icons created by shmai - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/settings" title="settings icons">Settings icons created by Freepik - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/quran" title="Quran icons">Quran icons created by Andrean Prabowo - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/gps" title="gps icons">Gps icons created by adrianadam - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/warning" title="warning icons">Warning icons created by Freepik - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/random" title="random icons">Random icons created by Bamicon - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/mosque" title="mosque icons">Mosque icons created by Freepik - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/fajr" title="fajr icons">Fajr icons created by Freepik - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/cultures" title="cultures icons">Cultures icons created by Freepik - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/asr" title="asr icons">Asr icons created by Freepik - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/maghrib" title="maghrib icons">Maghrib icons created by Freepik - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/isha" title="isha icons">Isha icons created by Freepik - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/sunrise" title="sunrise icons">Sunrise icons created by Slidicon - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/nearby" title="nearby icons">Nearby icons created by Fuzzee - Flaticon</a>

<hr></hr>

## Lisence

<a href = "https://www.gnu.org/licenses/gpl-3.0.en.html"> GNU GPL V3 </a>

Full readme would be available as soon as the project hits stable stage.
