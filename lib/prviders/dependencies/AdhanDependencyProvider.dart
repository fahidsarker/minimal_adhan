import 'package:adhan/adhan.dart';
import 'package:minimal_adhan/helpers/adhan_dependencies.dart';
import 'package:minimal_adhan/helpers/notification/notifiers.dart';
import 'package:minimal_adhan/helpers/preferences.dart';
import 'package:minimal_adhan/prviders/dependencies/dependency_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdhanDependencyProvider extends DependencyProvider {
  final SharedPreferences preference;

  AdhanDependencyProvider(this.preference);

  int get madhabIndex => sharedPrefAdhanMadhabIndex.value;

  int get calMethodIndex => sharedPrefCalcIndex.value;

  int get highLatRuleIndex => sharedPrefAdhanHighLatRule.value;

  List<bool> get _visibility =>
      sharedPrefAdhanVisibility.map((e) => e.value).toList();

  List<int> get _manualCorrection =>
      sharedPrefAdhanManualCorrect.map((e) => e.value).toList();

  List<int> get _notifyIDs =>
      sharedPrefAdhanNotifyID.map((e) => e.value).toList();

  List<int> get _notifyBefore =>
      sharedPrefAdhanNotifyBefore.map((e) => e.value).toList();

  bool get showPersistant => sharedPrefAdhanShowPersistentNotify.value;

  Future changePersistantNotifyStatus({required bool newVal}) async {
    sharedPrefAdhanShowPersistentNotify.value = newVal;
    if (!newVal) {
      await cancelAllNotifications();
    } else {
      await createNotification(forcedSilent: true, reschedule: false);
    }
    notifyListeners();
  }

  CalculationParameters get params {
    final param = adhanCalculationMethods[calMethodIndex].getParameters();
    param.madhab = madhabs[madhabIndex];
    param.highLatitudeRule = highLatRules[highLatRuleIndex];
    return param;
  }

  int getNotifyBefore(int adhanType) {
    return _notifyBefore[adhanType];
  }

  String get paranName {
    return adhanCalculationMethodNames[calMethodIndex];
  }

  String get paranDesc {
    return adhanCalculationMethodDescs[calMethodIndex];
  }

  String get highLatRuleName {
    return highLatRulesNames[highLatRuleIndex];
  }

  String get highLatRuleDesc {
    return highLatRulesDescs[highLatRuleIndex];
  }

  bool getVisibility(int adhanID) {
    return _visibility[adhanID];
  }

  int getManualCorrection(int adhanIndex) {
    return _manualCorrection[adhanIndex];
  }

  int notifyID(int adhanType) {
    return _notifyIDs[adhanType];
  }

  void silentAll() => updateDataByRunning(() {
        for (final element in sharedPrefAdhanNotifyID) {
          element.value = 0;
        }
      });

  void changeMadhab(int newMadhabIndex) =>
      updateDataWithPreference(sharedPrefAdhanMadhabIndex, newMadhabIndex);

  void changeCalMethod(int newCalcMethod) =>
      updateDataWithPreference(sharedPrefCalcIndex, newCalcMethod);

  void changeHighLatRuleIndex(int newIndex) =>
      updateDataWithPreference(sharedPrefAdhanHighLatRule, newIndex);

  void changeVisibility(int adhanID, {required bool visible}) =>
      updateDataWithPreference(sharedPrefAdhanVisibility[adhanID], visible);

  void changeManualCorrection(int adhanID, int minute) =>
      updateDataWithPreference(sharedPrefAdhanManualCorrect[adhanID], minute);

  String get manualCorrectionAll {
    return _manualCorrection.toString();
  }

  void changeNotifyType(int adhanType, int newVal) =>
      updateDataWithPreference(sharedPrefAdhanNotifyID[adhanType], newVal);

  void changeNotifyDelay(int adhanType, int newVal) =>
      updateDataWithPreference(sharedPrefAdhanNotifyBefore[adhanType], newVal);
}
