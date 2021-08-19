import 'package:adhan/adhan.dart';

const MADHABS = const [Madhab.hanafi, Madhab.shafi];


const CALCULATION_METHODS = const [
  CalculationMethod.muslim_world_league,
  CalculationMethod.egyptian,
  CalculationMethod.karachi,
  CalculationMethod.umm_al_qura,
  CalculationMethod.dubai,
  CalculationMethod.qatar,
  CalculationMethod.kuwait,
  CalculationMethod.moon_sighting_committee,
  CalculationMethod.singapore,
  CalculationMethod.north_america
];

const CALCULATION_METHOD_NAMES = const [
  'Muslim world league',
  'Egyptian',
  'Karachi',
  'Umm al qura',
  'Dubai',
  'Qatar',
  'Kuwait',
  'Moon sighting committee',
  'Singapore',
  'North america',
];

const CALCULATION_METHOD_DESCS = const [
  'Muslim World League. Fajr angle: 18, Isha angle: 17',
  'Egyptian General Authority of Survey. Fajr angle: 19.5, Isha angle: 17.5',
  'University of Islamic Sciences, Karachi. Fajr angle: 18, Isha angle: 18',
  'Umm al-Qura University, Makkah. Fajr angle: 18, Isha interval: 90. Note: you should add a +30 minute custom adjustment for Isha during Ramadan.',
  'Method used in UAE. Fajr and Isha angles of 18.2 degrees.',
  'Modified version of Umm al-Qura used in Qatar. Fajr angle: 18, Isha interval: 90.',
  'Method used by the country of Kuwait. Fajr angle: 18, Isha angle: 17.5',
  'Moonsighting Committee. Fajr angle: 18, Isha angle: 18. Also uses seasonal adjustment values.',
  'Method used by Singapore. Fajr angle: 20, Isha angle: 18.',
  'Referred to as the ISNA method. This method is included for completeness but is not recommended. Fajr angle: 15, Isha angle: 15',
];

const HIGHE_LAT_RULES = const [
  HighLatitudeRule.middle_of_the_night,
  HighLatitudeRule.seventh_of_the_night,
  HighLatitudeRule.twilight_angle
];

const HIGHE_LAT_RULES_NAMES = const [
  'Middle of the night',
  'Seventh of the night',
  'Twilight angle',
];

const HIGHE_LAT_RULES_DESCS = const [
  'Fajr will never be earlier than the middle of the night and Isha will never be later than the middle of the night',
  'Fajr will never be earlier than the beginning of the last seventh of the night and Isha will never be later than the end of the first seventh of the night',
  'Similar to Seventh of night, but instead of 1/7, the fraction of the night used is fajrAngle/60 and ishaAngle/60'
];
