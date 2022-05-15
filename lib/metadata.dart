import 'extensions.dart';
import 'models/app_local.dart';

const DB_VERSION = 4;
const TOTAL_INSPIRATIONS = 3;

List<AppLocale> get supportedLocales => [
  const AppLocale('en', 'English', duaAvailable: true),
  AppLocale(
    'ar',
    '(Beta) عربى',
    duaAvailable: false,
    fontFamily: 'lateef',
    generateTextTheme: (context) => context.textTheme
        .copyWith(
          headline1: context.textTheme.headline1?.copyWith(height: 1.0),
          headline5: context.textTheme.headline5?.copyWith(
            height: 1.0,
          ),
          headline6: context.textTheme.headline6?.copyWith(
            height: 1.5,
          ),
        )
        .apply(fontFamily: 'Lateef'),
  ),
  AppLocale(
    'bn',
    'বাংলা (Beta)',
    duaAvailable: true,
    fontFamily: "BalooDa2",
    generateTextTheme: (context) => context.textTheme
        .copyWith(
          headline1: context.textTheme.headline1?.copyWith(height: 1.0),
          headline3: context.textTheme.headline3?.copyWith(height: 1.5),
          headline5: context.textTheme.headline5?.copyWith(
            height: 1.5,
          ),
          headline6: context.textTheme.headline6?.copyWith(
            height: 1,
          ),
        )
        .apply(
          fontFamily: 'BalooDa2',
        ),
  ),
];
